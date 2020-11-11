#!/bin/bash -v

MARIAN=../../../marian-dev/build

SRC=is
TRG=en

mkdir -p speed

# Custom test sets.
DATA=../data

for prefix in ted-test; do
    if [ ! -f model.intgemm.alphas.bin ]; then

        test -e model.alphas.npz || $MARIAN/marian-decoder $@ \
            --relative-paths -m model.npz -v vocab.$SRC$TRG.spm vocab.$SRC$TRG.spm \
            -i $DATA/$prefix.$SRC -o speed/$prefix.$TRG.out \
            --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
            --skip-cost --shortlist lex.s2t.gz 50 50 --cpu-threads 1 \
            --quiet --quiet-translation --log speed/$prefix.log --dump-quantmult  2> quantmults

        test -e model.alphas.npz || $MARIAN/../scripts/alphas/extract_stats.py quantmults model.npz model.alphas.npz

        test -e model.intgemm.alphas.bin || $MARIAN/marian-conv -f model.alphas.npz -t model.intgemm.alphas.bin --gemm-type intgemm8

    fi
    echo "### Translating $prefix $SRC-$TRG"
    cat $DATA/$prefix.$SRC \
        | tee speed/$prefix.$SRC \
        | $MARIAN/marian-decoder -c config.intgemm8bitalpha.yml --quiet --log speed/$prefix.log --cpu-threads 1 \
        | tee speed/$prefix.$TRG \
        | sacrebleu $DATA/$prefix.$TRG \
        | tee speed/$prefix.$TRG.bleu
    tail -n1 speed/$prefix.log
done
