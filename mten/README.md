# Maltese-English models

## BLEU scores

| system                                  |  size | flores200 |
| ----------------------------------------| ----- | ---- |
| teacher base beam 6                     | 236MB | 45.9 |
| student tiny11, beam 1                  |  65MB | 42.7 |
| student tiny11, beam 1, intgemm8alphas  |  17MB | 42.7 |

SacreBLEU signature: nrefs:1|case:mixed|eff:no|tok:13a|smooth:exp|version:2.3.1
