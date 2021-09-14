#!/bin/bash

MARIAN=~/marian-dev-browsermt/build

SRC=en
TRG=de

mkdir -p speed

sacrebleu -t wmt19 -l $SRC-$TRG --echo src > speed/newstest2019.$SRC

echo "### Translating wmt19 $SRC-$TRG on CPU"
$MARIAN/marian-decoder $@ \
    --relative-paths -m model.npz -v vocab.$TRG$SRC.spm vocab.$TRG$SRC.spm \
    -i speed/newstest2019.$SRC -o speed/cpu.newstest2019.$TRG \
    --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
    --skip-cost --shortlist lex.s2t.bin false --cpu-threads 1 \
    --quiet --quiet-translation --log speed/cpu.newstest2019.log

tail -n1 speed/cpu.newstest2019.log
sacrebleu -t wmt19 -l $SRC-$TRG < speed/cpu.newstest2019.$TRG | tee speed/cpu.newstest2019.$TRG.bleu
