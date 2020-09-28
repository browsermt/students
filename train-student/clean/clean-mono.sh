#!/bin/bash
##
# Basic cleaning of $monolingual corpora.
#
# Usage:
#   bash clean-mono.sh prefix [prefix...]
#

set -eo pipefail;
set -x;

TOOLS=./tools
SRC=pl

NCPUS=16

if [ ! -z "$SLURM_CPUS_PER_TASK" ]; then
    NCPUS=$SLURM_CPUS_PER_TASK
fi

for mono in $@; do
    # Check if files exist
    test -s $mono.$SRC.gz || exit 1

    ######################################################################
    # Basic preprocessing
    pigz -dc $mono.$SRC.gz \
        | parallel --no-notice --pipe -k -j${NCPUS} --block 50M "perl $TOOLS/remove-non-printing-char.pl | perl $TOOLS/normalize-punctuation.pl -l $SRC" \
        | pigz > $mono.$SRC.nrm.gz

    test -s $mono.$SRC.nrm.gz || exit 1

    ######################################################################
    # Deduplication
    pigz -dc $mono.$SRC.nrm.gz | LC_ALL=C sort -S 10G | uniq | pigz > $mono.$SRC.nrm.uniq.gz

    test -s $mono.$SRC.nrm.uniq.gz || exit 1

    ######################################################################
    # Language identification
    pigz -dc $mono.$SRC.nrm.uniq.gz \
        | parallel --no-notice --pipe -k -j${NCPUS} --block 50M "python $TOOLS/langid-fasttext.py" \
        | grep -P "^$SRC\t" | cut -f2 \
        | pigz > $mono.$SRC.langid.gz

    ######################################################################
    # Rule-based filtering
    pigz -dc $mono.$SRC.langid.gz \
        | parallel --no-notice --pipe -k -j${NCPUS} --block 50M "python $TOOLS/clean-parallel.py -l $SRC --debug" \
        2> $mono.$SRC.clean.debug.txt \
        | pigz > $mono.$SRC.clean.gz

    test -s $mono.$SRC.clean.gz || exit 1

    # Remove data from intermediate steps
    #rm -f *.nrm.gz *.nrm.uniq.gz *.langid.gz
    #wc -l *.debug.txt
done

