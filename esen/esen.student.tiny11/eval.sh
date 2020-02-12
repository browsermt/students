#!/bin/bash

MARIAN=../../marian-dev/build
DATA=../data

SRC=es
TRG=en

mkdir -p eval

for id in 13 12; do
    echo "### Evaluating wmt$id $SRC-$TRG"
    sacrebleu -t wmt$id -l $SRC-$TRG --echo src \
        | tee eval/newstest20$id.$SRC \
        | $MARIAN/marian-decoder -c config.yml -w 4000 --quiet --log eval/newstest20$id.log $@ \
        | tee eval/newstest20$id.$TRG \
        | sacrebleu -d -t wmt$id -l $SRC-$TRG \
        | tee eval/newstest20$id.$TRG.bleu
done

for prefix in UNv1.0.testset IWSLT13.TED.tst2013; do
    echo "### Evaluating $prefix $SRC-$TRG"
    cat $DATA/$prefix.$SRC \
        | tee eval/$prefix.$SRC \
        | $MARIAN/marian-decoder -c config.yml -w 4000 --quiet --log eval/$prefix.log $@ \
        | tee eval/$prefix.$TRG \
        | sacrebleu $DATA/$prefix.$TRG \
        | tee eval/$prefix.$TRG.bleu
done
