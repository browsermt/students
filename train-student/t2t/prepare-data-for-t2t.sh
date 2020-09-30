#!/bin/bash
#SBATCH --qos cpu3
#SBATCH --account t2-cs119-sl4-cpu
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 32
#SBATCH --mem 160G
#SBATCH --time 3:00:00
#SBATCH --mail-type ALL
#SBATCH --mail-user jphilip@ed.ac.uk

# This script assumes data of two nature: (1) parallel, (2) monolingual
# Each have to be specified separately.
# The parallel data is sorted by length

module load parallel/20131222
. /home/cs-phil1/envs/student/bin/activate

set -x;
set -eo pipefail;

TOOLS="../clean/tools"
DATA_DIR="/rds/project/t2_vol4/rds-t2-cs119/jerin/pl-en"

NCPUS=16

if [ ! -z "$SLURM_CPUS_PER_TASK" ]; then
    NCPUS=$SLURM_CPUS_PER_TASK
fi


PARALLEL=$(find "${DATA_DIR}/parallel" -iname "*.enpl.clean.gz")
MONOLINGUAL=$(find "${DATA_DIR}/monolingual" -iname "*.pl.clean.gz")

PARALLEL=($PARALLEL)
MONOLINGUAL=($MONOLINGUAL)

SPIECE_ARGS=(
    --use-sentencepiece
    --src-sentencepiece-prefix "/rds/project/t2_vol4/rds-t2-cs119/jerin/pl-en/sentencepiece-models/en.32768"
    --tgt-sentencepiece-prefix "/rds/project/t2_vol4/rds-t2-cs119/jerin/pl-en/sentencepiece-models/pl.32768"
)


LOCAL_WORKSPACE="/local/$USER"
mkdir -p $LOCAL_WORKSPACE

OUTPUT_DIR="${DATA_DIR}/intermediate"
mkdir -p $OUTPUT_DIR

# https://stackoverflow.com/questions/1037365/sorting-a-tab-delimited-file

# Decompress and run through print sort
pigz -dc "${PARALLEL[@]}"  \
    | parallel --no-notice --pipe -k -j${NCPUS} --block 50M \
        "python3 $TOOLS/print-lengths.py --dataset-type parallel ${SPIECE_ARGS[@]}" \
     > $LOCAL_WORKSPACE/parallel-intermediate.with-lengths.tsv

LC_ALL=C sort                                       \
    -nk 1 -t$'\t' -S 10G                            \
    $LOCAL_WORKSPACE/parallel-intermediate.with-lengths.tsv  \
    | cut -f3,4 
    | pigz > $OUTPUT_DIR/parallel.gz

pigz -dc "${MONOLINGUAL[@]}"  \
    | parallel --no-notice --pipe -k -j${NCPUS} --block 50M \
        "python3 $TOOLS/print-lengths.py --dataset-type monolingual ${SPIECE_ARGS[@]}" \
     > $LOCAL_WORKSPACE/monolingual-intermediate.with-lengths.tsv

LC_ALL=C sort                                       \
    -nk 1 -t$'\t' -S 10G                            \
    $LOCAL_WORKSPACE/monolingual-intermediate.with-lengths.tsv  \
    | cut -f2 
    | pigz > $OUTPUT_DIR/mono.gz
