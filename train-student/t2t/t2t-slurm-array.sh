#!/bin/bash

# Script to translate with tensor2tensor decoder and CUNI's models
# This script assumes that it is located in ${BERGAMOT_ROOT_DIR}/bin and
# sets BERGAMOT_ROOT_DIR based on its own path unless BERGAMOT_ROOT_DIR
# is set externally.
# Script by Ulrich Germann

#SBATCH -J "pl-en"
#SBATCH --account t2-cs119-sl4-gpu
#SBATCH --gres=gpu:1
#SBATCH --nodes=1
#SBATCH --time=12:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=jphilip@ed.ac.uk
#SBATCH --no-requeue
#SBATCH --partition pascal
#SBATCH --signal=B:USR1@300
#SBATCH --output=inference-pl-%A_%a.log
##SBATCH --array=0-35%1

if [[ "$SLURM_JOBID" != "" ]]; then
    module purge
    module load rhel7/default-gpu
    module unload cuda/8.0
    module load python/3.6 cuda/10.0 cudnn/7.5_cuda-10.0
fi

# activate tensorflow virtual environment
# source ${HOME}/bergamot/tensorflow-env/bin/activate
# source /fs/bil0/bergamot/venv/t2t.2/bin/activate
# source ~/venv/t2t.2/bin/activate
# source $VENV_DIR/st3.5/bin/activate
source ~/envs/student/bin/activate

# trap 'deactivate' EXIT

NBEST=8
ALPHA=1.0
usage(){
  echo "Usage: $0 [options] -M <model> -i <input directory> -d <device>"
  echo -e "\nDetails:\n"
  echo "Required arguments:" 
  echo "-M <model>: 4-letter code: <from><to>, e.g. csen, encs, ..."
  echo "-i <input directory>"
  echo "-t <dataset-type>: parallel or monolingual"
  # echo "-o <output file>"
  echo -e "\nOptional:\n"
  echo "-A <alpha>: t2t alpha parameter (Default: $ALPHA)"
  echo "-N <nbest>: size of n-best list: default is 8, maximum allowed is 16"
  echo "-B <batch size>: default is 256/nbest (assuming 11GB GPU RAM)"
}

fail(){
  1>&2 echo "$1. Run with -h for help."
  exit 1
}

while getopts "M:N:B:A:t:h" o; do
  case $o in
    A) ALPHA=$OPTARG;;
    M) MODEL=$OPTARG;;
    N) NBEST=$OPTARG;;
    t) DATASET_TYPE=$OPTARG;;
    B) BATCH_SIZE=$OPTARG;;
    [?]) fail "Unknown option $OPTARG.";;
    h) usage; exit 1;;
  esac
done

# export CUDA_VISIBLE_DEVICES=0

if [[ "$MODEL" == "" ]]; then fail "No model specified."; fi
if [[ "$DATASET_TYPE" == "" ]]; then fail "No dataset-type specified."; fi
#if [[ "$INPUT_FILE" == "" ]]; then fail "No input file specified."; fi
#if [[ "$OUTPUT_FILE" == "" ]]; then fail "No output file specified."; fi
if [[ "$NBEST" -gt 32 ]]; then fail "NBEST is unreasonably large (>32)."; fi

# BERGAMOT_ROOT_DIR=${BERGAMOT_ROOT_DIR:-$(dirname $(dirname $0))}
LOGFILE=${LOGFILE:-$OUTPUT_FILE.log}
#BATCH_SIZE=${BATCH_SIZE:-$((512/$NBEST))}
MAX_INPUT_SIZE=256


if [[ "$MODEL" == "encs" ]] ; then
  MODELDIR=/fs/bil0/bergamot/cuni/models/${MODEL}
  PROBLEM=translate_encs_wmt32k
  ENCODER_LAYERS=12
  BATCH_SIZE=${BATCH_SIZE:-16}
elif [[ "$MODEL" == "csen" ]] ; then
  MODELDIR=/fs/bil0/bergamot/cuni/models/${MODEL}
  PROBLEM=translate_encs_wmt32k_rev
  ENCODER_LAYERS=6
  BATCH_SIZE=${BATCH_SIZE:-16}
elif [[ "$MODEL" == "plen" ]] ; then
  MODELDIR=/home/$USER/rds/rds-t2-cs119/jerin/pl-en/t2t-models
  PROBLEM=translate_encs_wmt32k_rev
  ENCODER_LAYERS=6
  BATCH_SIZE=${BATCH_SIZE:-16}
fi

# if [[ -d $IDIR ]]; then
#     ifiles=$IDIR/c*.[0-9][0-9][0-9][0-9]
# else
#   ifiles=$IDIR
# fi

DATA_DIR="/rds/project/t2_vol4/rds-t2-cs119/jerin/pl-en"
OUTPUT_DIR="${DATA_DIR}/intermediate"
SHARD_DIR="${OUTPUT_DIR}/shards"
printf -v SHARD_ID "%02d" $SLURM_ARRAY_TASK_ID

if [ "$DATASET_TYPE" == "parallel" ]; then
    EXTRA_FSEG=".tsv"
else
    EXTRA_FSEG=""
fi

GZFILE=$SHARD_DIR/${DATASET_TYPE}${SHARD_ID}${EXTRA_FSEG}.pl.gz

LOCAL_WORKSPACE="/local/$USER"
mkdir -p $LOCAL_WORKSPACE
ifiles="$LOCAL_WORKSPACE/${DATASET_TYPE}${SHARD_ID}.pl"
zcat $GZFILE > $ifiles

echo $ifiles

for infile in $ifiles; do 
  echo $infile
  outfile=$infile.out
  [[ ! -e $outfile ]] || continue
  mkdir ${infile}.lock || continue
  logfile=$infile.log
  
  opts=(--model=transformer)
  opts+=(--hparams="num_encoder_layers=${ENCODER_LAYERS}")
  opts+=(--problem=$PROBLEM)
  opts+=(--hparams_set=transformer_big_single_gpu)
  opts+=(--data_dir=${MODELDIR})
  opts+=(--output_dir=${MODELDIR})
  opts+=(--decode_hparams="beam_size=$NBEST,alpha=$ALPHA,max_input_size=$MAX_INPUT_SIZE,return_beams=True")
  opts+=(--decode_from_file=$infile)
  opts+=(--decode_to_file=${outfile}_)

  echo "On host $(hostname)" > $logfile
  echo "t2t-decoder ${opts[@]}" >> $logfile
  t2t-decoder ${opts[@]} 2>> $logfile
  # echo "t2t-decoder ${opts[@]}"
  # t2t-decoder ${opts[@]} 
  succ=$?

  if [[ "$succ" == 0 ]]; then
    mv ${outfile}_ ${outfile}
    cat $outfile | pigz > $GZFILE.translated.en.gz
    rmdir ${infile}.lock
  else
    exit 1
  fi
done
