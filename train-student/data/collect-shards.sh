#!/bin/bash
#SBATCH -J "pl-en"
#SBATCH --account t2-cs119-cpu
#SBATCH --nodes=1
#SBATCH --cpus-per-task 32
#SBATCH --time=36:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=jphilip@ed.ac.uk
#SBATCH --no-requeue
#SBATCH --partition pascal
#SBATCH --signal=B:USR1@300
#SBATCH --output=/home/cs-phil1/slurm-logs/collect-%j.log

. ~/envs/student/bin/activate
module load parallel/20131222

set -eo pipefail;
set -x;

PARALLEL_COMPLETED="170"
MONO_COMPLETED="34"

# PARALLEL_COMPLETED="0"
# MONO_COMPLETED="0"
export SRC="pl"
export TGT="en"

export SHARD_ROOT="/rds/project/t2_vol4/rds-t2-cs119/jerin/pl-en/intermediate/shards"
export LOCAL_ROOT="/local/cs-phil1"
mkdir -p $LOCAL_ROOT

export NCPUS=${SLURM_CPUS_PER_TASK:-16}

function proc-parallel {
    SUFFIX=$(printf "%03d" $1)

    pigz -dc "$SHARD_ROOT/parallel${SUFFIX}.tsv.${SRC}.gz" > "$LOCAL_ROOT/parallel-collect.source.${SUFFIX}.${SRC}"
    pigz -dc "$SHARD_ROOT/parallel${SUFFIX}.tsv.${SRC}.gz.translated.${TGT}.gz" > "$LOCAL_ROOT/parallel-collect.nbest.${SUFFIX}.${TGT}"
    pigz -dc "$SHARD_ROOT/parallel${SUFFIX}.tsv.${TGT}.gz" > "$LOCAL_ROOT/parallel-collect.refs.${SUFFIX}.${TGT}"

    python3 bestbleu.py \
        -m sacrebleu  -t t2t                              \
        -i $LOCAL_ROOT/parallel-collect.nbest.${SUFFIX}.${TGT} \
        -r $LOCAL_ROOT/parallel-collect.refs.${SUFFIX}.${TGT}  \
        -o $LOCAL_ROOT/parallel-collect.bestbleu.${SUFFIX}.${TGT}
}

function proc-monolingual {
    SUFFIX=$(printf "%03d" $1)
    pigz -dc "$SHARD_ROOT/monolingual${SUFFIX}.${SRC}.gz" > "$LOCAL_ROOT/mono-collect.source.${SUFFIX}.${SRC}"
    pigz -dc "$SHARD_ROOT/monolingual${SUFFIX}.${SRC}.gz.translated.${TGT}.gz" > "$LOCAL_ROOT/mono-collect.nbest.${SUFFIX}.${TGT}"


    # parser = ArgumentParser(description='Utility to generate parallel data from tensor2tensor translation outputs') 
    # parser.add_argument('--source', type=str, required=True, help='Path to source data used for t2t-decoder')
    # parser.add_argument('--src-lang', type=str, required=True, help='Source language')
    # parser.add_argument('--tgt-lang', type=str, required=True, help='Target language')
    # parser.add_argument('--t2t-output', type=str, required=True, help='Path to t2t-decoder output file')
    # parser.add_argument('--nbest', type=int, required=False, default=-1, help='nbest used for T2T decoding')

    python3 ../t2t/collect-pairs.py \
        --source "$LOCAL_ROOT/mono-collect.source.${SUFFIX}.${SRC}" \
        --src-lang $SRC --tgt-lang $TGT                             \
        --t2t-output "$LOCAL_ROOT/mono-collect.nbest.${SUFFIX}.${TGT}"

}

function build-single-file-from-shards {
    # rm "${LOCAL_ROOT}/combined.${SRC}"
    # rm "${LOCAL_ROOT}/combined.${TGT}"

    for i in $(seq 0 $PARALLEL_COMPLETED); do
        SUFFIX=$(printf "%03d" $i)
        cat "$LOCAL_ROOT/parallel-collect.source.${SUFFIX}.${SRC}" >> "$LOCAL_ROOT/combined.${SRC}"
        cat "$LOCAL_ROOT/parallel-collect.bestbleu.${SUFFIX}.${TGT}" >> "$LOCAL_ROOT/combined.${TGT}"
    done

    for i in $(seq 0 $MONO_COMPLETED); do
        SUFFIX=$(printf "%03d" $i)
        cat "$LOCAL_ROOT/mono-collect.source.${SUFFIX}.${SRC}.t2tproc.${SRC}" >> "${LOCAL_ROOT}/combined.${SRC}"
        cat "$LOCAL_ROOT/mono-collect.source.${SUFFIX}.${SRC}.t2tproc.${TGT}" >> "${LOCAL_ROOT}/combined.${TGT}"
        #                mono-collect.source.000      .pl    .t2tproc.pl
    done
}


export -f proc-parallel
export -f proc-monolingual 

# seq 0 "$PARALLEL_COMPLETED" | parallel --bar --no-notice -j$NCPUS -I% 'proc-parallel %'
# seq 0 "$MONO_COMPLETED" | parallel --bar --no-notice -j$NCPUS -I% 'proc-monolingual %'
build-single-file-from-shards;

pigz $LOCAL_ROOT/combined.${SRC} && mv $LOCAL_ROOT/combined.${SRC}.gz $SHARD_ROOT/
pigz $LOCAL_ROOT/combined.${TGT} && mv $LOCAL_ROOT/combined.${TGT}.gz $SHARD_ROOT/
