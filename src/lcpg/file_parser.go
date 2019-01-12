package lcpg

import (
	"strings"
	"common"
	"bytes"
	"fmt"
)

type FileParser struct {
	// 文件切割后生成的文本行
	lines []string
	// 结果
	grammarContent *GrammarContent
}

func (fp *FileParser) ParseFile(fileContent string) (*GrammarContent, error) {
	fp.lines = strings.Split(fileContent, "\n")
	fp.grammarContent = &GrammarContent{
		Rules: []*Rule{},
		TerminalTokens: []string{},
		NoTerminalTokens: []string{},
		Firsts: map[string][]string{},
		EmptyToken: "EMPTY",
		EOFToken: "EOF",
		FixPoints: []string{},
		Name: "Unknown",
		HeaderCodes: "",
	}

	// 处理GRAMMAR段
	fp.handleGrammarSection()

	// 处理HEADER段
	fp.handleHeaderSection()

	// 处理METADATA段
	fp.handleMetadataSection()

	// 处理元数据，例如生成FIRST集合等
	fp.parse()

	// Dump
	fp.dump()

	return fp.grammarContent, nil
}

func (fp *FileParser) dump() {
	common.Debug(fmt.Sprintf("EMPTY TOKEN: %s   EOF TOKEN: %s", fp.grammarContent.EmptyToken, fp.grammarContent.EOFToken))

	for _, rule := range fp.grammarContent.Rules {
		common.Debug(fmt.Sprintf("Left Token: %s    Right Tokens: %v", rule.Projection.LeftToken, rule.Projection.RightTokens))
		common.Debug(rule.ReduceFuncTxt)
	}

	common.Debug(fmt.Sprintf("NT: %v\nT: %v", fp.grammarContent.NoTerminalTokens, fp.grammarContent.TerminalTokens))

	common.Debug("\nFirsts:")
	for k := range fp.grammarContent.Firsts {
		common.Debug(fmt.Sprintf("%s: %v", k, fp.grammarContent.Firsts[k]))
	}

	common.Debug("\nFixPoints:")
	common.Debug(fmt.Sprintf("%v", fp.grammarContent.FixPoints))

	common.Debug("\n")
}

func (fp *FileParser) parse() {
	fp.genTAndNT()
	fp.genFirsts()
}

func (fp *FileParser) handleHeaderSection() {
	inHeaderSection := false
	for _, l := range fp.lines {
		line := strings.Trim(l, " ")

		if strings.Contains(line, "HEADER-BEGIN") && string(line[0]) == "/" && string(line[1]) == "*" {
			inHeaderSection = true
			continue
		}

		if strings.Contains(line, "HEADER-END") && string(line[0]) == "/" && string(line[1]) == "*" {
			inHeaderSection = false
			break
		}

		if inHeaderSection == false {
			continue
		}

		if line == "" {
			continue
		}

		fp.grammarContent.HeaderCodes += line
		fp.grammarContent.HeaderCodes += "\n"
	}
}

func (fp *FileParser) genFirsts() {
	// Terminal Token / EOF / EMPTY
	for _, token := range fp.grammarContent.TerminalTokens {
		fp.grammarContent.Firsts[token] = []string{token}
	}
	fp.grammarContent.Firsts[fp.grammarContent.EmptyToken] = []string{fp.grammarContent.EmptyToken}
	fp.grammarContent.Firsts[fp.grammarContent.EOFToken] = []string{fp.grammarContent.EOFToken}

	// NoTerminal Token
	// 创建默认的空集合
	for _, nt := range fp.grammarContent.NoTerminalTokens {
		fp.grammarContent.Firsts[nt] = []string{}
	}

	hasNew := true
	for {
		if hasNew == false {
			break
		}
		hasNew = false

		for _, rule := range fp.grammarContent.Rules {
			nt := rule.Projection.LeftToken
			// 从左往右查看RightTokens
			for _, rightToken := range rule.Projection.RightTokens {
				// 获取rightToken的First集合
				rightTokenFirsts := fp.grammarContent.Firsts[rightToken]

				for _, rightTokenFirst := range rightTokenFirsts {
					if rightTokenFirst == fp.grammarContent.EmptyToken {
						continue
					}

					if common.StringInSlice(rightTokenFirst, fp.grammarContent.Firsts[nt]) == false {
						hasNew = true
						fp.grammarContent.Firsts[nt] = append(fp.grammarContent.Firsts[nt], rightTokenFirst)
					}
				}

				// 判断是否存在EMPTY，如果不存在则不用继续
				if common.StringInSlice(fp.grammarContent.EmptyToken, rightTokenFirsts) == false {
					break
				} else {
					// 判断是否为最后一个rightToken，如果是的话把EMPTY增加到First中
					if rightToken == rule.Projection.RightTokens[len(rule.Projection.RightTokens)-1] {
						if common.StringInSlice(fp.grammarContent.EmptyToken, fp.grammarContent.Firsts[nt]) == false {
							hasNew = true
							fp.grammarContent.Firsts[nt] = append(fp.grammarContent.Firsts[nt], fp.grammarContent.EmptyToken)
						}
					}
				}
			}
		}

	}

}

func (fp *FileParser) genTAndNT() {
	// 获取NT
	for _, rule := range fp.grammarContent.Rules {
		if common.StringInSlice(rule.Projection.LeftToken, fp.grammarContent.NoTerminalTokens) == false {
			fp.grammarContent.NoTerminalTokens = append(fp.grammarContent.NoTerminalTokens, rule.Projection.LeftToken)
		}
	}

	// 获取T
	for  _, rule := range fp.grammarContent.Rules {
		for _, token := range rule.Projection.RightTokens {
			if common.StringInSlice(token, fp.grammarContent.NoTerminalTokens) == false && common.StringInSlice(token, fp.grammarContent.TerminalTokens) == false {
				fp.grammarContent.TerminalTokens = append(fp.grammarContent.TerminalTokens, token)
			}
		}
	}
}

func (fp *FileParser) handleMetadataSection() {
	inMetadataSection := false
	for _, l := range fp.lines {
		line := strings.Trim(l, " ")

		if strings.Contains(line, "METADATA-BEGIN") && string(line[0]) == "/" && string(line[1]) == "*" {
			inMetadataSection = true
			continue
		}

		if strings.Contains(line, "METADATA-END") && string(line[0]) == "/" && string(line[1]) == "*" {
			inMetadataSection = false
			break
		}

		if inMetadataSection == false {
			continue
		}

		if line == "" {
			continue
		}

		lineParts := strings.Split(line, " ")

		switch lineParts[1] {
		case "empty_token":
			fp.grammarContent.EmptyToken = lineParts[3]
		case "eof_token":
			fp.grammarContent.EOFToken = lineParts[3]
		case "name":
			fp.grammarContent.Name = lineParts[3]
		case "fix_point":
			fp.grammarContent.FixPoints = append(fp.grammarContent.FixPoints, lineParts[3])
		}
	}
}

func (fp *FileParser) handleGrammarSection() {
	inGrammarSection := false
	inReduceFunc := false
	var currentRule *Rule = nil
	var ruleProjectionContent bytes.Buffer = bytes.Buffer{}
	for _, l := range fp.lines {
		line := l
		// 判断是否进入GRAMMAR段
		if strings.Contains(line, "GRAMMAR-BEGIN") && string(line[0]) == "/" && string(line[1]) == "*" {
			inGrammarSection = true
			continue
		}
		if strings.Contains(line, "GRAMMAR-END") && string(line[0]) == "/" && string(line[1]) == "*" {
			inGrammarSection = false
			break
		}

		if inGrammarSection == false {
			continue
		}

		// 如果当前不处于ReduceFunc中则可以忽略空白行
		if inReduceFunc == false && line == "" {
			continue
		}

		// 如果当前不处于ReduceFunc中并且此行的长度小于2则必然存在语法问题
		if inReduceFunc == false && len(line) < 2 {
			common.ErrorP("GRAMMAR段语法异常")
		}

		// 下面分两种情况处理: 当前处于ReduceFunc和当前不处于ReduceFunc
		if inReduceFunc {
			// 此时currentRule不应该为空
			if currentRule == nil {
				common.ErrorP("currentRule不应该为nil")
			}
			// 直接附加数据即可
			ruleProjectionContent.WriteString(line)
			ruleProjectionContent.WriteString("\n")

			// 判断reduceFunc是否结束
			lineParts := strings.Split(line, " ")
			if lineParts[0] == "}" {
				inReduceFunc = false
			}
		} else {
			// 此时读到的这一行应该是project或者是reduceFunc的开头
			if string(line[0]) == "/" && string(line[1]) == "/" {
				// 如果currentRule不为nil则添加
				if currentRule != nil {
					currentRule.ReduceFuncTxt = ruleProjectionContent.String()
					fp.grammarContent.Rules = append(fp.grammarContent.Rules, currentRule)
				}

				ruleProjectionContent = bytes.Buffer{}
				currentRule = &Rule{Projection: &RuleProjection{RightTokens: []string{},},}

				inReduceFunc = false
				// 处理PROJECTION
				inRightPart := false
				projectionLineParts := strings.Split(line, " ")
				for idx, projectLinePart := range projectionLineParts {
					projectLinePart = strings.Trim(projectLinePart, " ")
					if projectLinePart == "" {
						continue
					}
					if projectLinePart == "//" && idx == 0 {
						continue
					}
					if projectLinePart == "->" {
						inRightPart = true
						continue
					}
					if inRightPart == false {
						currentRule.Projection.LeftToken = projectLinePart
						continue
					} else {
						currentRule.Projection.RightTokens = append(currentRule.Projection.RightTokens, projectLinePart)
						continue
					}
				}

			} else if strings.Contains(line, "func") {
				inReduceFunc = true
				ruleProjectionContent.WriteString(line)
				ruleProjectionContent.WriteString("\n")
			}
		}
	}
	// 最后一个grammar
	if currentRule != nil {
		currentRule.ReduceFuncTxt = ruleProjectionContent.String()
		fp.grammarContent.Rules = append(fp.grammarContent.Rules, currentRule)
	}

}