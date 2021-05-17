#!/bin/bash

MARIAN=../../../marian-dev/build

SRC=cs
TRG=en

mkdir -p speed

~/.local/bin/sacrebleu -t wmt18 -l $SRC-$TRG --echo src > speed/newstest2018.$SRC

if [ ! -f model.intgemm8.alphas.bin ]; then

test -e model.npz.best-bleu-detok.alphas.npz || $MARIAN/marian-decoder $@ \
    --relative-paths -m model.npz.best-bleu-detok.npz -v vocab.csen.spm vocab.csen.spm \
    -i speed/newstest2018.$SRC -o speed/cpu.newstest2018.$TRG \
    --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
    --skip-cost --shortlist lex.s2t.bin false --cpu-threads 1 \
    --quiet --quiet-translation --log speed/cpu.newstest2018.log --dump-quantmult  2> quantmults

test -e model.npz.best-bleu-detok.alphas.npz || $MARIAN/../scripts/alphas/extract_stats.py quantmults model.npz.best-bleu-detok.npz model.npz.best-bleu-detok.alphas.npz

test -e model.intgemm8.alphas.bin || $MARIAN/marian-conv -f model.npz.best-bleu-detok.alphas.npz -t model.intgemm8.alphas.bin --gemm-type intgemm8

fi
for wmt in wmt14 wmt15 wmt16 wmt17 wmt18
do
    ~/.local/bin/sacrebleu -t $wmt -l $SRC-$TRG --echo src > speed/newstest.$wmt.$SRC
    echo "### Translating $wmt $SRC-$TRG on CPU"
    $MARIAN/marian-decoder $@ \
        --relative-paths -m model.intgemm8.alphas.bin -v vocab.csen.spm vocab.csen.spm \
        -i speed/newstest.$wmt.$SRC -o speed/cpu.newstest.$wmt.$TRG \
        --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
        --skip-cost --shortlist lex.s2t.bin false --cpu-threads 1 \
        --quiet --quiet-translation --log speed/cpu.newstest.$wmt.log --int8shiftAlphaAll

    tail -n1 speed/cpu.newstest.$wmt.log
    ~/.local/bin/sacrebleu -t $wmt -l $SRC-$TRG < speed/cpu.newstest.$wmt.$TRG | tee speed/cpu.newstest.$wmt.$TRG.bleu
done
