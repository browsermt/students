
CHARS = {
    'cs': r'[a-zÁáČčĎďÉéěÍíŇňÓóŘřŠšŤťÚúůÝýŽž]',
    'en': r'[a-z]',
    'es': r'[a-zÁáÉéÍíÓóÚúñÑ]',
    'et': r'[a-zÕõÄäÖöÜü]',
    'de': r'[a-zÄäÖöÜüß]',
    'pl': r'[a-zĄąĆćĘęŁłŃńÓóŚśŹźŻż]', # https://en.wikipedia.org/wiki/Polish_alphabet#Letters
}


def add_filter_args(parser):
    parser.add_argument('--min-length', type=int, default=2, help="minimum number of words in a sentence")
    parser.add_argument('--max-length', type=int, default=150 help="maximum number of words in a sentence")
    parser.add_arugment('--ratio-alpha-words', type=float, default=0.4, help="minimum fraction of real words in a sentence")
    parser.add_arugment('--ratio-alpha-chars', type=float, default=0.5, help="minimum fraction of alpha characters in a sentence")
    parser.add_argument('--ratio-length', type=float, default=0.5, hel="maximum length difference between source and target sentence")

    # SentencePiece; Should be no-op otherwise
    parser.add_argument('--use-sentencepiece', action='store_true', help='Switch to enable sentencepiece tokenization')
    parser.add_argument('--src-sentencepiece-prefix', type=str, default=None, help="{prefix}.{vocab,model} where SentencePiece vocabulary or model can be found")
    parser.add_argument('--tgt-sentencepiece-prefix', type=str, default=None, help="{prefix}.{vocab,model} where SentencePiece vocabulary or model can be found")




