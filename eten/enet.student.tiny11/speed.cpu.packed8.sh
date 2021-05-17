#!/bin/bash

set -e

MARIAN=../../marian-dev/build

SRC=en
TRG=et

mkdir -p speed

sacrebleu -t wmt18 -l $SRC-$TRG --echo src > speed/newstest2018.$SRC

test -e model.bin || $MARIAN/marian-conv -f model.npz -t model.bin --gemm-type packed8avx2

echo "### Translating wmt18 $SRC-$TRG on CPU, 8-bit packed model"
$MARIAN/marian-decoder $@ \
    --relative-paths -m model.bin -v vocab.eten.spm vocab.eten.spm \
    -i speed/newstest2018.$SRC -o speed/cpu.newstest2018.packed8.$TRG \
    --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
    --skip-cost --shortlist lex.s2t.bin false --cpu-threads 1 \
    --quiet --quiet-translation --log speed/cpu.newstest2018.packed8.log

tail -n1 speed/cpu.newstest2018.packed8.log
sacrebleu -t wmt18 -l $SRC-$TRG < speed/cpu.newstest2018.packed8.$TRG | tee speed/cpu.newstest2018.packed8.$TRG.bleu
