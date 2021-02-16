#!/bin/bash

MARIAN=../../../marian-dev/build

SRC=en
TRG=et

mkdir -p speed

~/.local/bin/sacrebleu -t wmt18 -l $SRC-$TRG --echo src > speed/newstest2018.$SRC

if [ ! -f model.intgemm.alphas.bin ]; then

test -e model.alphas.npz || $MARIAN/marian-decoder $@ \
    --relative-paths -m model.npz -v vocab.eten.spm vocab.eten.spm \
    -i speed/newstest2018.$SRC -o speed/cpu.newstest2018.$TRG \
    --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
    --skip-cost --shortlist lex.s2t.gz 50 50 --cpu-threads 1 \
    --quiet --quiet-translation --log speed/cpu.newstest2018.log --dump-quantmult  2> quantmults

test -e model.alphas.npz || $MARIAN/../scripts/alphas/extract_stats.py quantmults model.npz model.alphas.npz

test -e model.intgemm.alphas.bin || $MARIAN/marian-conv -f model.alphas.npz -t model.intgemm.alphas.bin --gemm-type intgemm8

fi

echo "### Translating wmt18 $SRC-$TRG on CPU"
$MARIAN/marian-decoder $@ \
    --relative-paths -m model.intgemm.alphas.bin -v vocab.eten.spm vocab.eten.spm \
    -i speed/newstest2018.$SRC -o speed/cpu.newstest2018.$TRG \
    --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
    --skip-cost --shortlist lex.s2t.gz 50 50 --cpu-threads 1 \
    --quiet --quiet-translation --log speed/cpu.newstest2018.log --int8shiftAlphaAll

tail -n1 speed/cpu.newstest2018.log
~/.local/bin/sacrebleu -t wmt18 -l $SRC-$TRG < speed/cpu.newstest2018.$TRG | tee speed/cpu.newstest2018.$TRG.bleu
