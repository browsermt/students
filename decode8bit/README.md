# So you want to decode in 8 bits?

This document will guide you through the process of taking a trained model, converting it to 8 bits and decoding with it.

## Instructions

1. Train your desired student model

2. Optional, but desireable. Finetune it with 8 bit loss. Student models are more difficult to quantize, so you should finetune them to reduce the BLEU hit. 

	- Compile the relevant marian branch: https://github.com/afaji/Marian/tree/fixed-quant

	- Convert the model to a *fake* 8bit format: 

	`python3 $MARIAN/scripts/simulate-compression.py -i model.npz.best-bleu-detok.npz -b 8 --fixed_point -o model-finetune.npz`

	- Take the training script that you used for producing the student and add the following switches to the marian command: `--compress-bit 8 --compress-skip-bias`. Example is shown in `run.me.finetune.example.sh`. Finetuning is **really** fast. The model's quality is going to start going down after a few thousand mini-batches. Make sure you have frequent validations so that you don't miss the sweet spot!

3. Compile the relevant marian branch: https://github.com/marian-nmt/marian-dev/tree/intgemm_reintegrated_computestats

4. Decode a sample test set in order to get typical quantization values. The relevant switch here is `--dump-quantmult`. A typical marian command would look like this:
```bash
$MARIAN/marian-decoder \
            --relative-paths -m model-finetune.npz.best-bleu-detok.npz -v vocab.spm vocab.spm --optimize8 --intgemm-shifted --intgemm-shifted-all --dump-quantmult \
            -i speed_intgemm/input.en -o speed_intgemm/output.de \
            --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
            --skip-cost --shortlist lex.s2t.gz 50 50 --cpu-threads 1 \
            --quiet --quiet-translation --log speed_intgemm/cpu.wmt16.log 2> quantmults
```
Furthermore `--optimize8 --intgemm-shifted --intgemm-shifted-all` are the relevant switches to get the fastest intgemm decoding.

5. Produce a model that includes the extra quantized values in it and the quantize it to 8 bits:
```bash
$MARIAN/../scripts/alphas/extract_stats.py quantmults model-finetune.npz.best-bleu-detok.npz model-finetune.npz.best-bleu-detok.alphas.npz
$MARIAN/marian-conv -f model-finetune.npz.best-bleu-detok.alphas.npz -t model-finetune.intgemm.alphas.bin --gemm-type intgemm8
```
Note, that you can fine tune the quantization procedure inside `extract_stats.py:53` By changing the hardcoded `+1.1*STDDEV` value. Anything from -1 to +2 seems to work to varying degrees.

In very rare cases, the `extract_stats.py` script might crash. If this happens, the most likely culprit is `tcmalloc`. If the model is too large (or the workspace too small), `tcmalloc` will spit $tcmalloc: large alloc...$ to stderr which our script doesn't know how to handle. Just delete that line inside the `quantmuls` file and you're good to go.

**IMPORTANT** CPU threads must be set to 1 for this step.

6. Decode using the new model:

```bash
$MARIAN/marian-decoder \
            --relative-paths -m model-finetune.intgemm.alphas.bin -v vocab.spm vocab.spm --optimize8 --intgemm-shifted --intgemm-shifted-all --use-precomputed-alphas \
            -i speed_intgemm/input.en -o speed_intgemm/output.de  \
            --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 128 \
            --skip-cost --shortlist lex.s2t.gz 50 50 --cpu-threads 1 \
            --quiet --quiet-translation --log speed_intgemm/cpu.wmt$i.log
```

The relevant intgemm switches are: `--optimize8 --intgemm-shifted --intgemm-shifted-all --use-precomputed-alphas`. You can use as many threads as you want in this setting. The script `run.me.quantize.example.sh` does steps 4-6.
