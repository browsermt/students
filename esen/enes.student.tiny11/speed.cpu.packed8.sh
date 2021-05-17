#!/bin/bash

set -e

MARIAN=../../marian-dev/build

SRC=en
TRG=es

mkdir -p speed

sacrebleu -t wmt13 -l $SRC-$TRG --echo src > speed/newstest2013.$SRC

test -e model.bin || $MARIAN/marian-conv -f model.npz -t model.bin --gemm-type packed8avx2

echo "### Translating wmt13 $SRC-$TRG on CPU, 8-bit packed model"
$MARIAN/marian-decoder $@ \
    --relative-paths -m model.bin -v vocab.esen.spm vocab.esen.spm \
    -i speed/newstest2013.$SRC -o speed/cpu.newstest2013.packed8.$TRG \
    --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
    --skip-cost --shortlist lex.s2t.bin false --cpu-threads 1 \
    --quiet --quiet-translation --log speed/cpu.newstest2013.packed8.log

tail -n1 speed/cpu.newstest2013.packed8.log
sacrebleu -t wmt13 -l $SRC-$TRG < speed/cpu.newstest2013.packed8.$TRG | tee speed/cpu.newstest2013.packed8.$TRG.bleu
