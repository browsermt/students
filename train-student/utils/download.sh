#!/bin/bash

set -x;

BASE_URL="http://ufallab.ms.mff.cuni.cz/~popel/wmt20"
FILES=(
    "plen/checkpoint"
    "plen/model.ckpt-525430.data-00000-of-00001"
    "plen/model.ckpt-525430.index"
    "plen/model.ckpt-525430.meta"
    "vocab.enpl.32768"
)


for FILE in ${FILES[@]}; do
    wget --continue $BASE_URL/$FILE;
done
