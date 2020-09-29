from sentencepiece import SentencePieceProcessor
import os


class SimpleTokenizer:
    def __call__(self, sentence):
        return sentence.split()

    def detokenize(self, sentence):
        return sentence


class SentencePieceTokenizer:
    def __init__(self, prefix):
        self.model_path = '{}.model'.format(prefix)
        self.vocab_path = '{}.vocab'.format(prefix)
        self._model = SentencePieceProcessor()
        self._model.Load(self.model_path)
        self.vocab = self.build_vocabulary(self.vocab_path)

    def __call__(self, sentence):
        tokens = self._model.EncodeAsPieces(sentence)
        def clean(x): return x in self.vocab
        tokens = list(filter(clean, tokens))
        return tokens

    def build_vocabulary(self, vocab_path):
        vocab = set()
        with open(vocab_path) as fp:
            for line in fp:
                word, *_ = line.strip().split('\t')
                vocab.add(word)
        return vocab
    
    def detokenize(self, tokenized_entry):
        SPM_SYMBOL = '▁'
        tokenized_entry = tokenized_entry.replace(' ', '')
        tokenized_entry = tokenized_entry.replace(SPM_SYMBOL, ' ')
        if not tokenized_entry:
            return ''
        if tokenized_entry[0] == ' ':
            tokenized_entry = tokenized_entry[1:]
        return tokenized_entry



def build_tokenizer(args):
    if args.use_sentencepiece:
        assert(args.src_sentencepiece_prefix is not None)
        tokenizer = {
            'src': SentencePieceTokenizer(args.src_sentencepiece_prefix),
            'tgt': None if args.tgt_sentencepiece_prefix is None else SentencePieceTokenizer(args.tgt_sentencepiece_prefix)
        }
        return tokenizer
    else:
        return {
            'src': SimpleTokenizer(),
            'tgt': SimpleTokenizer()
        }
