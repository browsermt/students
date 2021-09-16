#!/bin/bash

MARIAN=~/marian-dev-browsermt/build

SRC=de
TRG=en

mkdir -p speed

sacrebleu -t wmt19 -l $SRC-$TRG --echo src > speed/newstest2019.$SRC

test -e model.intgemm.bin || $MARIAN/marian-conv -f model.npz -t model.intgemm.bin --gemm-type intgemm8

echo "### Translating wmt19 $SRC-$TRG on CPU"
$MARIAN/marian-decoder $@ \
    --relative-paths -m model.intgemm.bin -v vocab.$SRC$TRG.spm vocab.$SRC$TRG.spm \
    -i speed/newstest2019.$SRC -o speed/cpu.newstest2019.intgemm8.$TRG \
    --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
    --skip-cost --shortlist lex.s2t.bin false --cpu-threads 1 \
    --quiet --quiet-translation --log speed/cpu.newstest2019.intgemm8.log 

tail -n1 speed/cpu.newstest2019.intgemm8.log
sacrebleu -t wmt19 -l $SRC-$TRG < speed/cpu.newstest2019.intgemm8.$TRG | tee speed/cpu.newstest2019.intgemm8.$TRG.bleu
