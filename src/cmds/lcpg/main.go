package main

import (
	"os"

	"lcpg"
	"common"
)

func main() {
	if len(os.Args) != 2 {
		common.Warn("Usage: lcpg [xxxgrammar.g]")
		os.Exit(1)
	}

	grammarFile := os.Args[1]
	common.Debug("working on grammar file: " + grammarFile)

	grammarContent := common.ReadFile(grammarFile)
	pg := lcpg.NewPG(grammarContent)
	pg.Run()
}