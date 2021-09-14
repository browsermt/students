#!/bin/bash

set -e

MARIAN=~/marian-dev-browsermt/build

SRC=en
TRG=de

mkdir -p eval

for i in 16 17 18 19 20; do
    echo "### Evaluating wmt$i $SRC-$TRG"
    sacrebleu -t wmt$i -l $SRC-$TRG --echo src \
        | $MARIAN/marian-decoder -c config.yml --quiet --devices 0 --log eval/wmt$i.log $@ \
        | tee eval/wmt$i.out \
        | sacrebleu -t wmt$i -l $SRC-$TRG \
        | tee eval/wmt$i.bleu
done
