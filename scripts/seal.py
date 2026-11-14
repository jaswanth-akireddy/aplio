#!/usr/bin/env python3
"""Encrypt a file for the public repo so only the signed-in owner can read it.

Usage: python3 -I scripts/seal.py <key_base64> <in_file> <out_file>
Output format: 12-byte nonce || AES-256-GCM ciphertext+tag (what the dashboard's
WebCrypto decrypt expects). The key lives in Supabase (docs.file_key), never in the repo.
"""
import base64, os, sys
from cryptography.hazmat.primitives.ciphers.aead import AESGCM

def main():
    if len(sys.argv) != 4:
        sys.exit(__doc__)
    key = base64.b64decode(sys.argv[1])
    if len(key) != 32:
        sys.exit("key must be 32 bytes (base64)")
    data = open(sys.argv[2], "rb").read()
    nonce = os.urandom(12)
    out = nonce + AESGCM(key).encrypt(nonce, data, None)
    os.makedirs(os.path.dirname(sys.argv[3]) or ".", exist_ok=True)
    open(sys.argv[3], "wb").write(out)
    # Round-trip check
    assert AESGCM(key).decrypt(out[:12], out[12:], None) == data
    print(f"sealed {len(data)} -> {len(out)} bytes: {sys.argv[3]}")

if __name__ == "__main__":
    main()
