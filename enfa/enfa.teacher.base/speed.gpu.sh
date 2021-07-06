#!/bin/bash -v
set -e -o pipefail

MARIAN=~sukanta/tools/marian-dev/build
MOSES=~sukanta/tools/mosesdecoder
SUBWORD=~sukanta/tools/subword-nmt
SRC=en
TRG=fa

mkdir -p speed

# Custom test sets.
DATA=../data

for prefix in valid test2012 test2013; do
    echo "### Translating $prefix $SRC-$TRG"
    cat $DATA/$prefix.$SRC \
        | $MOSES/scripts/tokenizer/tokenizer.perl -a -l $SRC \
        | $MOSES/scripts/recaser/truecase.perl -model tc.$TRG \
        | $SUBWORD/apply_bpe.py -c $SRC$TRG.bpe \
        | tee speed/$prefix.$SRC \
        | $MARIAN/marian-decoder $@ -c config.yml --quiet --log speed/$prefix.log \
        | sed 's/\@\@ //g' \
        | $MOSES/scripts/recaser/detruecase.perl \
        | $MOSES/scripts/tokenizer/detokenizer.perl -l $TRG \
        | tee speed/$prefix.$TRG \
        | sacrebleu $DATA/$prefix.$TRG \
        | tee speed/$prefix.$TRG.bleu
    tail -n1 speed/$prefix.log
done
