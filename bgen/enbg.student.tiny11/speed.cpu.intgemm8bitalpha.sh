#!/bin/bash

MARIAN=../../../marian-dev/build

SRC=en
TRG=bg

mkdir -p speed

if [ ! -f model.intgemm.alphas.bin ]; then

test -e lex.s2t.bin || $MARIAN/marian-conv --shortlist lex.s2t.pruned.gz 100 100 0 --dump lex.s2t.bin --vocabs vocab.bgen.spm vocab.bgen.spm

test -e model.alphas.npz || $MARIAN/marian-decoder $@ \
    --relative-paths -m model.npz -v vocab.bgen.spm vocab.bgen.spm \
    -i ../government.bg.$SRC.gz -o speed/government.bg.into.$TRG \
    --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
    --skip-cost --shortlist lex.s2t.bin false --cpu-threads 1 \
    --quiet --quiet-translation --log speed/finetune.log --dump-quantmult  2> quantmults

test -e model.alphas.npz || $MARIAN/../scripts/alphas/extract_stats.py quantmults model.npz model.alphas.npz

test -e model.intgemm.alphas.bin || $MARIAN/marian-conv -f model.alphas.npz -t model.intgemm.alphas.bin --gemm-type intgemm8

test -e model.intgemm.bin || $MARIAN/marian-conv -f model.npz -t model.intgemm.bin --gemm-type intgemm8
fi

test -e model.intgemm.bin || $MARIAN/marian-conv -f model.npz -t model.intgemm.bin --gemm-type intgemm8
echo "Scoring model WITHOUT precomputed alphas..."
$MARIAN/marian-decoder $@ \
   --relative-paths -m model.intgemm.bin -v vocab.bgen.spm vocab.bgen.spm \
   -i ../government.bg.$SRC.gz -o speed/government.bg.into.$TRG \
   --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
   --skip-cost --shortlist lex.s2t.bin false --cpu-threads 1 \
   --quiet --quiet-translation --log speed/speedtest.log --int8shift

tail -n1 speed/speedtest.log
sacrebleu ../government.bg.$TRG.gz --metrics bleu chrf < speed/government.bg.into.$TRG | tee speed/out.bleu

echo "Scoring model WITH precomputed alphas..."
$MARIAN/marian-decoder $@ \
   --relative-paths -m model.intgemm.alphas.bin -v vocab.bgen.spm vocab.bgen.spm \
   -i ../government.bg.$SRC.gz -o speed/government.bg.into.$TRG \
   --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
   --skip-cost --shortlist lex.s2t.bin false --cpu-threads 1 \
   --quiet --quiet-translation --log speed/speedtest.log --int8shiftAlphaAll

tail -n1 speed/speedtest.log
sacrebleu ../government.bg.$TRG.gz --metrics bleu chrf < speed/government.bg.into.$TRG | tee speed/out.bleu
