# Finetuning quantized models

Finetune by emulating 8bit GEMM during training. Student models are more difficult to quantize, so you should finetune them to reduce the BLEU hit. 

	- Compile the relevant marian branch: https://github.com/afaji/Marian/tree/fixed-quant

	- Convert the model to a *fake* 8bit format: 

	`python3 $MARIAN/scripts/simulate-compression.py -i model.npz.best-bleu-detok.npz -b 8 --fixed_point -o model-finetune.npz`

	- Take the training script that you used for producing the student and add the following switches to the marian command: `--compress-bit 8 --compress-skip-bias`. Example is shown in `run.me.finetune.example.sh`. Finetuning is **really** fast. The model's quality is going to start going down after a few thousand mini-batches. Make sure you have frequent validations so that you don't miss the sweet spot!
