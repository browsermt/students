# Training speed-optimized student NMT models

This directory contains instructions and scripts for building a baseline
CPU-optimized student model using the provided teacher model.

Note that some scripts require adjustments depending on the language pair,
amount of parallel and monolingual training data, available computing
resources, etc.  Open, read, and update a script before using it.


## Requirements

* marian-dev compiled with CPU FBGEMM, CUDA and SentencePiece
* 4 GPUs with 12GB memory (recommended)
* GNU parallel
* SacreBLEU


## Overview

There are four main steps and one optional step:

1. Preparing parallel and monolingual data (optional).
2. Generating distilled data for student training.
3. Training word alignment and lexical shortlists (recommended).
4. Training a student model.
5. Quantize the resulting student model (optional).


## Instructions

### 1. Preparing parallel and monolingual data

Note: This step can be replaced with your own data preprocessing.

- Put your parallel and monolingual data into `clean/`.
- Adjust variables in `clean/clean-*.sh`.
- Adjust variables in `clean/tools/clean-*.py` for your language pair if needed.
- Run `clean/clean-.sh`.

It is recommended to check the generated debug file what sentences were removed,
adjust parameters in `clean/tools/clean-*.py` and rerun if needed.
Rule-based filtering can be skipped if CE filtering is used later.
TODO: set parameters that works on most datasets removing worst data only.

### 2. Generating distilled data for student training

Scripts work with a teacher trained with Marian using SentencePiece as the only
input data pre-processor, i.e. no tokenization or truecasing is performed by
the scripts.

- Prepare the config file for your teacher: `data/teacher.yml`.
- Adjust variables in `data/translate-*.sh`.
- Generate forward-translations with `student/translate-*.sh` for parallel or
  monolingual data.

Optionally clean forward-translations by filtering a small part of sentences
w.r.t scores from a model trained in reversed direction in order to remove
possible translation fails. The reversed model does not need to be a high
performance model, it can be RNN-based.  See `ce-filter/Makefile` for more
details.

### 3. Training word alignment and lexical shortlists

- Install tools with `alignment/install.sh`.
- Train a SentencePiece vocab with `alignment/create-spm-vocab.sh` or re-use
  vocab.spm from the teacher.
- Prepare corpus and adjust variables in `alignment/generate-alignment-and-shortlist.sh`.
- Generate word alignment and lexical shortlists running the script.

### 4. Training a student model

- Collect training data in `models/student.*`, see `train.sh` for more details.
- Train a student model with `train.sh`.
- Adjust `eval.sh` and evaluate.

Make sure the training data is not contaminated with sentences from the
validation set.  It is recommended to use a larger validation set, e.g.
concatenate a few newsdev sets.

### 5. Optional 8bit quantization.
In order to deliver fast performance on user hardware, we need to quantize our models to 8bit. For more information check the wiki: https://github.com/browsermt/coordination/wiki/Low-precision-GEMM-and-Intgemm and https://www.aclweb.org/anthology/2020.ngt-1.26/

1. Train your desired student model

2. Optional, but desireable. Finetune by emulating 8bit GEMM during training. Student models are more difficult to quantize, so you should finetune them to reduce the BLEU hit. 

	- Compile the relevant marian branch: https://github.com/afaji/Marian/tree/fixed-quant

	- Convert the model to a *fake* 8bit format: 

	`python3 $MARIAN/scripts/simulate-compression.py -i model.npz.best-bleu-detok.npz -b 8 --fixed_point -o model-finetune.npz`

	- Take the training script that you used for producing the student and add the following switches to the marian command: `--compress-bit 8 --compress-skip-bias`. Example is shown in https://github.com/browsermt/students/blob/master/train-student/finetune/run.me.finetune.example.sh. Finetuning is **really** fast. The model's quality is going to start going down after a few thousand mini-batches. Make sure you have frequent validations so that you don't miss the sweet spot!

3. Compile the relevant marian branch: https://github.com/marian-nmt/marian-dev/tree/intgemm_reintegrated_computestats

4. Decode a sample test set in order to get typical quantization values. The relevant switch here is `--dump-quantmult`. A typical marian command would look like this:
```bash
$MARIAN/marian-decoder \
            --relative-paths -m model-finetune.npz.best-bleu-detok.npz -v vocab.spm vocab.spm --dump-quantmult \
            -i speed_intgemm/input.en -o speed_intgemm/output.de \
            --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
            --skip-cost --shortlist lex.s2t.gz 50 50 --cpu-threads 1 \
            --quiet --quiet-translation --log speed_intgemm/cpu.wmt16.log 2> quantmults
```
Furthermore `--int8shiftAlphaAll` is the relevant switches to get the fastest intgemm decoding.

5. Produce a model that includes the extra quantized values in it and the quantize it to 8 bits:
```bash
$MARIAN/../scripts/alphas/extract_stats.py quantmults model-finetune.npz.best-bleu-detok.npz model-finetune.npz.best-bleu-detok.alphas.npz
$MARIAN/marian-conv -f model-finetune.npz.best-bleu-detok.alphas.npz -t model-finetune.intgemm.alphas.bin --gemm-type intgemm8
```
Note, that you can fine tune the quantization procedure inside `extract_stats.py:53` By changing the hardcoded `+1.1*STDDEV` value. Anything from -1 to +2 seems to work to varying degrees.

**IMPORTANT** CPU threads must be set to 1 for this step.

6. Decode using the new model:

```bash
$MARIAN/marian-decoder \
            --relative-paths -m model-finetune.intgemm.alphas.bin -v vocab.spm vocab.spm --int8shiftAlphaAll \
            -i speed_intgemm/input.en -o speed_intgemm/output.de  \
            --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
            --skip-cost --shortlist lex.s2t.gz 50 50 --cpu-threads 1 \
            --quiet --quiet-translation --log speed_intgemm/cpu.wmt$i.log
```

The relevant intgemm switch is: `--int8shiftAlphaAll`. You can use as many threads as you want in this setting. The script https://github.com/browsermt/students/blob/master/deen/ende.student.base/speed.cpu.intgemm8bitalpha.sh does steps 4-6 using en-de as the student model.


