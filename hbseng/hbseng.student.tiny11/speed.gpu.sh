#!/bin/bash -v

MARIAN=../../marian-dev/build

SRC=hbs
TRG=eng

mkdir -p speed

# Custom test sets.
DATA=../data

for prefix in wmt13_hrv flores200test_bos ntrex128_srp-Latn MontenegrinSubs_test; do
    echo "### Translating $prefix $SRC-$TRG"
    cat $DATA/$prefix.$SRC \
        | tee speed/$prefix.$SRC \
        | $MARIAN/marian-decoder $@ -c config.yml --quiet --log speed/$prefix.log \
        | tee speed/$prefix.$TRG \
        | sacrebleu $DATA/$prefix.$TRG \
        | tee speed/$prefix.$TRG.bleu
    tail -n1 speed/$prefix.log
done
