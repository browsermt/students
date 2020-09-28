#!/bin/bash
##
# Basic cleaning of parallel corpora.
#
# Usage:
#   bash clean-corpus.sh prefix [prefix...]
#

set -eo pipefail;
set -x;

TOOLS=./tools
SRC=en
TRG=pl

NCPUS=16

if [-z "$SLURM_CPUS_PER_TASK"]; then
    NCPUS=$SLURM_CPUS_PER_TASK
fi


for data in $@; do
    # Check if files exist
    test -s $data.$SRC.gz || exit 1
    test -s $data.$TRG.gz || exit 1

    ######################################################################
    # Basic preprocessing
    for lng in $SRC $TRG; do

        pigz -dc $data.$lng.gz \
            | parallel --no-notice --pipe -k -j${NCPUS} --block 50M "perl $TOOLS/remove-non-printing-char.perl | perl $TOOLS/normalize-punctuation.perl -l $lng" \
            | pigz > $data.$lng.nrm.gz
    done

    test -s $data.$SRC.nrm.gz || exit 1
    test -s $data.$TRG.nrm.gz || exit 1

    ######################################################################
    # Deduplication
    paste <(pigz -dc $data.$SRC.nrm.gz) <(pigz -dc $data.$TRG.nrm.gz) \
        | LC_ALL=C sort -S 10G | uniq \
        | pigz > $data.$SRC$TRG.nrm.uniq.gz

    test -s $data.$SRC$TRG.nrm.uniq.gz || exit 1

    ######################################################################
    # Language identification
    pigz -dc $data.$SRC$TRG.nrm.uniq.gz \
        | parallel --no-notice --pipe -k -j${NCPUS} --block 50M "python3 $TOOLS/langid-fasttext.py -f 1 | python3 $TOOLS/langid-fasttext.py -f 1" \
        | grep -P "^$SRC\t$TRG\t" \
        | cut -f3,4 \
        | pigz > $data.$SRC$TRG.langid.gz

    test -s $data.$SRC$TRG.langid.gz

    ######################################################################
    # Rule-based filtering
    pigz -dc $data.$SRC$TRG.langid.gz \
        | parallel --no-notice --pipe -k -j${NCPUS} --block 50M "python3 $TOOLS/clean-parallel.py -l1 $SRC -l2 $TRG --debug" \
        2> $data.$SRC$TRG.clean.debug.txt \
        | pigz > $data.$SRC$TRG.clean.gz

    pigz -dc $data.$SRC$TRG.clean.gz | cut -f1 | pigz > $data.$SRC.clean.gz
    pigz -dc $data.$SRC$TRG.clean.gz | cut -f2 | pigz > $data.$TRG.clean.gz

    test -s $data.$SRC.clean.gz || exit 1
    test -s $data.$TRG.clean.gz || exit 1

    # Remove $data from intermediate steps
    #rm -f *.nrm.gz *.nrm.uniq.gz *.langid.gz
    #wc -l *.debug.txt
done

