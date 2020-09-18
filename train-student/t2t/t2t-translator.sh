#!/bin/bash

# Script to translate with tensor2tensor decoder and CUNI's models
# This script assumes that it is located in ${BERGAMOT_ROOT_DIR}/bin and
# sets BERGAMOT_ROOT_DIR based on its own path unless BERGAMOT_ROOT_DIR
# is set externally.
# Script by Ulrich Germann

#SBATCH -J "t2t"
#SBATCH -A T2-CS107-GPU
#SBATCH --gres=gpu:1
#SBATCH --nodes=1
#SBATCH --time=36:00:00
#SBATCH --mail-type=ALL
##SBATCH --no-requeue
#SBATCH -p pascal
##SBATCH --signal=B:USR1@300
##SBATCH --output=train-model.log
##SBATCH --array=1-20%1

if [[ "$SLURM_JOBID" != "" ]]; then
    module purge
    module load rhel7/default-gpu
    module unload cuda/8.0
    module load python/3.6 cuda/10.0 cudnn/7.5_cuda-10.0
fi

# activate tensorflow virtual environment
# source ${HOME}/bergamot/tensorflow-env/bin/activate
# source /fs/bil0/bergamot/venv/t2t.2/bin/activate
source ~/venv/t2t.2/bin/activate

# trap 'deactivate' EXIT

NBEST=8
ALPHA=1.0
usage(){
  echo "Usage: $0 [options] -M <model> -i <input directory> -d <device>"
  echo -e "\nDetails:\n"
  echo "Required arguments:" 
  echo "-M <model>: 4-letter code: <from><to>, e.g. csen, encs, ..."
  echo "-i <input directory>"
  # echo "-o <output file>"
  echo -e "\nOptional:\n"
  echo "-A <alpha>: t2t alpha parameter (Default: $ALPHA)"
  echo "-N <nbest>: size of n-best list: default is 8, maximum allowed is 16"
  echo "-B <batch size>: default is 256/nbest (assuming 11GB GPU RAM)"
  # echo "-L <logfile>: default is <input file>.log"
  echo "-d <device>: device to use (sets CUDA_VISIBLE_DEVICES)"
}

fail(){
  1>&2 echo "$1. Run with -h for help."
  exit 1
}

while getopts "M:i:N:B:L:A:d:h" o; do
  case $o in
    A) ALPHA=$OPTARG;;
    M) MODEL=$OPTARG;;
    i) IDIR=$OPTARG;;
    N) NBEST=$OPTARG;;
    B) BATCH_SIZE=$OPTARG;;
    # L) LOGFILE=$OPTARG;;
    d) export CUDA_VISIBLE_DEVICES=$OPTARG;;
    [?]) fail "Unknown option $OPTARG.";;
    h) usage; exit 1;;
  esac
done

# export CUDA_VISIBLE_DEVICES=0

if [[ "$MODEL" == "" ]]; then fail "No model specified."; fi
#if [[ "$INPUT_FILE" == "" ]]; then fail "No input file specified."; fi
#if [[ "$OUTPUT_FILE" == "" ]]; then fail "No output file specified."; fi
if [[ "$NBEST" -gt 32 ]]; then fail "NBEST is unreasonably large (>32)."; fi

# BERGAMOT_ROOT_DIR=${BERGAMOT_ROOT_DIR:-$(dirname $(dirname $0))}
MODELDIR=/fs/bil0/bergamot/cuni/models/${MODEL}
LOGFILE=${LOGFILE:-$OUTPUT_FILE.log}
#BATCH_SIZE=${BATCH_SIZE:-$((512/$NBEST))}


if [[ "$MODEL" == "encs" ]] ; then
  PROBLEM=translate_encs_wmt32k
  ENCODER_LAYERS=12
  BATCH_SIZE=${BATCH_SIZE:-16}
elif [[ "$MODEL" == "csen" ]] ; then
  PROBLEM=translate_encs_wmt32k_rev
  ENCODER_LAYERS=6
  BATCH_SIZE=${BATCH_SIZE:-16}
fi

if [[ -d $IDIR ]]; then
    ifiles=$IDIR/c*.[0-9][0-9][0-9][0-9]
else
  ifiles=$IDIR
fi
  

for infile in $ifiles; do 
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
  opts+=(--decode_hparams="beam_size=$NBEST,alpha=$ALPHA,batch_size=$BATCH_SIZE,return_beams=True")
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
    rmdir ${infile}.lock
  else
    exit 1
  fi
done
