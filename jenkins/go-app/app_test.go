package main
import("testing")

func Test_GetNameLen_1(t *testing.T) {
	if l := getNameLen("james"); l != 5 {
		t.Error("test failed, the length of name is not correct.")
	} else {
		t.Log("test passed.")
	}
}

func Test_GetNameLen_2(t *testing.T) {
	if l := getNameLen(""); l != 0 {
		t.Error("test failed, the length of name is not correct.")
	} else {
		t.Log("test passed.")
	}
}