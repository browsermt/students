#!/bin/bash -v

MARIAN=../../../marian-dev/build

SRC=is
TRG=en

mkdir -p speed

# Custom test sets.
DATA=../data

test -e model.intgemm.bin || $MARIAN/marian-conv -f model.npz -t model.intgemm.bin --gemm-type intgemm8

for prefix in ted-test; do
    echo "### Translating $prefix $SRC-$TRG"
    cat $DATA/$prefix.$SRC \
        | tee speed/$prefix.$SRC \
        | $MARIAN/marian-decoder -c config.intgemm8bit.yml --quiet --log speed/$prefix.log --cpu-threads 1 \
        | tee speed/$prefix.$TRG \
        | sacrebleu $DATA/$prefix.$TRG \
        | tee speed/$prefix.$TRG.bleu
    tail -n1 speed/$prefix.log
done
