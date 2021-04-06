#!/bin/env bash
for i in $(ls -d */ | grep -v "train-student"); do
  echo $i
  cd $i
  bash download-data.sh
  bash download-models.sh
  cd ..
done
