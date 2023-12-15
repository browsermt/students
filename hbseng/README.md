# SerboCroatian-English models

## BLEU scores

| system                                  |  size | wmt13\_hrv | flores200\_bos | ntrex128\_srp | MontentegrinSubs |
| ----------------------------------------| ----- | ---------- | -------------- | ------------- | ---------------- |
| teacher base beam 6                     | 236MB | 46.5 | 38.6 | 31.3 | 39.6 |
| student tiny11, beam 1                  |  65MB | 44.7 | 36.7 | 29.4 | 37.6 |
| student tiny11, beam 1, intgemm8alphas  |  17MB | 44.5 | 36.1 | 28.8 | 36.8 |


Notes:
 - SacreBLEU signature: nrefs:1|case:mixed|eff:no|tok:13a|smooth:exp|version:2.3.1
 - This model does not support cyrillic script. To translate text in cyrillic, please use https://github.com/opendatakosovo/cyrillic-transliteration before translation.
