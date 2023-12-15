# Greek-English NMT Systems

## Students

| system                                  |  size | BLEU | COMET |
| ----------------------------------------| ----- | ---- | ----- |
| teacher base beam 6                     | 232MB | 33.6 | 0.684 |
| student tiny11, beam 1                  |  65MB | 31.9 | 0.651 |
| student tiny11, beam 1, intgemm8alphas  |  17MB | 31.8 | 0.643 |

Notes:
 - BLEU scores for Flores200 devtest, sacreBLEU signature: nrefs:1|case:mixed|eff:no|tok:13a|smooth:exp|version:2.3.1
