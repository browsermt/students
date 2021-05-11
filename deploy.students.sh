#!/usr/bin/env bash

set -e

export URLBASE="http://data.statmt.org/bergamot/models"

# Deploy student models
rm -rf models.json # Remove old generated models
for language in cs de es et is nb nn; do
  dir=${language}en
  cd $dir
  for pair in ${language}en en${language}; do
    for type in base tiny11; do
      student_model=$pair.student.$type
      if [ -d $student_model ]
      then
        cd $student_model
        echo "Deploying $student_model"
        tar -czvf $student_model.tar.gz --transform "s,^,${student_model}/," config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.gz lex.s2t.bin vocab.$dir.spm catalog-entry.yml server.intgemm8bitalpha.yml model_info.json
        scp $student_model.tar.gz $USER@magni:/mnt/vali0/www/data.statmt.org/bergamot/models/$dir
        cd ..
        ../generate_models_json.py ../models.json $student_model $dir $URLBASE
      fi
    done
  done
  cd ..
  scp models.json $USER@lofn:/mnt/vali0/www/data.statmt.org/bergamot/models/
done
