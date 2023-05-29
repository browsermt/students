#!/bin/bash -v

MARIAN=../../marian-cpu/build

SRC=is
TRG=en

mkdir -p speed

# Custom test sets.
DATA=../data

for prefix in wmt21; do
    echo "### Translating $prefix $SRC-$TRG"
    cat $DATA/$prefix.$SRC \
        | tee speed/$prefix.$SRC \
        | $MARIAN/marian-decoder $@ -c config.yml --quiet --log speed/$prefix.log \
        | tee speed/$prefix.$TRG \
        | sacrebleu $DATA/$prefix.$TRG \
        | tee speed/$prefix.$TRG.bleu
    tail -n1 speed/$prefix.log
done
