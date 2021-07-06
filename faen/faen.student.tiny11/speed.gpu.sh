#!/bin/bash -v

MARIAN=~sukanta/tools/browsermt-marian-dev/build

SRC=fa
TRG=en

mkdir -p speed

# Custom test sets.
DATA=../data

for prefix in valid test2012 test2013; do
    echo "### Translating $prefix $SRC-$TRG"
    cat $DATA/$prefix.$SRC \
        | tee speed/$prefix.$SRC \
        | $MARIAN/marian-decoder $@ -c config.yml --quiet --log speed/$prefix.log \
        | tee speed/$prefix.$TRG \
        | sacrebleu $DATA/$prefix.$TRG \
        | tee speed/$prefix.$TRG.bleu
    tail -n1 speed/$prefix.log
done
