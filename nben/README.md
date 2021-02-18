# Norwegian Bokmål-English NMT Systems

## Students

| system                                  |  size | BLEU | CPU(s) | GPU(s) |
| ----------------------------------------| ----- | ---- | ------ | ------ |
| teacher base beam 6                     | 200MB | 44.9 |   -    |  27.7  |
| student tiny11, beam 1                  |  49MB | 42.8 |  24.6  |  3.22  |
| student tiny11, beam 1, intgemm8        |  13MB | 42.6 |  18.9  | - |
| student tiny11, beam 1, intgemm8alphas  |  13MB | 42.7 |  17.9  | - |

Notes: 
 - BLEU scores for self-crawled TED Talks test, sacreBLEU signature: BLEU+case.mixed+numrefs.1+smooth.exp+tok.13a+version.1.4.14
 - Transformer Base teacher has been trained with OpenSubtitles, JW300 and WikiMatrix data cleaned with the tools provided in this repository.
 - Tested with browsermt/marian-dev 1.9.36:
    - GPU: NVIDIA GeForce RTX 2080 Ti, mini-batch 64, beam 1
    - CPU: Intel(R) Core(TM) i9-9940X CPU @ 3.30GHz, single thread, mini-batch 16, beam size 1, lexical shortlist
