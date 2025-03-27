# Gameboy ROM Dissassembler

This repository has 2 implementations of a gaeboy dissassembler. One in Zig, and on in GoLang. The reason for this is that I wanted to compare the 2 languages and see their benefits and disadvantages accordingly.

## Layout
Each repository follows the standard layout of each languag while also keeping them to be as close to each other as possible. The files are as follows.
- main.go / main.zig
    - This file serves as the main entrypoint of the program, it reads in the bytes from the example file (not provided in the repository), passes it to the dissassembling function and then prints the results out to a file.
    - These files are as close as they can be to each other with no functionality being elsewhere. 
    
- cartridge.go / cartridge.zig
    - This file is here to serve as the main entrypoint to dissassembly. It contains a function that will take a list of bytes and read the instructions accordingly and parse out details such as the rom size, ROM title, Manufacturer Code etc.
    - Differences here is that the go code splits into different files for some of the maps and constants while the zig keeps it all in 1 file (the folder being the module boundry in go while the module boundry in zig appears to be the file)

- opcodes.go / opcodes.zig
    - This file is here to parse and dissassemble a slice of bytes into an instruction as a string and a integer with how long the insruction is.
    - The main differences here are that the Zig code returns a struct to be able to return multiple values while Go allows returning multiple values as part of the language.


## Comparisons

### Binary File Sizes
| Language | Bytes      | Mb  |
| Go       | 2,409,472  | 2.4 |
| Zig      | 814,776    | 0.8 |

Go does have further optimizations you can do such as stripping out debug symbols however this only took the binary size down to 1.6Mb (using flags -s -w)

### Timings
| Language | Total Time | CPU %age |
| Go       | 0.228s     | 20       |
| Zig      | 0.180s     | 94       |

#### Raw time command outputs (aligned)

- GoLang : ./gogb   0.04s user 0.01s system 20% cpu 0.228 total
- Zig    : ./ziggb  0.06s user 0.11s system 94% cpu 0.180 total
