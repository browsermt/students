#!/bin/bash


MARIAN=~/marian-dev-browsermt/build

SRC=de
TRG=en

mkdir -p speed

sacrebleu -t wmt19 -l $SRC-$TRG --echo src > speed/newstest2019.$SRC

if [ ! -f model.intgemm.alphas.bin ]; then

test -e model.alphas.npz || $MARIAN/marian-decoder $@ \
    --relative-paths -m model.npz -v vocab.$SRC$TRG.spm vocab.$SRC$TRG.spm \
    -i speed/newstest2019.$SRC -o speed/cpu.newstest2019.intgemm8alphas.$TRG \
    --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
    --skip-cost --shortlist lex.s2t.bin false --cpu-threads 1 \
    --quiet --quiet-translation --log speed/cpu.newstest2019.intgemm8alphas.log --dump-quantmult  2> quantmults

test -e model.alphas.npz || $MARIAN/../scripts/alphas/extract_stats.py quantmults model.npz model.alphas.npz

test -e model.intgemm.alphas.bin || $MARIAN/marian-conv -f model.alphas.npz -t model.intgemm.alphas.bin --gemm-type intgemm8

fi

echo "### Translating wmt19 $SRC-$TRG on CPU"
$MARIAN/marian-decoder $@ \
    --relative-paths -m model.intgemm.alphas.bin -v vocab.$SRC$TRG.spm vocab.$SRC$TRG.spm \
    -i speed/newstest2019.$SRC -o speed/cpu.newstest2019.intgemm8alphas.$TRG \
    --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
    --skip-cost --shortlist lex.s2t.bin false --cpu-threads 1 \
    --quiet --quiet-translation --log speed/cpu.newstest2019.intgemm8alphas.log --int8shiftAlphaAll

tail -n1 speed/cpu.newstest2019.intgemm8alphas.log
sacrebleu -t wmt19 -l $SRC-$TRG < speed/cpu.newstest2019.intgemm8alphas.$TRG | tee speed/cpu.newstest2019.intgemm8alphas.$TRG.bleu
