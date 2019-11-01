#!/bin/bash

# Downloads and compiles Marian
# See https://marian-nmt.github.io/docs/#installation for requirements

set -e

git clone https://github.com/marian-nmt/marian-dev
mkdir -p marian-dev/build
cd marian-dev/build
cmake .. -DUSE_SENTENCEPIECE=on -DCOMPILE_CPU=on
cd ../..

pip3 install sacrebleu --user
