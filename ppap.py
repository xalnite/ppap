#!/usr/bin/python3
# -*- coding: utf-8 -*-
import os
import random
import secrets
import string
import sys

import pyminizip

FILENAME_MAX_SUFFIX = 100
COMPRESS_LEVEL = 9
PASSWORD_MAX_LENGTH = 64
all_chars = string.ascii_letters + string.digits + string.punctuation
PASSWORD_UNSAFE_CHARS = set(" \"'\\/:;*?<>|")
PASSWORD_CHARSET = "".join(c for c in all_chars if c not in PASSWORD_UNSAFE_CHARS)
MESSAGE_TEMPLATE = "generated password is {}"

def create_text_file(text: str, content: str) -> None:
    # Create a text file with the specified content
    with open(text, "w", encoding="utf-8") as file:
        file.write(content)

def encrypt_file(zip: str, password: str, contents: list[str]) -> None:
    # Encrypt a file with a password
    pyminizip.compress(
        contents[0].encode("cp932"), "", zip.encode("cp932"), password, COMPRESS_LEVEL
    )

def generate_password(length: int) -> str:
    # Generate a password of a given length
    if length > PASSWORD_MAX_LENGTH or length < 1:
        length = PASSWORD_MAX_LENGTH
    return "".join(
        secrets.choice(PASSWORD_CHARSET) for i in range(length)
    )

def main(contents: list[str]) -> None:
    # Main function to handle file encryption and password generation
    top: str = contents[0]
    (root, _) = os.path.splitext(top)
    zip: str = root + ".zip"
    txt: str = root + "-password.txt"
    for n in range(FILENAME_MAX_SUFFIX):
        if not os.path.exists(zip) and not os.path.exists(txt):
            break
        zip = f"{root}-{n}.zip"
        txt = f"{root}-{n}-password.txt"
    password: str = generate_password(random.randint(PASSWORD_MAX_LENGTH * 3 // 4, PASSWORD_MAX_LENGTH))
    encrypt_file(zip, password, contents)
    create_text_file(txt, MESSAGE_TEMPLATE.format(password))


if __name__ == "__main__":
    main(sys.argv[1:])
