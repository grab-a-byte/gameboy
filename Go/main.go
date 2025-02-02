package main

import (
	"fmt"
	"io"
	"os"
	"path"

	"github.com/grab-a-byte/gameboy/cartridge"
)

func main() {
	dir, err := os.Getwd()
	if err != nil {
		panic("Unable to determin current directory")
	}

	var x int = 0x0104
	fmt.Printf("%d\n", x)

	p := path.Join(dir, "example", "example.gb")

	file, err := os.Open(p)
	if err != nil {
		panic(fmt.Sprintf("Unable to open file %s: %q", p, err))
	}

	data, _ := io.ReadAll(file)
	fmt.Println(len(data))
	c := cartridge.New(data)
	fmt.Println(c.License())
}
