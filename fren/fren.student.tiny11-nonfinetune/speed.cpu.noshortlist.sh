#!/bin/bash

MARIAN=../../../marian-dev/build

SRC=fr
TRG=en
export OMP_NUM_THREADS=1
mkdir -p speed
for wmt in wmt13 wmt14; do
  sacrebleu -t $wmt -l $SRC-$TRG --echo src > speed/newstest$wmt.$SRC
  $MARIAN/marian-decoder \
 	-c model.npz.decoder.noshortlist.yml -w 8000 \
 	--quiet --quiet-translation -i speed/newstest$wmt.$SRC \
        -o speed/newstest$wmt.out --log speed/$wmt.log \
 	--cpu-threads 1
  tail -n1 speed/$wmt.log
  sacrebleu -m bleu -t $wmt -l $SRC-$TRG <  speed/newstest$wmt.out | tee speed/$wmt.bleu
  sacrebleu -m chrf -t $wmt -l $SRC-$TRG <  speed/newstest$wmt.out | tee speed/$wmt.chrf
  if command -v comet-score &> /dev/null
  then
    comet-score -d $wmt:$SRC-$TRG -t speed/newstest$wmt.out --quiet | tee speed/$wmt.comet
  else
    echo "Comet not found"
  fi
done
