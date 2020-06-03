#!/bin/bash -v

MARIAN=/home/s1031254/marian-dev-finetune/build

SRC=en
TRG=de

$MARIAN/marian -c student.tiny11.yml -d 4 5 \
    --model model-finetune.npz \
    --train-sets corpus.{$SRC,$TRG}.gz -T tmp --shuffle-in-ram \
    --data-weighting corpus.w.gz \
    --vocabs vocab.spm vocab.spm \
    --dim-vocabs 32000 32000 \
    --max-length 200 \
    --mini-batch-fit -w 8000 --mini-batch 1000 --maxi-batch 1000 --sync-sgd --optimizer-delay 4 \
    --cost-type ce-mean-words \
    --learn-rate 0.0003 --lr-report --lr-warmup 16000 --lr-decay-inv-sqrt 32000 \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 0 \
    --valid-freq 500 --save-freq 500 --disp-freq 100 --disp-first 10 \
    --valid-metrics bleu-detok ce-mean-words \
    --valid-sets devset.{$SRC,$TRG} --valid-translation-output devset.out --quiet-translation \
    --valid-mini-batch 16 --beam-size 1 --normalize 1 \
    --early-stopping 20 \
    --overwrite --keep-best \
    --log train.log --valid-log valid.log --compress-bit 8 --compress-skip-bias
 
