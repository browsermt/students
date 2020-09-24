#!/bin/bash
# This script preprocesses polish-english data to a form consumable by the clean scripts.

set -x;

STUDENTS='/home/cs-phil1/code/students'
DATA_DIR='/home/cs-phil1/rds/rds-t2-cs119/jerin/pl-en'

# We'll do this the hard way, no wildcards, loops.

(cd "$DATA_DIR/parallel";
    pigz -dc "europarl-v10.pl-en.tsv.gz" \
        | awk -F '\t' '{print $1 > "europarl-v10.pl"; print $2 > "europarl-v10.en";}'

    # en-pl.txt.gz is tab separated.
    pigz -dc "en-pl.txt.gz" \
        | awk -F '\t' '{print $1 > "paracrawl.en-pl.en"; print $2 > "paracrawl.en-pl.pl";}'


    pigz -dc "wikititles-v2.pl-en.tsv.gz" \
        | awk -F '\t' '{print $1 > "wikititles.pl"; print $2 > "wikititles.en";}'

    python3 $STUDENTS/train-student/utils/wikimatrix_extract.py \
        --tsv "WikiMatrix.v1.en-pl.langid.tsv.gz"       \
        --bitext "WikiMatrix.v1.en-pl.langid"           \
        --src-lang en --trg-lang pl                     \
        --threshold 1.0

    unzip "rapid2019.en-pl.tmx.zip" && tmx2corpus "RAPID_2019.UNIQUE.en-pl.tmx"
)

(cd "$DATA_DIR/monolingual";

    # xz --decompress --keep "pl.deduped.xz"
    pigz -dc "news.2019.pl.shuffled.deduped.gz" > "news.2019.pl"
    pigz -dc "europarl-v10.pl.tsv.gz" > "europarl-v10.pl"
)
