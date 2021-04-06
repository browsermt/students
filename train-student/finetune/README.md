# Finetuning quantized models

Finetune by emulating 8bit GEMM during training. Student models are more difficult to quantize, so you should finetune them to reduce the BLEU hit. 

- Compile the master marian branch: https://github.com/marian-nmt/marian-dev/

- Take the training script that you used for producing the student and add the following switches to the marian command: `--quantize-bits 8`. 

Example is shown in `run.me.finetune.example.sh`. Finetuning is **really** fast. The model's quality is going to start going down after a few thousand mini-batches. Make sure you have frequent validations so that you don't miss the sweet spot!
