package lcpg

import (
	"bytes"
	"fmt"
	"common"
	"strings"
)

type SwiftOutput struct {
	pg *ParserGenerator
	buffer bytes.Buffer
}

func (o *SwiftOutput) SetPG(pg *ParserGenerator) {
	o.pg = pg
}

func (o *SwiftOutput) Run() {
	o.writeHeader()
	o.writeCore()
	o.writeGoto()
	o.writeFixPoints()
	o.writeParser()

	o.dump()
}

func (o *SwiftOutput) writeHeader() {
	o.buffer.WriteString(`//
//  libcode
//
//  Created by thuanqin
//  Copyright © 2017年 tianhuan. All rights reserved.
//

import Foundation

`)

	o.buffer.WriteString(o.pg.grammarContent.HeaderCodes)
	o.buffer.WriteString("\n")
}

func (o *SwiftOutput) writeGoto() {
	o.buffer.WriteString(fmt.Sprintf(`let LCPG%sGoto: [Int: [String: Int]] = [`, o.pg.grammarContent.Name))
	for k, v := range o.pg.LALR1NodesMapping {
		 o.buffer.WriteString(fmt.Sprintf("%d: [", k))
		for k2, v2 := range v {
		    	o.buffer.WriteString(fmt.Sprintf("\"%s\": %d,", k2, v2))
		}
		o.buffer.WriteString("],")
	}
	o.buffer.WriteString("]\n")
}

func (o *SwiftOutput) writeCore() {
	o.buffer.WriteString(fmt.Sprintf(`var LCPG%sCoreInitialised = false
	`, o.pg.grammarContent.Name))
	o.buffer.WriteString(fmt.Sprintf(`var LCPG%sCore: [Int: [String: LCPGRSActionInfo]] = [:]
	`, o.pg.grammarContent.Name))
}

func (o *SwiftOutput) handleReduceFuncTxt(txt string) string {
	codes := bytes.Buffer{}
	originalLines := strings.Split(txt, "\n")
	lines := []string{}
	for _, ol := range originalLines {
		if len(ol) > 0 && ol[0] == '}' {
			break
		}
		lines = append(lines, ol)
	}
	for idx, line := range lines {
		if idx == 0 {
			continue
		}
		codes.WriteString(line)
		codes.WriteString("\n")
	}
	result := codes.String()
	if strings.Trim(strings.Trim(result, " "), "\n") == "" {
		return `return LCPGElementData()`
	} else {
		return result
	}
}

func (o *SwiftOutput) writeFixPoints() {
	o.buffer.WriteString(fmt.Sprintf(`let LCPG%sFixPoints: [String] = [`, o.pg.grammarContent.Name))
	for _, fixPoint := range o.pg.grammarContent.FixPoints {
		o.buffer.WriteString(fmt.Sprintf(`"%s", `, fixPoint))
	}
	o.buffer.WriteString(`]

`)
}

func (o *SwiftOutput) writeParser() {
	o.buffer.WriteString(fmt.Sprintf(`class LCPGParser%s: LCPGParserBase {
	`, o.pg.grammarContent.Name))

	o.buffer.WriteString(fmt.Sprintf(`init() {
        if LCPG%sCoreInitialised == false {`, o.pg.grammarContent.Name))

	for _, node := range o.pg.LALR1Node {
		o.buffer.WriteString(fmt.Sprintf("\nLCPG%sCore[%d] = [", o.pg.grammarContent.Name, node.Id))
		// 获取这个node的shift token
		originalShiftTokens := o.pg.getLALR1NodeShiftTokens(node)

		// 获取这个node的reduce token
		originalReduceTokens := o.pg.getLALR1NodeReduceTokens(node)

		shiftTokens := originalShiftTokens
		reduceTokens := []string{}
		// 判断是否存在RS冲突，如果存在冲突，则将这个token放入shiftTokens中
		for _, token := range originalReduceTokens {
			if common.StringInSlice(token, originalShiftTokens) {
				common.Debug("RS 冲突: " + token)
				if common.StringInSlice(token, shiftTokens) == false {
					shiftTokens = append(shiftTokens, token)
				}
			} else {
				reduceTokens = append(reduceTokens, token)
			}
		}

		// shift
		 for _, st := range shiftTokens {
			 o.buffer.WriteString(fmt.Sprintf(`"%s": LCPGRSActionInfo(action: .shift, nextState: %d), `, st, o.pg.LALR1NodesMapping[node.Id][st]))
		}

		// reduce && accept
		for _, rt := range reduceTokens {
			reduceItem := o.pg.getLALR1ItemByEnd(node, rt)
			// 获取reduce function的参数数目
			tokenToPopLen := 0
			if len(reduceItem.RightTokens) == 1 && reduceItem.RightTokens[0] == "EMPTY" {
				tokenToPopLen = 0
			} else {
				tokenToPopLen = len(reduceItem.RightTokens)
			}

			// 判断是否为accept
			if reduceItem.LeftToken == o.pg.initToken && common.SliceStringEqualStrict(reduceItem.RightTokens, o.pg.initProjection.RightTokens) {
				o.buffer.WriteString(fmt.Sprintf(`"%s": LCPGRSActionInfo(action: .accept, count: %d, reduceToken: "%s", function: { (datas) -> LCPGElementData in
	%s}),`, rt, tokenToPopLen, reduceItem.LeftToken, o.handleReduceFuncTxt(reduceItem.Rule.ReduceFuncTxt)))
			} else {
				o.buffer.WriteString(fmt.Sprintf(`"%s": LCPGRSActionInfo(action: .reduce, count: %d, reduceToken: "%s", function: { (datas) -> LCPGElementData in
	%s}),`, rt, tokenToPopLen, reduceItem.LeftToken, o.handleReduceFuncTxt(reduceItem.Rule.ReduceFuncTxt)))
			}
		}

		o.buffer.WriteString(`]
		`)
	}

	o.buffer.WriteString(fmt.Sprintf(`LCPG%sCoreInitialised = true
        }
        super.init(core: LCPG%sCore, goto: LCPG%sGoto, fixPoints: LCPG%sFixPoints)`, o.pg.grammarContent.Name, o.pg.grammarContent.Name, o.pg.grammarContent.Name, o.pg.grammarContent.Name))

	o.buffer.WriteString(`
}}
	`)
}

func (o *SwiftOutput) dump() {
	fmt.Print(o.buffer.String())
}
