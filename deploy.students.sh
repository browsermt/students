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
for language in cs de es et is nb nn bg pl fr is hbs sl mk mt tr sq ca el uk; do
  if [[ ${#language} -eq 3 ]]; then
    eng=eng
  else
    eng=en
  fi
  dir=${language}$eng
  cd $dir
  for pair in ${language}$eng $eng${language}; do
    for type in base tiny11; do
      student_model=$pair.student.$type
      if [ -d $student_model ]
      then
        cd $student_model
        echo "Deploying $student_model"
        rm -rf $student_model.tar.gz # Remove old model if it exists
        tar -czvf $student_model.tar.gz --transform "s,^,${student_model}/," config.intgemm8bitalpha.yml model.intgemm.alphas.bin speed.cpu.intgemm8bitalpha.sh lex.s2t.bin vocab.$dir.spm catalog-entry.yml model_info.json --owner=0 --group=0
        hash=`sha256sum $student_model.tar.gz | cut -c 1-16`
        version=`jq -r .version model_info.json`
        frozen_archive=$student_model.v$version.$hash.tar.gz
        mv $student_model.tar.gz $frozen_archive
        scp $frozen_archive $USER@lofn:/mnt/vali0/www/data.statmt.org/bergamot/models/$dir
        cd ..
        ../generate_models_json.py ../models.json $student_model/$frozen_archive $student_model $dir $URLBASE
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
