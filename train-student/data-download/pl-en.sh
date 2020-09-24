#!/bin/bash
# 
# Usage:
# ./pl-en.sh DOWNLOAD_DIR
# Downloads Polish-English models into a dir

DOWNLOAD_DIR="$1"

PARALLEL=(
    "https://s3.amazonaws.com/web-language-models/paracrawl/release5.1/en-pl.txt.gz" # Paracrawl
    "https://tilde-model.s3-eu-west-1.amazonaws.com/rapid2019.en-pl.tmx.zip"  # Rapid-TILDE
    "http://data.statmt.org/wikititles/v2/wikititles-v2.pl-en.tsv.gz" # Wikititles
    "http://www.statmt.org/europarl/v10/training/europarl-v10.pl-en.tsv.gz" # Europarl
    "http://data.statmt.org/wmt20/translation-task/WikiMatrix/WikiMatrix.v1.en-pl.langid.tsv.gz" # WikiMatrix
)

MONOLINGUAL=(
    "http://www.statmt.org/europarl/v10/training-monolingual/europarl-v10.pl.tsv.gz" # Europarl
    "http://data.statmt.org/news-crawl/pl/news.2019.pl.shuffled.deduped.gz" # Newscrawl
    # Commenting out: This is 60G compressed, way too much extra processing.
    # "http://web-language-models.s3-website-us-east-1.amazonaws.com/ngrams/pl/deduped/pl.deduped.xz" # CommonCrawl
)

PARALLEL_DIR="$DOWNLOAD_DIR/parallel"
mkdir -p $PARALLEL_DIR

for parallel in ${PARALLEL[@]}; do
    echo "Downloading $parallel"
    wget --continue \
        --directory-prefix="$PARALLEL_DIR" \
        "$parallel"
done

MONOLINGUAL_DIR="$DOWNLOAD_DIR/monolingual"
mkdir -p $MONOLINGUAL_DIR

MONOLINGUAL_DIR="$DOWNLOAD_DIR/monolingual"
for monolingual in ${MONOLINGUAL[@]}; do
    echo "Downloading $monolingual"
    wget --continue \
        --directory-prefix="$MONOLINGUAL_DIR" \
        "$monolingual"
done
