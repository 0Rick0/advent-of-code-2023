package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

func GetNextValue(input []int) int {
	var output []int

	for i := 0; i < len(input)-1; i++ {
		output = append(output, input[i+1]-input[i])
	}
	fmt.Printf("%v\n", output)

	if len(output) == 0 {
		//fmt.Printf("Output empty\n")
		return 0
	}

	for _, i := range output {
		if i != 0 {
			increment := GetNextValue(output)
			result := input[len(input)-1] + increment
			//fmt.Printf("Result: %d\n", result)
			return result
		}
	}
	//fmt.Printf("Zeros: %d\n", input[len(input)-1])
	return input[len(input)-1]
}

func GetPreviousValue(input []int) int {
	var output []int

	for i := 0; i < len(input)-1; i++ {
		output = append(output, input[i+1]-input[i])
	}
	fmt.Printf("%v\n", output)

	if len(output) == 0 {
		//fmt.Printf("Output empty\n")
		return 0
	}

	for _, i := range output {
		if i != 0 {
			increment := GetPreviousValue(output)
			result := input[0] - increment
			//fmt.Printf("Result: %d\n", result)
			return result
		}
	}
	//fmt.Printf("Zeros: %d\n", input[0])
	return input[0]
}

func convertToIntSlice(strings []string) []int {
	var output []int
	for _, s := range strings {
		if val, err := strconv.Atoi(s); err == nil {
			output = append(output, val)
		} else {
			log.Fatal(err)
		}
	}
	return output
}

func main() {
	//values := [][]int{
	//	{0, 3, 6, 9, 12, 15},
	//	{1, 3, 6, 10, 15, 21},
	//	{10, 13, 16, 21, 30, 45},
	//}
	//
	//for _, value := range values {
	//	fmt.Printf("next value: %d\n", GetNextValue(value))
	//}

	f, err := os.Open("input.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)

	totalNext := 0
	totalPrevious := 0

	for scanner.Scan() {
		line := scanner.Text()
		parts := convertToIntSlice(strings.Split(line, " "))
		totalNext += GetNextValue(parts)
		totalPrevious += GetPreviousValue(parts)
	}
	fmt.Printf("Total next is: %d\n", totalNext)
	fmt.Printf("Total previous is: %d\n", totalPrevious)

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
}
