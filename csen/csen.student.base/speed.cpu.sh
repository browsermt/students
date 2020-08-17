#!/bin/bash

MARIAN=../../marian-dev/build

SRC=cs
TRG=en

mkdir -p speed

for wmt in wmt14 wmt15 wmt16 wmt17 wmt18
do
    ~/.local/bin/sacrebleu -t $wmt -l $SRC-$TRG --echo src > speed/newstest.$wmt.$SRC
    echo "### Translating $wmt $SRC-$TRG on CPU"
    $MARIAN/marian-decoder $@ \
        --relative-paths -m model.8bit-finetuned.npz -v vocab.spm vocab.spm \
        -i speed/newstest.$wmt.$SRC -o speed/cpu.newstest.$wmt.$TRG \
        --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
        --skip-cost --shortlist lex.s2t.gz 50 50 --cpu-threads 1 \
        --quiet --quiet-translation --log speed/cpu.newstest.$wmt.log  --log speed/cpu.newstest2018.log

    tail -n1 speed/cpu.newstest.$wmt.log
    ~/.local/bin/sacrebleu -t $wmt -l $SRC-$TRG < speed/cpu.newstest.$wmt.$TRG | tee speed/cpu.newstest.$wmt.$TRG.bleu
done
