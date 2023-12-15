# Ukrainian-English NMT Systems

## Students

| system                                  |  size | BLEU | COMET |
| ----------------------------------------| ----- | ---- | ----- |
| techaer base beam 6                     | 232MB | 35.4 | 0.624 |
| student tiny11, beam 1                  |  65MB | 32.8 | 0.555 |
| student tiny11, beam 1, intgemm8alphas  |  17MB | 33.1 | 0.552 |

Notes:
 - BLEU scores for WMT21 test, sacreBLEU signature: nrefs:1|case:mixed|eff:no|tok:13a|smooth:exp|version:2.3.1
