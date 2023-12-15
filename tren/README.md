# Turkish-English models

## BLEU scores

| system                                  |  size | wmt17 | wmt18 |
| ----------------------------------------| ----- | ---- | ---- |
| teacher base beam 6                     | 236MB | 29.6 | 29.9 |
| student tiny11, beam 1                  |  65MB | 28.8 | 28.2 |
| student tiny11, beam 1, intgemm8alphas  |  17MB | 28.4 | 27.8 |

SacreBLEU signature: nrefs:1|case:mixed|eff:no|tok:13a|smooth:exp|version:2.3.1
