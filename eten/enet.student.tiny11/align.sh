#!/bin/bash -v

MARIAN=/fs/snotra0/romang/work/bergamot//marian-dev/build

SRC=en
TRG=et

mkdir -p align

echo "### Generating alignments for wmt18/dev $SRC-$TRG"
sacrebleu -t wmt18/dev -l $SRC-$TRG --echo src \
    | tee align/newsdev2018.$SRC \
    | $MARIAN/marian-decoder -c config.yml --quiet --alignment $@ \
    | sed 's/.* ||| //' \
    > align/newsdev2018.$SRC$TRG.aln

echo "### Generating alignments for wmt18 $SRC-$TRG"
sacrebleu -t wmt18 -l $SRC-$TRG --echo src \
    | tee align/newstest2018.$SRC \
    | $MARIAN/marian-decoder -c config.yml --quiet --alignment $@ \
    | sed 's/.* ||| //' \
    > align/newstest2018.$SRC$TRG.aln
