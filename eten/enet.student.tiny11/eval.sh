#!/bin/bash

MARIAN=../../marian-dev/build
DATA=../data

SRC=en
TRG=et

mkdir -p eval

echo "### Evaluating wmt18/dev $SRC-$TRG"
sacrebleu -t wmt18/dev -l $SRC-$TRG --echo src \
    | tee eval/newsdev2018.$SRC \
    | $MARIAN/marian-decoder -c config.yml --quiet --log eval/newsdev2018.log $@ \
    | tee eval/newsdev2018.$TRG \
    | sacrebleu -t wmt18/dev -l $SRC-$TRG \
    | tee eval/newsdev2018.$TRG.bleu

echo "### Evaluating wmt18 $SRC-$TRG"
sacrebleu -t wmt18 -l $SRC-$TRG --echo src \
    | tee eval/newstest2018.$SRC \
    | $MARIAN/marian-decoder -c config.yml --quiet --log eval/newstest2018.log $@ \
    | tee eval/newstest2018.$TRG \
    | sacrebleu -t wmt18 -l $SRC-$TRG \
    | tee eval/newstest2018.$TRG.bleu

echo "### Evaluating Tatoeba $SRC-$TRG"
cat $DATA/Tatoeba.en-et.$SRC \
    | tee eval/tatoeba.$SRC \
    | $MARIAN/marian-decoder -c config.yml --quiet --log eval/tatoeba.log $@ \
    | tee eval/tatoeba.$TRG \
    | sacrebleu $DATA/Tatoeba.en-et.$TRG \
    | tee eval/tatoeba.$TRG.bleu
