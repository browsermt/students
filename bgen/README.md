
# Bulgarian-English/English-Bulgarian models
## BLEU scores

| **bg-en** ELRC-corpora_state_administration_sites-1-bul-eng | BLEU | CHRF |
|----------------------------------------------------------|:----:|:----:|
| Teacher0                                                 | 46.5 | 69.8 |
| Teacher1                                                 | 46.4 | 69.7 |
| Teacher ensemble                                         | 46.8 | 70.0 |
| Student-tiny11                                           | 45.0 | 69.3 |
| Student-tiny11-finetuned                                 | 44.9 | 69.2 |
| Student-tiny11-8bit + shortlist                          | 44.8 | 69.0 |
| Student-tiny11-8bit-alpha + shortlist                    | 44.5 | 68.9 |
| Student-tiny11-finetuned-8bit + shortlist                | 44.7 | 69.0 |
| Student-tiny11-finetuned-8bit-alpha + shortlist          | 44.6 | 69.0 |

| **en-bg** ELRC-corpora_state_administration_sites-1-bul-eng | BLEU | CHRF |
| ---------------------------------------------------------|:----:|:----:|
| Teacher0                                                 | 47.3 | 71.6 |
| Teacher1                                                 | 46.9 | 71.2 |
| Teacher ensemble                                         | 47.3 | 71.7 |
| Student-tiny11                                           | 43.8 | 69.4 |
| Student-tiny11-finetuned                                 | 43.8 | 69.3 |
| Student-tiny11-8bit + shortlist                          | 43.4 | 69.1 |
| Student-tiny11-8bit-alpha + shortlist                    | 43.2 | 69.0 |
| Student-tiny11-finetuned-8bit + shortlist                | 43.5 | 69.2 |
| Student-tiny11-finetuned-8bit-alpha + shortlist          | 43.6 | 69.1 |

Dev set: ELRC-corpora_state_administration_sites-1-bul-eng https://elrc-share.eu/repository/download/8507b82eaab611e8b7d400155d026706a07f556156eb445f8b9e28af532acd3e/ Bulgarian-Eng  
lish parallel corpus/government.bg.bg-en.tmx,Bulgarian-English parallel

## Training configuration
Trained using https://github.com/mozilla/firefox-translations-training/
Configuration
### BG-EN
```yml
# these are set in the Makefile  
root: ""  
cuda: ""  
deps: false  
gpus: ""  
workspace: ""  
  
  
experiment:  
name: snakemake-bg-en  
src: bg  
trg: en  
  
teacher-ensemble: 2  
# path to a pretrained backward model (optional)  
backward-model: ""  
  
# limits per downloaded dataset  
mono-max-sentences-src: 200000000  
mono-max-sentences-trg: 200000000  
  
bicleaner-threshold: 0.5  
  
# split corpus to parallelize translation  
split-length: 2000000  
  
best-model: chrf  
  
bicleaner:  
default-threshold: 0.5  
dataset-thresholds:  
opus_CCAligned/v1: 0.7  
opus_WikiMatrix/v1: 0.7  
opus_OpenSubtitles/v2018: 0.9  
opus_bible-uedin/v1: 0.7  
  
training:  
s2s:  
after-epochs: 10  
# limit number of epochs on augmented dataset (high resource languages)  
teacher-all:  
after-epochs: 5  
  
  
datasets:  
# parallel corpus  
train:  
- opus_Ubuntu/v14.10  
- opus_Tanzil/v1  
- opus_KDE4/v2  
- opus_CCMatrix/v1  
- opus_ELRA-W0301/v1  
- opus_SETIMES/v2  
- opus_CCAligned/v1  
- opus_GlobalVoices/v2018q4  
- opus_ELRC_2922/v1  
- opus_ELRC_2923/v1  
- opus_ELRC_3382/v1  
- opus_ELRA-W0297/v1  
- opus_bible-uedin/v1  
- opus_Tatoeba/v2021-07-22  
- opus_ELRA-W0173/v1  
- opus_ELRA-W0263/v1  
- opus_ELRA-W0211/v1  
- opus_WikiMatrix/v1  
- opus_wikimedia/v20210402  
- opus_EMEA/v3  
- opus_OpenSubtitles/v2018  
- opus_Europarl/v8  
- opus_XLEnt/v1.1  
- opus_ParaCrawl/v8  
- opus_TildeMODEL/v2018  
- opus_GNOME/v1  
- opus_EUbookshop/v2  
- opus_ELRA-W0133/v1  
- opus_QED/v2.0a  
- opus_Wikipedia/v1.0  
- opus_TED2020/v1  
- opus_JRC-Acquis/v3.0  
- opus_ELRA-W0308/v1  
- opus_ELRA-W0134/v1  
- opus_DGT/v2019  
- opus_ELRC_2682/v1  
devtest:  
- custom-corpus_/mnt/hrist0/nbogoych/government.bg  
test:  
- custom-corpus_/mnt/hrist0/nbogoych/government.bg  
# monolingual datasets (ex. paracrawl-mono_paracrawl8, commoncrawl_wmt16, news-crawl_news.2020)  
# to be translated by the teacher model  
mono-trg:  
- news-crawl_news.2020  
- news-crawl_news.2019  
# to be translated by the shallow backward model to augment teacher corpus with back-translations  
# leave empty to skip augmentation step (high resource languages)  
mono-src:  
- news-crawl_news.2020  
- news-crawl_news.2019  
- news-crawl_news.2018  
- news-crawl_news.2017  
- news-crawl_news.2016  
- news-crawl_news.2015  
- news-crawl_news.2014  
- news-crawl_news.2013
```

### EN-BG
```yml
# these are set in the Makefile  
root: ""  
cuda: ""  
deps: false  
gpus: ""  
workspace: ""  
  
  
experiment:  
name: snakemake-en-bg  
src: en  
trg: bg  
  
teacher-ensemble: 2  
# path to a pretrained backward model (optional)  
backward-model: ""  
  
# limits per downloaded dataset  
mono-max-sentences-src: 200000000  
mono-max-sentences-trg: 200000000  
  
bicleaner-threshold: 0.5  
  
# split corpus to parallelize translation  
split-length: 2000000  
  
best-model: chrf  
  
bicleaner:  
default-threshold: 0.5  
dataset-thresholds:  
opus_CCAligned/v1: 0.7  
opus_WikiMatrix/v1: 0.7  
opus_OpenSubtitles/v2018: 0.9  
opus_bible-uedin/v1: 0.7  
  
training:  
s2s:  
after-epochs: 10  
# limit number of epochs on augmented dataset (high resource languages)  
teacher-all:  
after-epochs: 5  
  
  
datasets:  
# parallel corpus  
train:  
- opus_Ubuntu/v14.10  
- opus_Tanzil/v1  
- opus_KDE4/v2  
- opus_CCMatrix/v1  
- opus_ELRA-W0301/v1  
- opus_SETIMES/v2  
- opus_CCAligned/v1  
- opus_GlobalVoices/v2018q4  
- opus_ELRC_2922/v1  
- opus_ELRC_2923/v1  
- opus_ELRC_3382/v1  
- opus_ELRA-W0297/v1  
- opus_bible-uedin/v1  
- opus_Tatoeba/v2021-07-22  
- opus_ELRA-W0173/v1  
- opus_ELRA-W0263/v1  
- opus_ELRA-W0211/v1  
- opus_WikiMatrix/v1  
- opus_wikimedia/v20210402  
- opus_EMEA/v3  
- opus_OpenSubtitles/v2018  
- opus_Europarl/v8  
- opus_XLEnt/v1.1  
- opus_ParaCrawl/v8  
- opus_TildeMODEL/v2018  
- opus_GNOME/v1  
- opus_EUbookshop/v2  
- opus_ELRA-W0133/v1  
- opus_QED/v2.0a  
- opus_Wikipedia/v1.0  
- opus_TED2020/v1  
- opus_JRC-Acquis/v3.0  
- opus_ELRA-W0308/v1  
- opus_ELRA-W0134/v1  
- opus_DGT/v2019  
- opus_ELRC_2682/v1  
devtest:  
- custom-corpus_/mnt/hrist0/nbogoych/government.bg  
test:  
- custom-corpus_/mnt/hrist0/nbogoych/government.bg  
# monolingual datasets (ex. paracrawl-mono_paracrawl8, commoncrawl_wmt16, news-crawl_news.2020)  
# to be translated by the teacher model  
mono-src:  
- news-crawl_news.2020  
- news-crawl_news.2019  
# to be translated by the shallow backward model to augment teacher corpus with back-translations  
# leave empty to skip augmentation step (high resource languages)  
mono-trg:  
- news-crawl_news.2020  
- news-crawl_news.2019  
- news-crawl_news.2018  
- news-crawl_news.2017  
- news-crawl_news.2016  
- news-crawl_news.2015  
- news-crawl_news.2014  
- news-crawl_news.2013
```
