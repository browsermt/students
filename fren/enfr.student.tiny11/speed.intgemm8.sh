#!/bin/bash

MARIAN=../../../marian-dev/build

SRC=en
TRG=fr
export OMP_NUM_THREADS=1
mkdir -p speed


test -e lex.s2t.bin || $MARIAN/marian-conv --shortlist lex.s2t.pruned.gz 100 100 0 --dump lex.s2t.bin --vocabs vocab.fren.spm vocab.fren.spm
test -e model.intgemm.bin || $MARIAN/marian-conv -f model.npz -t model.intgemm.bin --gemm-type intgemm8

for wmt in wmt13 wmt14; do
  sacrebleu -t $wmt -l $SRC-$TRG --echo src > speed/newstest$wmt.$SRC
  $MARIAN/marian-decoder \
 	-c config.intgemm8bit.yml -w 8000 \
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
