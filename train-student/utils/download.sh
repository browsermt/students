#!/bin/bash

set -x;

BASE_URL="http://ufallab.ms.mff.cuni.cz/~popel/wmt20/plen"
FILES=(
    checkpoint
    model.ckpt-525430.data-00000-of-00001   
    model.ckpt-525430.index
    model.ckpt-525430.meta
)


for FILE in ${FILES[@]}; do
    wget --continue --quiet --show-progress $BASE_URL/$FILE;
done
