#!/bin/bash

MARIAN=../../marian-dev/build

SRC=es
TRG=en

mkdir -p speed

sacrebleu -t wmt13 -l $SRC-$TRG --echo src > speed/newstest2013.$SRC

echo "### Translating wmt13 $SRC-$TRG on CPU"
$MARIAN/marian-decoder $@ \
    --relative-paths -m model.npz -v vocab.$SRC$TRG.spm vocab.$SRC$TRG.spm \
    -i speed/newstest2013.$SRC -o speed/cpu.newstest2013.$TRG \
    --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
    --skip-cost --shortlist lex.s2t.bin false --cpu-threads 1 \
    --quiet --quiet-translation --log speed/cpu.newstest2013.log

tail -n1 speed/cpu.newstest2013.log
sacrebleu -t wmt13 -l $SRC-$TRG < speed/cpu.newstest2013.$TRG | tee speed/cpu.newstest2013.$TRG.bleu
