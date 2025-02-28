package main

import "fmt"

func main() {
	value := 0b11000000
	maxValue := 0b11111111
	prefix := "0x"
	for i := value; i <= maxValue; i++ {
		fmt.Printf("%s%02x,", prefix, i)
		if i%10 == 0 {
			fmt.Println()
		}
	}
}
