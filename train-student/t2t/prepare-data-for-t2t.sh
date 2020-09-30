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

DATA_DIR="/rds/project/t2_vol4/rds-t2-cs119/jerin/pl-en"

PARALLEL=(
    "${DATA_DIR}/parallel/europarl-v10.gz"
    "${DATA_DIR}/parallel/WikiMatrix.v1.en-pl.langid.gz"
    "${DATA_DIR}/parallel/wikititles.gz"
    "${DATA_DIR}/parallel/paracrawl.en-pl.gz"
    "${DATA_DIR}/parallel/RAPID_2019.UNIQUE.gz"
)

MONOLINGUAL=(
    "${DATA_DIR}/monolingual/europarl-v10.gz"
    "${DATA_DIR}/monolingual/news.2019.gz"
)

SPIECE_ARGS=(
    --use-sentencepiece
    --src-sentencepiece-prefix "/rds/project/t2_vol4/rds-t2-cs119/jerin/pl-en/sentencepiece-models/en.32768"
    --tgt-sentencepiece-prefix "/rds/project/t2_vol4/rds-t2-cs119/jerin/pl-en/sentencepiece-models/pl.32768"
)


LOCAL_WORKSPACE="/local/$USER"
mkdir -p $LOCAL_WORKSPACE

OUTPUT_DIR="${DATA_DIR}/intermediate"
mkdir -p $OUTPUT_DIR

# Decompress and run through print sort
pigz -dc "${PARALLEL[@]}"  \
    | parallel --no-notice --pipe -k -j${NCPUS} --block 50M \
        "python3 $TOOLS/print-lengths.py --type parallel ${SPIECE_ARGS[@]}" \
     > $LOCAL_WORKSPACE/parallel-intermediate.with-lengths.tsv

LC_ALL=C sort                                       \
    -nk 1 -t '\t' -S 10G                            \
    $LOCAL_WORKSPACE/parallel-intermediate-with-lengths.tsv  \
    | cut -f3,4 -d '\t'                             \
    | pigz > OUTPUT_DIR/parallel.gz

pigz -dc "${MONOLINGUAL[@]}"  \
    | parallel --no-notice --pipe -k -j${NCPUS} --block 50M \
        "python3 $TOOLS/print-lengths.py --type monolingual ${SPIECE_ARGS[@]}" \
     > $LOCAL_WORKSPACE/monolingual-intermediate.with-lengths.tsv

LC_ALL=C sort                                       \
    -nk 1 -t '\t' -S 10G                            \
    $LOCAL_WORKSPACE/monolingual-intermediate-with-lengths.tsv  \
    | cut -f2 -d '\t'                             \
    | pigz > OUTPUT_DIR/mono.gz