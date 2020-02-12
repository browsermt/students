# Spanish-English NMT systems

Teacher and student models for Spanish.


## Teachers


_newstest2013_, cased BLEU

| system | en-es | es-en | comment |
|--------|-------|-------|---------|
| [Best WMT13 UEdin](http://matrix.statmt.org/matrix/systems_list/1723)     | 30.4 | | Moses
| [Best WMT13 Kenneth](http://matrix.statmt.org/matrix/systems_list/1718)   | | 31.4 | Moses
| transformer-base              | 31.2 | 33.4 |
| transformer-base, filtering   | 34.5 | 35.4 |
||||
| transformer-big, sBT          | 36.3 | 37.0 | 
| transformer-big, sBT+BT       | 36.5 | -    | 
| transformer-big, sBT+FT       | -    | 36.5 | 
| - ensemble x2 (teacher)       | 36.5 | 37.0 | small improvements on WMT12, TED13 & UNv1


Notes:

* BLEU scores for Spanish newstest2013 from sacreBLEU:
  BLEU+case.mixed+lang.es-en+numrefs.1+smooth.exp+test.wmt13+tok.13a+version.1.4.1
* Transformer-big models have been trained on OPUS+OpenSubtitles+Paracrawl
  data, cleaned with rule-based and dual cross-entropy noise filtering, and
  trained with sampled back-translations (sBT).


## Students


### Spanish-English

| system | size (MB) | BLEU | CPU (sec) | GPU (sec) |
|--------|----------:|------|-----------|-----------|
| teacher ensemble x2, beam 6         | 2x 798MB | 36.9 | --  | 166s |
| student tiny11, beam 1              |     65MB | 35.7 | 78s | 3.7s |
| student tiny11, beam 1, packed8avx2 |     46MB | 35.5 | 47s | --   |


### English-Spanish

In progress...


Notes:

* Students are tiny transformers: 256 emb., 1536 FFN, 6-layer encoder, 2-layer
  decoder (not tied) with SSRU units (tiny11).
* Trained on teacher-generated parallel data, back- and forward-translations,
  with guided alignments.
* Evaluated on newstest2013, which consists of 3,000 sentences (ca. 62k Spanish
  tokens and 56k English tokens).
* Tested with marian-dev v1.8.40 compiled with FBGEMM (on elli):
  * CPU: Intel(R) Xeon(R) CPU E5-2620 v3 @ 2.10GHz (avx2), single thread,
    mini-batch 32, beam size 1, lexical shortlist
  * GPU: GeForce GTX 1080 Ti, mini-batch 64, beam size 1
