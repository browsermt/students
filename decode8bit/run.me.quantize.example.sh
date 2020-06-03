 
#!/bin/bash

set -e

MARIAN=~/marian-dev/build_VSCODE

SRC=en
TRG=de

mkdir -p speed_intgemm
test -e model-finetune.npz.best-bleu-detok.alphas.npz || $MARIAN/marian-decoder $@ \
            --relative-paths -m model-finetune.npz.best-bleu-detok.npz -v vocab.spm vocab.spm --optimize8 --intgemm-shifted --intgemm-shifted-all --dump-quantmult \
            -i speed_intgemm/wmt16.$SRC -o speed_intgemm/cpu.wmt16.$TRG \
            --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
            --skip-cost --shortlist lex.s2t.gz 50 50 --cpu-threads 1 \
            --quiet --quiet-translation --log speed_intgemm/cpu.wmt16.log 2> quantmults

test -e model-finetune.npz.best-bleu-detok.alphas.npz || $MARIAN/../scripts/alphas/extract_stats.py quantmults model-finetune.npz.best-bleu-detok.npz model-finetune.npz.best-bleu-detok.alphas.npz

test -e model-finetune.intgemm.alphas.bin || $MARIAN/marian-conv -f model-finetune.npz.best-bleu-detok.alphas.npz -t model-finetune.intgemm.alphas.bin --gemm-type intgemm8

for i in 16 17 18 19; do
        /home/nbogoych/.local/bin/sacrebleu -t wmt$i -l $SRC-$TRG --echo src > speed_intgemm/wmt$i.$SRC

        $MARIAN/marian-decoder $@ \
            --relative-paths -m model-finetune.intgemm.alphas.bin -v vocab.spm vocab.spm --optimize8 --intgemm-shifted --intgemm-shifted-all --use-precomputed-alphas \
            -i speed_intgemm/wmt$i.$SRC -o speed_intgemm/cpu.wmt$i.$TRG \
            --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
            --skip-cost --shortlist lex.s2t.gz 50 50 --cpu-threads 1 \
            --quiet --quiet-translation --log speed_intgemm/cpu.wmt$i.log

        tail -n1 speed_intgemm/cpu.wmt$i.log
        /home/nbogoych/.local/bin/sacrebleu -t wmt$i -l $SRC-$TRG < speed_intgemm/cpu.wmt$i.$TRG | tee speed_intgemm/cpu.wmt$i.$TRG.bleu

done
