# utagedec
A simple decryptor for utage encrypted files (.utage)

### Usage
`utagedec <input_file>|<input_dir> [<output_dir>] [-k <decryption_key>]`

- Utagedec supports either a single file or a whole folder as input. In folder mode only files with one of 3 the allowed extensions is processed. Subdirectories are ++ignored++.
- The encryption/decryption key is needed to extract any file. Automatic detection is not supported yet. (I don't have enough sample games to test.) If no key is provided the engine's standard key is used to decrypt the files - this may or may not work for your game.

### Technical details

UTAGE encrypts assets using a modified XOR algorithm: if the input byte is either zero or the same as the next byte of the key, it is not touched (to prevent leaking the key in files with sequences of zero bytes). Otherwise, the byte is XOR-ed.
There are also functions to compress assets before encrypting and the possibility to overwrite the encryption code with a custom algorithm. Both are currently not supported by utagedec.

### Limitations

- UTAGE also supports compression of asset files, utagedec doesn't at the moment. So if the output is not useful, it may have been compressed (or the decryption key was wrong).
- The decryption key cannot be determined automatically yet.
- Games made with UTAGE can use a custom encryption algorithm. This may be different for each game, and is also not supported by utagedec.
- If you found a game, which is not supported, feel free to open an issue and send me a sample file.

### Remarks
This is the result of analysing the file type itself, no reverse engineering has been used to write this tool.

I released it as a helper for artists to search games for unlicensed use of their assets. It is not meant to encourage extraction with the sole purpose of using assets in your own products without permission of the copyright holder.

Remember: don't steal assets from other people's games. Respect copyrights. And don't protect your own games - it's unnecessary effort.
