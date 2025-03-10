# Zig Positives
- Zig did a better job at masking (by hifting and truncating, no errors in binary mask)
- Zig did a better job of guarnteeing all instructions were handles (told me a defautl case was not allowed when all parts had been added)
- Zigs error system is miles better as it is built in to the type system (with unions)

# Go Positives
- If i had gone and fully implemented unit tests, go would have been better as Zig does not have a "run all in this project" for tests.
- Not having to deal with errors for "string interpolation" made the go one significantly less lines of code.
- Go's tooling was much better (zig needed lots of research but was mostly copy paste after that)
- Building a release executable was fast


# Zig Negatives
- Building takes much longer that Go
- Tooling really does not help with discoverability

# Go Negatives
- No exhativeness checking
- Harder to catch silly mistakes in bit masking (had several where did not have enough 0's and was masking over 7 bits)
- Needing runime built alongside makes binaries larger by default

- Go binary file size = 2,409,472 bytes == 2.4Mb, (giving flags -s -w to strip debug symbols, 1,608,192 == 1.6Mb)
- Zig binary size = 814,776 == 0.8Mb
