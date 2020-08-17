#!/bin/bash

MARIAN=/home/nbogoych/marian-dev/build_VSCODE

SRC=cs
TRG=en

mkdir -p speed

~/.local/bin/sacrebleu -t wmt18 -l $SRC-$TRG --echo src > speed/newstest2018.$SRC

if [ ! -f model.8bit-finetuned.intgemm8.alphas.bin ]; then

test -e model.8bit-finetuned.alphas.npz || $MARIAN/marian-decoder $@ \
    --relative-paths -m model.8bit-finetuned.npz -v vocab.spm vocab.spm \
    -i speed/newstest2018.$SRC -o speed/cpu.newstest2018.$TRG \
    --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
    --skip-cost --shortlist lex.s2t.gz 50 50 --cpu-threads 1 \
    --quiet --quiet-translation --log speed/cpu.newstest2018.log --dump-quantmult  2> quantmults

test -e model.8bit-finetuned.alphas.npz || $MARIAN/../scripts/alphas/extract_stats.py quantmults model.8bit-finetuned.npz model.8bit-finetuned.alphas.npz

test -e model.8bit-finetuned.intgemm8.alphas.bin || $MARIAN/marian-conv -f model.8bit-finetuned.alphas.npz -t model.8bit-finetuned.intgemm8.alphas.bin --gemm-type intgemm8

fi
for wmt in wmt14 wmt15 wmt16 wmt17 wmt18
do
    ~/.local/bin/sacrebleu -t $wmt -l $SRC-$TRG --echo src > speed/newstest.$wmt.$SRC
    echo "### Translating $wmt $SRC-$TRG on CPU"
    $MARIAN/marian-decoder $@ \
        --relative-paths -m model.8bit-finetuned.intgemm8.alphas.bin -v vocab.spm vocab.spm \
        -i speed/newstest.$wmt.$SRC -o speed/cpu.newstest.$wmt.$TRG \
        --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
        --skip-cost --shortlist lex.s2t.gz 50 50 --cpu-threads 1 \
        --quiet --quiet-translation --log speed/cpu.newstest.$wmt.log --int8shiftAlphaAll

    tail -n1 speed/cpu.newstest.$wmt.log
    ~/.local/bin/sacrebleu -t $wmt -l $SRC-$TRG < speed/cpu.newstest.$wmt.$TRG | tee speed/cpu.newstest.$wmt.$TRG.bleu
done
