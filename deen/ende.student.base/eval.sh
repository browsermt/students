#!/bin/bash

set -e

MARIAN=../../marian-dev/build

SRC=en
TRG=de

mkdir -p eval

for i in 16 17 18 19; do
    echo "### Evaluating wmt$i $SRC-$TRG"
    sacrebleu -t wmt$i -l $SRC-$TRG --echo src \
        | $MARIAN/marian-decoder -c config.yml --quiet --log eval/wmt$i.log $@ \
        | tee eval/wmt$i.out \
        | sacrebleu -t wmt$i -l $SRC-$TRG \
        | tee eval/wmt$i.bleu
done
