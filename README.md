# NAME

<img src="ppap.png" alt="ppap icon" width="32" align="absmiddle"> ppap -- A helper tool for creating password-protected ZIP files.

# SYNOPSIS

ppap \[-p PASSWORD\] \[-a ARCHIVE\] \[-n\] \[target files...\]

# DESCRIPTION

PPAP Helper is a tool designed to assist with the Japanese business practice of sending attachments securely.

In the Japanese business context, it is customary to:

- Store the target file in a password-protected ZIP file before attaching it to an email.
- Send the password for the ZIP file in a separate email.

When provided with one or more target files, the PPAP Helper creates:

- A password-protected ZIP file containing the target file(s).
- A text file in the same folder containing the password used for the ZIP file.

# OPTIONS

-p PASSWORD
  Specify the password for the ZIP file. If omitted, a password is generated automatically.

-a ARCHIVE
  Specify the name of the ZIP file to create. If omitted, the name is derived from the first target file.

-n
  Create the ZIP file without a password (no encryption). No password file is created in this case.

# USAGE NOTES

Since ppap is distributed as a Windows executable (ppap.exe), you can also create a password-protected ZIP file without using the command line: simply drag and drop one or more target files onto ppap.exe in Explorer.

# EXAMPLES

## Input

ppap ImportantBusinessDocument.xlsx

## Output

The following files are created in the same folder as the input file:

- ImportantBusinessDocument.zip
  - Contains the password-protected version of the input file.
- ImportantBusinessDocument-password.txt
  - Contains the password used for the ZIP file.

## Multiple files

ppap Document1.xlsx Document2.pptx

Creates a single ZIP file (named after `Document1`) containing both files, along with its password file.

## Specifying a password and archive name

ppap -p correct-horse-battery-staple -a Bundle.zip Document1.xlsx Document2.pptx

## Creating an unencrypted ZIP file

ppap -n Document1.xlsx

# SEE ALSO

zip(1), unzip(1)

For more information, see: [PPAP -- Wikipedia(ja)](https://ja.wikipedia.org/wiki/PPAP_(%E3%82%BB%E3%82%AD%E3%83%A5%E3%83%AA%E3%83%86%E3%82%A3))
