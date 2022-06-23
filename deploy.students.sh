#!/usr/bin/env bash

set -e

export URLBASE="https://data.statmt.org/bergamot/models"

# Fetch student models
for download_script in */download-models.sh ; do
  cd `dirname ${download_script}`
  echo "Downloading `dirname ${download_script}/download-models.sh`"
  sh download-models.sh
  cd ..
done

# Deploy student models
rm -rf models.json # Remove old generated models
for language in cs de es et is nb nn bg pl fr; do
  dir=${language}en
  cd $dir
  for pair in ${language}en en${language}; do
    for type in base tiny11; do
      student_model=$pair.student.$type
      if [ -d $student_model ]
      then
        cd $student_model
        echo "Deploying $student_model"
        rm -rf $student_model.tar.gz # Remove old model if it exists
        tar -czvf --owner=0 --group=0 $student_model.tar.gz --transform "s,^,${student_model}/," config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.bin vocab.$dir.spm catalog-entry.yml model_info.json
        scp $student_model.tar.gz $USER@lofn:/mnt/vali0/www/data.statmt.org/bergamot/models/$dir
        cd ..
        ../generate_models_json.py ../models.json $student_model/$student_model.tar.gz $student_model $dir $URLBASE
      fi
    done
  done
  cd ..
  scp models.json $USER@lofn:/mnt/vali0/www/data.statmt.org/bergamot/models/
done

# Deploy a special model for use by bergamot-translator-tests https://github.com/browsermt/bergamot-translator-tests
cd deen/ende.student.tiny11
tar -czvf ende.student.tiny.for.regression.tests.tar.gz --transform "s,^,ende.student.tiny.for.regression.tests/," config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.* vocab* catalog-entry.yml model_info.json model.npz config.yml
scp ende.student.tiny.for.regression.tests.tar.gz $USER@lofn:/mnt/vali0/www/data.statmt.org/bergamot/models/deen
