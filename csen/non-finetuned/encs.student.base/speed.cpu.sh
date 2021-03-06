#!/bin/bash

MARIAN=../../marian-dev/build

SRC=en
TRG=cs

mkdir -p speed

for wmt in wmt14 wmt15 wmt16 wmt17 wmt18 wmt19
do
    ~/.local/bin/sacrebleu -t $wmt -l $SRC-$TRG --echo src > speed/newstest.$wmt.$SRC
    echo "### Translating $wmt $SRC-$TRG on CPU"
    $MARIAN/marian-decoder $@ \
        --relative-paths -m model.npz.best-bleu-detok.npz -v vocab.csen.spm vocab.csen.spm \
        -i speed/newstest.$wmt.$SRC -o speed/cpu.newstest.$wmt.$TRG \
        --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
        --skip-cost --shortlist lex.s2t.bin false --cpu-threads 1 \
        --quiet --quiet-translation --log speed/cpu.newstest.$wmt.log  --log speed/cpu.newstest2018.log

    tail -n1 speed/cpu.newstest.$wmt.log
    ~/.local/bin/sacrebleu -t $wmt -l $SRC-$TRG < speed/cpu.newstest.$wmt.$TRG | tee speed/cpu.newstest.$wmt.$TRG.bleu
done
