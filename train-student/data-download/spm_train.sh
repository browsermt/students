#!/bin/bash
#SBATCH --qos cpu3
#SBATCH --account t2-cs119-sl4-cpu
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 32
#SBATCH --mem 160G
#SBATCH --time 12:00:00

# Usage:
# ./spm_train.sh DATA_DIR SRC_LANG TGT_LANG
# DATA_DIR has the following assumption of a structure:
# DATA_DIR/parallel/*.{xx,yy}, containing xx-yy parallel corpora
# DATA_DIR/monolingual/*.{xx,yy} containing monolingual corpora
# SRC_LANG and TGT_LANG correspond to xx-yy


module load use.own
module load sentencepiece/0.1.92

set -x;

DATA_DIR="$1"
SRC="$2"
TGT="$3"

LOCAL_DATA="/local/$USER"
mkdir -p $LOCAL_DATA

OUTPUT_DIR="${DATA_DIR}/sentencepiece-models"
mkdir -p $OUTPUT_DIR

find "$DATA_DIR" -iname "*.${SRC}" | xargs -I% cat % >> "${LOCAL_DATA}/train.${SRC}"
find "$DATA_DIR" -iname "*.${TGT}" | xargs -I% cat % >> "${LOCAL_DATA}/train.${TGT}"

function spm_train_lang {
    VOCAB="32768"

    SPM_ARGS=(
        --input "${LOCAL_DATA}/train.${LNG}"
        --model_prefix "${OUTPUT_DIR}/${LNG}.${VOCAB}"
        --character_coverage 1.0
        --vocab_size "$VOCAB"
        --num_threads "${SLURM_CPUS_PER_TASK}"
    )

    spm_train "${SPM_ARGS[@]}"

}

spm_train_lang "en"
spm_train_lang "pl"
