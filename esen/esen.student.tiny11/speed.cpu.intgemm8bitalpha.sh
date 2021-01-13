#!/bin/bash

# Prevent OneDNN's attempts to parallelize the GEMMs over all threads which is not efficient for the small gemms that we have
export OMP_NUM_THREADS=1

MARIAN=../../marian-dev/build

SRC=es
TRG=en

mkdir -p speed

sacrebleu -t wmt13 -l $SRC-$TRG --echo src > speed/newstest2013.$SRC
head -n10 speed/newstest2013.$SRC > speed/newstest2013.$SRC.top10lines
head -n100 speed/newstest2013.$SRC > speed/newstest2013.$SRC.top100lines
head -n300 speed/newstest2013.$SRC > speed/newstest2013.$SRC.top300lines

if [ ! -f model.intgemm.alphas.bin ]; then

test -e model.alphas.npz || $MARIAN/marian-decoder $@ \
    --relative-paths -m model.npz -v vocab.esen.spm vocab.esen.spm \
    -i speed/newstest2013.$SRC -o speed/cpu.newstest2013.$TRG \
    --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
    --skip-cost --shortlist lex.s2t.gz 50 50 --cpu-threads 1 \
    --quiet --quiet-translation --log speed/cpu.newstest2013.log --dump-quantmult  2> quantmults

test -e model.alphas.npz || $MARIAN/../scripts/alphas/extract_stats.py quantmults model.npz model.alphas.npz

test -e model.intgemm.alphas.bin || $MARIAN/marian-conv -f model.alphas.npz -t model.intgemm.alphas.bin --gemm-type intgemm8

fi

echo "### Translating wmt13 $SRC-$TRG on CPU"
$MARIAN/marian-decoder $@ \
    --relative-paths -m model.intgemm.alphas.bin -v vocab.$SRC$TRG.spm vocab.$SRC$TRG.spm \
    -i speed/newstest2013.$SRC.top300lines -o speed/cpu.newstest2013.$TRG \
    --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
    --skip-cost --shortlist lex.s2t 50 50 --cpu-threads 1 \
    --quiet --quiet-translation --log speed/cpu.newstest2013.log --int8shiftAlphaAll

tail -n1 speed/cpu.newstest2013.log
# Needs the entire input to be useful:
# sacrebleu -t wmt13 -l $SRC-$TRG < speed/cpu.newstest2013.$TRG | tee speed/cpu.newstest2013.$TRG.bleu
