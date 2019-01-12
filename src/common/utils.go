package common

import (
	"fmt"
	"os"
	"io/ioutil"
	"strings"
	"bytes"
)

func Debug(msg string) {
	//fmt.Printf("[DEBUG] %s\n", msg)
}

func Log(msg string) {
	fmt.Printf("[INFO] %s\n", msg)
}

func Warn(msg string) {
	fmt.Printf("[WARN] %s\n", msg)
}

func Error(msg string) {
	fmt.Printf("[ERROR] %s\n", msg)
}

func ErrorP(msg string) {
	fmt.Printf("[ERROR] %s\n", msg)
	panic(msg)
}

func ReadFile(path string) string {
	Debug("read file: " + path)
	fi, err := os.Open(path)
	if err != nil {
		Error(err.Error())
		panic("读取文件失败")
	}
	defer fi.Close()
	fd, err := ioutil.ReadAll(fi)
	if err != nil {
		Error(err.Error())
		panic("读取文件失败")
	}
	return string(fd)
}

func MergeBlank(s string) string {
	result := bytes.Buffer{}
	chars := strings.Split(s, " ")
	for _, char := range(chars) {
		if char != "" {
			result.WriteString(string(char))
			result.WriteString(" ")
		}
	}
	return strings.Trim(result.String(), " ")
}

func RemoveSingleQuotes(s string) string {
	return strings.Trim(s, "'")
}

func StringInSliceIgnoreCase(s string, ss []string) bool {
	for _, ts := range ss {
		if strings.ToUpper(s) == strings.ToUpper(ts) {
			return true
		}
	}
	return false
}

func StringInSlice(s string, ss []string) bool {
	for _, ts := range ss {
		if s == ts {
			return true
		}
	}
	return false
}

func SliceInclude(b []string, l []string) bool {
	for _, x := range l {
		if StringInSlice(x, b) == false {
			return false
		}
	}
	return true
}

func SliceStringEqualStrict(s1 []string, s2 []string) bool {
	result := true
	if len(s1) != len(s2) {
		result = false
	} else {
		for idx, s1Item := range s1 {
			if s1Item != s2[idx] {
				result = false
				break
			}
		}
	}
	return result
}

func SliceStringEqual(s1 []string, s2 []string) bool {
	result := true
	if len(s1) != len(s2) {
		result = false
	} else {
		// s1中的每个元素都在s2中
		for _, s1Item := range s1 {
			s1Ins2 := false
			for _, s2Item := range s2 {
				if s1Item == s2Item {
					s1Ins2 = true
					break
				}
			}
			if s1Ins2 == false {
				result = false
				break
			}
		}

		if result == true {
			// s2中的每个元素都在s1中
			for _, s2Item := range s2 {
				s2Ins1 := false
				for _, s1Item := range s1 {
					if s2Item == s1Item {
						s2Ins1 = true
						break
					}
				}
				if s2Ins1 == false {
					result = false
					break
				}
			}
		}

	}
	return result
}