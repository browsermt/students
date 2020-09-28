#!/bin/bash
# This script preprocesses polish-english data to a form consumable by the clean scripts.

set -x;

STUDENTS='/home/cs-phil1/code/students'
DATA_DIR='/home/cs-phil1/rds/rds-t2-cs119/jerin/pl-en'

# We'll do this the hard way, no wildcards, loops.
# Some conventions:
#   {name}.{en,pl} would connect parallel pairs.


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

    # RAPID_2019.UNIQUE
    unzip "rapid2019.en-pl.tmx.zip" && tmx2corpus "RAPID_2019.UNIQUE.en-pl.tmx"
    mv bitext.en RAPID_2019.UNIQUE.en;
    mv bitext.pl RAPID_2019.UNIQUE.pl;
    rm -v bitext.tok.{en,pl};

(cd "$DATA_DIR/monolingual";


pigz -dc "news.2019.pl.shuffled.deduped.gz" > "news.2019.pl"
pigz -dc "europarl-v10.pl.tsv.gz" > "europarl-v10.pl"


# Collect monolingual data to prepare sentencepiece.
(cd $DATA_DIR;
cat parallel/{paracrawl.en-pl,europarl-v10,RAPID_2019.UNIQUE}
)
