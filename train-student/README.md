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

There are four main steps:

1. Preparing parallel and monolingual data (optional).
2. Generating distilled data for student training.
3. Training word alignment and lexical shortlists (recommended).
4. Training a student model.


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

