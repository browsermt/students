from sentencepiece import SentencePieceProcessor
import os

class SimpleTokenizer:
    def __call__(self, sentence):
        return sentence.split()

class SentencePieceTokenizer:
    def __init__(self, prefix):
        self.model_path = '{}.model'.format(prefix)
        self.vocab_path = '{}.vocab'.format(prefix)
        self._model = SentencePieceProcessor()
        self._model.load(self.model_path)
        self.vocab  = self.build_vocabulary(self.vocab_path)
    
   def __call__(self, sentence):
        tokens = self.model.EncodeAsPieces(sentence)
        clean = lambda x: x in self.vocab
        tokens = list(filter(clean, tokens))
        return tokens

    def build_vocabulary(self, vocab_path):
        vocab = set()
        with open(vocab_path) as fp:
            for line in fp:
                word, _ = line.strip().split()
                vocab.add(word)
        return vocab


def build_tokenizer(args):
    if args.use_sentencepiece:
        assert(args.src_sentencepiece_prefix is not None)
        tokenizer = {
            'src': SentencePieceTokenizer(args.source_sentencepiece_prefix),
            'tgt': None if args.tgt_sentencepiece_prefix is None else SentencePieceTokenizer(args.tgt_sentencepiece_prefix)
        }
        return tokenizer
    else:
        return {
            'src': SimpleTokenizer(),
            'tgt': SimpleTokenizer()
        }