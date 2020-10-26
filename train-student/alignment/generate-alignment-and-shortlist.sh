#!/bin/bash
#SBATCH -J "pl-en"
#SBATCH --account t2-cs119-cpu
#SBATCH --nodes=1
#SBATCH --cpus-per-task 32
#SBATCH --time=36:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=jphilip@ed.ac.uk
#SBATCH --no-requeue
#SBATCH --partition skylake
#SBATCH --signal=B:USR1@300
#SBATCH --output=/home/cs-phil1/slurm-logs/generate-alignment-%j.log

# set -eo pipefail

# New hackery

module load use.own
module load marian/dev-467b15e2
module load fast_align/cab1e9a
module load sentencepiece/0.1.92
module load extract_lex/42fa605
module load parallel/20131222


set -x;


# Adjust variables if needed.
# MARIAN=../../marian-dev/build
# VOCAB=../../esen/enes.teacher.bigx2/vocab.esen.spm
SRC=en
TRG=pl
VOCAB_SRC="/home/cs-phil1/rds/rds-t2-cs119/jerin/pl-en/sentencepiece-models/${SRC}.32768.model"
VOCAB_TRG="/home/cs-phil1/rds/rds-t2-cs119/jerin/pl-en/sentencepiece-models/${TRG}.32768.model"
CORPUS_SRC="/home/cs-phil1/rds/rds-t2-cs119/jerin/pl-en/intermediate/shards/combined.$SRC.gz"
CORPUS_TRG="/home/cs-phil1/rds/rds-t2-cs119/jerin/pl-en/intermediate/shards/combined.$TRG.gz"

# BIN=bin
# test -e atools      || exit 1
# test -e extract_lex || exit 1
# test -e fast_align  || exit 1

# DIR=align
export NCPUS=${SLURM_CPUS_PER_TASK:-16}
DIR="/local/cs-phil1/align"
mkdir -p $DIR

echo $CORPUS_SRC >> $DIR/README
echo $CORPUS_TRG >> $DIR/README

# Subword segmentation with SentencePiece.
test -s $DIR/corpus.spm.$SRC || cat $CORPUS_SRC | pigz -dc | parallel --no-notice --pipe -k -j$NCPUS --block 50M "spm_encode --model $VOCAB_SRC" > $DIR/corpus.spm.$SRC
test -s $DIR/corpus.spm.$TRG || cat $CORPUS_TRG | pigz -dc | parallel --no-notice --pipe -k -j$NCPUS --block 50M "spm_encode --model $VOCAB_TRG" > $DIR/corpus.spm.$TRG

test -s $DIR/corpus     || paste $DIR/corpus.spm.$SRC $DIR/corpus.spm.$TRG | sed 's/\t/ ||| /' > $DIR/corpus

# Alignment.
test -s $DIR/align.s2t  || fast_align -vod  -i $DIR/corpus > $DIR/align.s2t
test -s $DIR/align.t2s  || fast_align -vodr -i $DIR/corpus > $DIR/align.t2s

test -s $DIR/corpus.aln || atools -i $DIR/align.s2t -j $DIR/align.t2s -c grow-diag-final-and > $DIR/corpus.aln

# Shortlist.
test -s $DIR/lex.s2t    || extract_lex $DIR/corpus.spm.$TRG $DIR/corpus.spm.$SRC $DIR/corpus.aln $DIR/lex.s2t $DIR/lex.t2s

# Clean.
rm $DIR/corpus $DIR/corpus.spm.?? $DIR/align.???

pigz $DIR/corpus.aln
pigz $DIR/lex.s2t
pigz $DIR/lex.t2s

# Shortlist pruning (optional).
test -e $DIR/vocab.$SRC.txt         || spm_export_vocab --model=$VOCAB_SRC --output=$DIR/vocab.${SRC}.txt
test -e $DIR/vocab.$TRG.txt         || spm_export_vocab --model=$VOCAB_TRG --output=$DIR/vocab.${TRG}.txt 
test -e $DIR/lex.s2t.pruned.gz || pigz -dc $DIR/lex.s2t.gz | grep -v NULL | python3 prune_shortlist.py 100 $DIR/vocab.${SRC}.txt | pigz > $DIR/lex.s2t.pruned.gz
test -e $DIR/lex.t2s.pruned.gz || pigz -dc $DIR/lex.t2s.gz | grep -v NULL | python3 prune_shortlist.py 100 $DIR/vocab.${TRG}.txt | pigz > $DIR/lex.t2s.pruned.gz


echo "Outputs:"
ls $DIR/*.gz

OUTPUTS="/home/cs-phil1/rds/rds-t2-cs119/jerin/pl-en/intermediate/alignment-outputs/"
mv $DIR/*.gz $OUTPUTS/

sleep 2h;

