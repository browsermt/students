# Macedonian-English models

## BLEU scores

| system                                  |  size | flores200 |
| ----------------------------------------| ----- | ---- |
| teacher base beam 6                     | 236MB | 39.4 |
| student tiny11, beam 1                  |  65MB | 36.3 |
| student tiny11, beam 1, intgemm8alphas  |  17MB | 35.5 |

SacreBLEU signature: nrefs:1|case:mixed|eff:no|tok:13a|smooth:exp|version:2.3.1
