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

OUTPUT_DIR="${DATA_DIR}/intermediate"
SHARD_DIR="${OUTPUT_DIR}/shards"
mkdir -p $OUTPUT_DIR $SHARD_DIR
rm -rv $SHARD_DIR/* || continue

LOCAL_WORKSPACE="/local/$USER"
mkdir -p $LOCAL_WORKSPACE

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

SHARD_SIZE="100000" # Currently set to number of lines.


# https://stackoverflow.com/questions/1037365/sorting-a-tab-delimited-file

# Parallel handling

function prepare_parallel {
    pigz -dc "${PARALLEL[@]}"  \
        | parallel --no-notice --pipe -k -j${NCPUS} --block 50M \
            "python3 $TOOLS/print-lengths.py --dataset-type parallel ${SPIECE_ARGS[@]}" \
         > $LOCAL_WORKSPACE/parallel-intermediate.with-lengths.tsv

    LC_ALL=C sort                                       \
        -nk 1 -t$'\t' -S 10G                            \
        $LOCAL_WORKSPACE/parallel-intermediate.with-lengths.tsv  \
        | cut -f3,4  \
        | pigz > $OUTPUT_DIR/parallel.gz

    pigz -dc $OUTPUT_DIR/parallel.gz | \
        split --suffix-length 3 --lines $SHARD_SIZE --numeric-suffixes=0 \
        --additional-suffix '.tsv' - $SHARD_DIR/parallel 

    ls $SHARD_DIR/parallel[0-9]*.tsv \
        | parallel -I% --bar --no-notice -j$NCPUS "cut -f1 % > %.en; cut -f2 % > %.pl"; 

    rm $SHARD_DIR/parallel[0-9]*.tsv;

    ls $SHARD_DIR/*.en | parallel --bar --no-notice -j$NCPUS gzip {}
    ls $SHARD_DIR/*.pl | parallel --bar --no-notice -j$NCPUS gzip {}
}


function prepare_monolingual {
    pigz -dc "${MONOLINGUAL[@]}"  \
        | parallel --no-notice --pipe -k -j${NCPUS} --block 50M \
            "python3 $TOOLS/print-lengths.py --dataset-type monolingual ${SPIECE_ARGS[@]}" \
         > $LOCAL_WORKSPACE/monolingual-intermediate.with-lengths.tsv

    # Monolingual handling
    LC_ALL=C sort                                       \
        -nk 1 -t$'\t' -S 10G                            \
        $LOCAL_WORKSPACE/monolingual-intermediate.with-lengths.tsv  \
        | cut -f2  \
        | pigz > $OUTPUT_DIR/mono.gz


    pigz -dc $OUTPUT_DIR/mono.gz | \
        split --suffix-length 3 --lines $SHARD_SIZE --numeric-suffixes=0 \
        --additional-suffix '.pl' - $SHARD_DIR/monolingual

    ls $SHARD_DIR/monolingual[0-9]*.pl | parallel --bar --no-notice -j$NCPUS -I% gzip %
}


prepare_parallel
prepare_monolingual
