#!/usr/bin/env python3

import atheris
import sys

with atheris.instrument_imports():
    import cb85
    import base64

def test_single_input(data):
    encoded = cb85.b85encode(data, pad=True)
    if encoded != base64.b85encode(data, pad=True):
        raise RuntimeError(f'encode difference for padded input -- {data}')

    if cb85.b85decode(encoded) != base64.b85decode(encoded):
        raise RuntimeError(f'decode difference for padded input -- {encoded}')

    encoded = cb85.b85encode(data, pad=False)
    if encoded != base64.b85encode(data, pad=False):
        raise RuntimeError(f'encode difference for unpadded input -- {data}')

    if cb85.b85decode(encoded) != base64.b85decode(encoded):
        raise RuntimeError(f'decode difference for unpadded input -- {encoded}')

atheris.Setup(sys.argv, test_single_input)
atheris.Fuzz()
