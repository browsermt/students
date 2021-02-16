#!/bin/bash

MARIAN=../../../marian-dev/build

SRC=es
TRG=en

mkdir -p speed

~/.local/bin/sacrebleu -t wmt13 -l $SRC-$TRG --echo src > speed/newstest2013.$SRC

test -e model.intgemm.bin || $MARIAN/marian-conv -f model.npz -t model.intgemm.bin --gemm-type intgemm8

echo "### Translating wmt18 $SRC-$TRG on CPU"
$MARIAN/marian-decoder $@ \
    --relative-paths -m model.intgemm.bin -v vocab.esen.spm vocab.esen.spm \
    -i speed/newstest2013.$SRC -o speed/cpu.newstest2013.$TRG \
    --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
    --skip-cost --shortlist lex.s2t.gz 50 50 --cpu-threads 1 \
    --quiet --quiet-translation --log speed/cpu.newstest2013.log --int8shift

tail -n1 speed/cpu.newstest2013.log
~/.local/bin/sacrebleu -t wmt13 -l $SRC-$TRG < speed/cpu.newstest2013.$TRG | tee speed/cpu.newstest2013.$TRG.bleu
