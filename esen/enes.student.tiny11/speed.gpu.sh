#!/bin/bash

MARIAN=../../marian-dev/build

SRC=en
TRG=es

mkdir -p speed

sacrebleu -t wmt13 -l $SRC-$TRG --echo src > speed/newstest2013.$SRC

echo "### Translating wmt13 $SRC-$TRG on GPU"
$MARIAN/marian-decoder -c config.yml $@ \
    --quiet --quiet-translation --log speed/gpu.newstest2013.log \
    -i speed/newstest2013.$SRC -o speed/gpu.newstest2013.$TRG

tail -n1 speed/gpu.newstest2013.log
sacrebleu -t wmt13 -l $SRC-$TRG < speed/gpu.newstest2013.$TRG | tee speed/gpu.newstest2013.$TRG.bleu
