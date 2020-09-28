#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import re
import argparse
from utils import CHARS, add_filter_args
from tokenizer import build_tokenizer


# The variables below need to be adjusted for a language pair and dataset.
# To add a new language, define the list of alpha characters in the dict below.


def main():
    args = parse_user_args()
    clean_parallel = build_parallel_cleaner(args)
    for i, line in enumerate(sys.stdin):
        fields = line.strip().split('\t')
        if len(fields) < 2:
            continue

        src = fields[-2].strip()
        trg = fields[-1].strip()

        skip = clean_parallel(src, trg)
        if skip:
            if args.debug:
                sys.stderr.write("{}\t{}".format(skip, line))
            continue
        sys.stdout.write(line)


def build_parallel_cleaner(args):
    tokenizer = build_tokenizer(args)
    def clean_parallel(src, trg):
        if src.lower() == trg.lower():
            return "IDENTICAL"

        src_toks = tokenizer['src'](src)
        trg_toks = tokenizer['tgt'](tgt)
        src_len = len(src_toks)
        trg_len = len(trg_toks)

        if not src_len or not trg_len:
            return "EMPTY"

        ratio_len = src_len / float(trg_len)
        if ratio_len < args.ratio_length or ratio_len > (1. / args.ratio_length):
            return "args.ratio_length"

        if src_len < args.min_length or trg_len < args.min_length:
            return "TOO_SHORT"

        if src_len > args.max_length or trg_len > args.max_length:
            return "TOO_LONG"

        num_alpha = sum(
            [1 if re.match(CHARS[args.src_lang], t, re.IGNORECASE) else 0 for t in src_toks])
        if num_alpha / float(src_len) < args.ratio_alpha_words:
            return "RATIO_ALPHA"

        char_alpha = len(re.findall(CHARS[args.src_lang], src, re.IGNORECASE))
        if char_alpha / float(len(src.replace(' ', ''))) < args.ratio_alpha_chars:
            return "RATIO_CHARS"

        return None
    return clean_parallel


def parse_user_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-l1", "--src-lang", default='es')
    parser.add_argument("-l2", "--trg-lang", default='en')
    parser.add_argument("--debug", action='store_true')
    add_filter_args(parser)
    return parser.parse_args()


if __name__ == "__main__":
    main()
