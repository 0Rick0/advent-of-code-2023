package main

import "testing"

func TestZero(t *testing.T) {
	if val := GetNextValue([]int{0, 0}); val != 0 {
		t.Fatalf("zero should result in zero but was %d", val)
	}
}

func TestTwoTwo(t *testing.T) {
	if val := GetNextValue([]int{2, 2}); val != 2 {
		t.Fatalf("Should be 2 but was %d", val)
	}
}

func TestZeroTwo(t *testing.T) {
	if val := GetNextValue([]int{0, 2, 4}); val != 6 {
		t.Fatalf("Zero Two should be 6, but was %d", val)
	}
}

func TestExample3(t *testing.T) {
	if val := GetNextValue([]int{10, 13, 16, 21, 30, 45}); val != 68 {
		t.Fatalf("Case 3 should be 68, but was %d", val)
	}
}

func TestExample3Previous(t *testing.T) {
	if val := GetPreviousValue([]int{10, 13, 16, 21, 30, 45}); val != 5 {
		t.Fatalf("Case 3 should be 5, but was %d", val)
	}
}
