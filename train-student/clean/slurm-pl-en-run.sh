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

module load parallel/20131222

DATA_DIR="/rds/project/t2_vol4/rds-t2-cs119/jerin/pl-en"

PARALLEL=(
    "${DATA_DIR}/parallel/europarl-v10"
    "${DATA_DIR}/parallel/WikiMatrix.v1.en-pl.langid"
    "${DATA_DIR}/parallel/wikititles"
    "${DATA_DIR}/parallel/paracrawl.en-pl"
    "${DATA_DIR}/parallel/RAPID_2019.UNIQUE"
)

MONOLINGUAL=(
    "${DATA_DIR}/monolingual/europarl-v10"
    "${DATA_DIR}/monolingual/news.2019"
)

bash clean-corpus.sh "${PARALLEL[@]}"
bash clean-mono.sh "${MONOLINGUAL[@]}"
