#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import re
import argparse

from utils import CHARS, add_filter_args
from tokenizer import build_tokenizer

def main():
    args = parse_user_args()

    clean_mono = build_cleaner(args)
    for i, line in enumerate(sys.stdin):
        src = line.strip()
        if not src:
            continue

        skip = clean_mono(src)
        if skip:
            if args.debug:
                sys.stderr.write("{}\t{}\n".format(skip, src))
            continue
        sys.stdout.write("{}\n".format(src))


def build_cleaner(args):
    tokenizer = build_tokenizer(args)
    def clean_mono(src):
        src_toks = tokenizer['src'](src)
        src_len = len(src_toks)

        if not src_len:
            return "EMPTY"

        if src_len < args.min_length:
            return "TOO_SHORT"

        if src_len > args.max_length:
            return "TOO_LONG"

        num_alpha = sum(
            [1 if re.match(CHARS[args.lang], t, re.IGNORECASE) else 0 for t in src_toks])
        if num_alpha / float(src_len) < args.ratio_alpha_words:
            return "RATIO_ALPHA"

        char_alpha = len(re.findall(CHARS[lang], src, re.IGNORECASE))
        if char_alpha / float(len(src.replace(' ', ''))) < args.ratio_alpha_chars:
            return "RATIO_CHARS"

        return None
    return clean_mono


def parse_user_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-l", "--lang", default='en')
    parser.add_argument("--debug", action='store_true')
    add_filter_args(parser)
    return parser.parse_args()


if __name__ == "__main__":
    main()
