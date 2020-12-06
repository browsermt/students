#!/bin/bash

MARIAN=../../marian-dev/build

SRC=es
TRG=en

mkdir -p speed

sacrebleu -t wmt13 -l $SRC-$TRG --echo src > speed/newstest2013.$SRC
head -n10 speed/newstest2013.$SRC > speed/newstest2013.$SRC.top10lines

echo "### Translating wmt13 $SRC-$TRG on CPU"
$MARIAN/marian-decoder $@ \
    --relative-paths -m model.npz -v vocab.$SRC$TRG.spm vocab.$SRC$TRG.spm \
    -i speed/newstest2013.$SRC.top10lines -o speed/cpu.newstest2013.$TRG \
    --beam-size 1 --mini-batch 1 --maxi-batch 1 --maxi-batch-sort src -w 128 \
    --skip-cost --cpu-threads 1 \
    --quiet --quiet-translation --log speed/cpu.newstest2013.log

#--shortlist lex.s2t.gz 50 50

tail -n1 speed/cpu.newstest2013.log
sacrebleu -t wmt13 -l $SRC-$TRG < speed/cpu.newstest2013.$TRG | tee speed/cpu.newstest2013.$TRG.bleu
