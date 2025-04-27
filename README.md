# NAME

ppap -- A helper tool for creating password-protected ZIP files.

# SYNOPSIS

ppap \[target file\]

# DESCRIPTION

PPAP Helper is a tool designed to assist with the Japanese business practice of sending attachments securely.

In the Japanese business context, it is customary to:

- Store the target file in a password-protected ZIP file before attaching it to an email.
- Send the password for the ZIP file in a separate email.

When provided with a target file, the PPAP Helper creates:

- A password-protected ZIP file containing the target file.
- A text file in the same folder containing the password used for the ZIP file.

# EXAMPLES

## Input

ppap ImportantBusinessDocument.xlsx

## Output

The following files are created in the same folder as the input file:

- ImportantBusinessDocument.zip
  - Contains the password-protected version of the input file.
- ImportantBusinessDocument-password.txt
  - Contains the password used for the ZIP file.

# SEE ALSO

zip(1), unzip(1)

For more information, see: [PPAP -- Wikipedia(ja)](https://ja.wikipedia.org/wiki/PPAP_(%E3%82%BB%E3%82%AD%E3%83%A5%E3%83%AA%E3%83%86%E3%82%A3))
