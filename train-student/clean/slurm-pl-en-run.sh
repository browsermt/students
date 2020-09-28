#!/bin/bash
#SBATCH --qos cpu3
#SBATCH --account t2-cs119-sl4-cpu
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 32
#SBATCH --mem 160G
#SBATCH --time 12:00:00
#SBATCH --mail-type ALL
#SBATCH --mail-user jphilip@ed.ac.uk

PARALLEL=(
"./parallel/europarl-v10"
"./parallel/WikiMatrix.v1.en-pl.langid"
"./parallel/wikititles"
"./parallel/paracrawl.en-pl"
"./parallel/RAPID_2019.UNIQUE"
)

MONOLINGUAL=(
    "./monolingual/europarl-v10"
    "./monolingual/news.2019"
)

bash clean-corpus.sh "${PARALLEL[@]}"
bash clean-mono.sh "${MONOLINGUAL[@]}"