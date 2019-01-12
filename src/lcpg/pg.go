package lcpg

import (
	"common"
	"fmt"
)

type Output interface {
	Run()
	SetPG(pg *ParserGenerator)
}

type ParserGenerator struct {
	// 原始文件信息
	grammarFileContent string

	// fileParser信息及结果
	fileParser *FileParser
	grammarContent *GrammarContent

	// output
	output Output

	// LALR1和LL0的解析信息
	initToken string
	initProjection *RuleProjection
	initRule *Rule

	LL0NodesMapping map[int64]map[string]int64
	LL0Nodes []*LL0Node

	LALR1NodesMapping map[int64]map[string]int64
	LALR1Node []*LALR1Node

}

func NewPG(s string) *ParserGenerator {
    	pg := &ParserGenerator{
		grammarFileContent: s,
		fileParser: &FileParser{},
		LL0Nodes: []*LL0Node{},
		LL0NodesMapping: map[int64]map[string]int64{},
		LALR1NodesMapping: map[int64]map[string]int64{},
		LALR1Node: []*LALR1Node{},
		// 当前使用swift的后端
		output: &SwiftOutput{},
	}
	pg.output.SetPG(pg)
	gc, err := pg.fileParser.ParseFile(pg.grammarFileContent)
	if err != nil {
		common.ErrorP(err.Error())
	}
	pg.grammarContent = gc
	return pg
}

func (pg *ParserGenerator) parse() {
	// 分析基本信息
	pg.basicParse()

	// 生成LL0
	pg.getLL0()

	// 生成LALR1
	pg.getLALR1()

	//输出基本信息
	pg.dump()

}

func (pg *ParserGenerator) getLL0NodeById(id int64) *LL0Node {
	for _, node := range pg.LL0Nodes {
		if node.Id == id {
			return node
		}
	}
	return nil
}

func (pg *ParserGenerator) getLALR1ItemByEnd(node *LALR1Node, end string) *LALR1Item {
	for _, item := range node.LALR1Items {
		if item.CurPos == int64(len(item.RightTokens)) && item.End == end {
			return item
		}
	}
	return nil
}

func (pg *ParserGenerator) getLALR1NodeShiftTokens(node *LALR1Node) []string {
	tokens := []string{}
	for _, item := range node.LALR1Items {
		if int64(len(item.RightTokens)) > item.CurPos {
			token := item.RightTokens[item.CurPos]
			if common.StringInSlice(token, tokens) == false {
				tokens = append(tokens, token)
			}
		}
	}
	return tokens
}

func (pg *ParserGenerator) getLALR1NodeReduceTokens(node *LALR1Node) []string {
	tokens := []string{}
	for _, item := range node.LALR1Items {
		if item.CurPos >= int64(len(item.RightTokens)) {
			if common.StringInSlice(item.End, tokens) {
				common.ErrorP(fmt.Sprintf("RR冲突， %d 的LALR1节点含有至少两个相同的可以reduce的item，并且reduce的end token相同，都为 %s", node.Id, item.End))
			}
			tokens = append(tokens, item.End)
		}
	}
	return tokens
}

func (pg *ParserGenerator) genEnds(args []string) []string {
	ends := []string{}

	lastArg := args[0]
	for _, arg := range args {
		lastArg = arg
		firsts := pg.grammarContent.Firsts[arg]
		for _, first := range firsts {
			if common.StringInSlice(first, ends) == false && first != pg.grammarContent.EmptyToken {
				ends = append(ends, first)
			}
		}
		if common.StringInSlice(pg.grammarContent.EmptyToken, firsts) == false {
			break
		}
	}
	if common.StringInSlice(pg.grammarContent.EmptyToken, pg.grammarContent.Firsts[lastArg]) {
		ends = append(ends, pg.grammarContent.EmptyToken)
	}
	return ends
}

func (pg *ParserGenerator) addEnds(LL0Node_ *LL0Node, LL0Item_ *LL0Item, ends []string) {
	if common.SliceInclude(LL0Item_.Ends, ends) == true {
		return
	}

	for _, end := range ends {
		if end == pg.grammarContent.EmptyToken {
			common.ErrorP("EMPTY Token In Ends")
		}
		if common.StringInSlice(end, LL0Item_.Ends) == false {
			LL0Item_.Ends = append(LL0Item_.Ends, end)
		}
	}

	if int64(len(LL0Item_.RightTokens)) == LL0Item_.CurPos {
		return
	}

	// 这里nextToken不可能为EMPTY
	nextToken := LL0Item_.RightTokens[LL0Item_.CurPos]
	if nextToken == pg.grammarContent.EmptyToken {
		common.ErrorP("NextToken Is EMPTY")
	}
	if common.StringInSlice(nextToken, pg.grammarContent.TerminalTokens) {
		// next节点
		nextLL0NodeId := pg.LL0NodesMapping[LL0Node_.Id][nextToken]
		nextLL0Node := pg.getLL0NodeById(nextLL0NodeId)
		nextLL0Item := &LL0Item{}
		for _, item := range nextLL0Node.LL0Items {
			if item.LeftToken == LL0Item_.LeftToken && item.CurPos-1 == LL0Item_.CurPos && common.SliceStringEqualStrict(item.RightTokens, LL0Item_.RightTokens) {
				nextLL0Item = item
				break
			}
		}
		pg.addEnds(nextLL0Node, nextLL0Item, LL0Item_.Ends)
	} else {
		// 当前节点
		// 获取ends
		afterTokens := []string{}
		if LL0Item_.CurPos+1 < int64(len(LL0Item_.RightTokens)) {
			for _, afterToken := range LL0Item_.RightTokens[LL0Item_.CurPos+1:len(LL0Item_.RightTokens)] {
				afterTokens = append(afterTokens, afterToken)
			}
		}

		newEnds := []string{}
		if len(afterTokens) > 0 {
			newEnds = pg.genEnds(afterTokens)
		}

		if len(newEnds) == 0 {
			newEnds = LL0Item_.Ends
		}

		if common.StringInSlice(pg.grammarContent.EmptyToken, newEnds) {
			for _, end := range LL0Item_.Ends {
				if common.StringInSlice(end, newEnds) == false {
					newEnds = append(newEnds, end)
				}
			}
		}

		newEnds2 := []string{}
		for _, end := range newEnds {
			if end != pg.grammarContent.EmptyToken {
				newEnds2 = append(newEnds2, end)
			}
		}
		// 在当前节点进行addEnds操作
		directItems := []*LL0Item{}
		for _, item := range LL0Node_.LL0Items {
			if item.LeftToken != nextToken {
				continue
			}
			if item.RightTokens[0] == pg.grammarContent.EmptyToken || item.CurPos == 0 {
				directItems = append(directItems, item)
			}

		}
		for _, directItem := range directItems {
			pg.addEnds(LL0Node_, directItem, newEnds2)
		}


		// next节点
		nextLL0NodeId := pg.LL0NodesMapping[LL0Node_.Id][nextToken]
		nextLL0Node := pg.getLL0NodeById(nextLL0NodeId)
		nextLL0Item := &LL0Item{}
		for _, item := range nextLL0Node.LL0Items {
			if item.LeftToken == LL0Item_.LeftToken && item.CurPos-1 == LL0Item_.CurPos && common.SliceStringEqualStrict(item.RightTokens, LL0Item_.RightTokens) {
				nextLL0Item = item
				break
			}
		}
		pg.addEnds(nextLL0Node, nextLL0Item, LL0Item_.Ends)
	}
}

func (pg *ParserGenerator) getLALR1() {
	// MAPPING是一样的
	pg.LALR1NodesMapping = pg.LL0NodesMapping

	// 获取CC0
	LL0CC0Node := pg.getLL0NodeById(0)
	// 获取CC0中的init item
	initItem := &LL0Item{}
	for _, item := range LL0CC0Node.LL0Items {
		if item.CurPos == 0 && item.LeftToken == pg.initToken && common.SliceStringEqualStrict(item.RightTokens, pg.initProjection.RightTokens) {
			initItem = item
			break
		}
	}

	pg.addEnds(LL0CC0Node, initItem, []string{pg.grammarContent.EOFToken})

	// 转换LL0为LALR1，主要是展开ENDS
	for _, node := range pg.LL0Nodes {
		lalr1Node := &LALR1Node{LALR1Items: []*LALR1Item{}, Id: node.Id, }
		for _, item := range node.LL0Items {
			for _, end := range item.Ends {
				lalr1Item := &LALR1Item{}
				lalr1Item.LeftToken = item.LeftToken
				lalr1Item.CurPos = item.CurPos
				lalr1Item.End = end
				lalr1Item.Project = item.Project
				lalr1Item.Rule = item.Rule
				lalr1Item.RightTokens = item.RightTokens
				lalr1Node.LALR1Items = append(lalr1Node.LALR1Items, lalr1Item)
			}
		}
		pg.LALR1Node = append(pg.LALR1Node, lalr1Node)
	}
}

func (pg *ParserGenerator) dump() {
	common.Debug(fmt.Sprintf("InitToken: %s", pg.initToken))

	common.Debug("\nLL0 Nodes:")

	for _, node := range pg.LL0Nodes {
		common.Debug(fmt.Sprintf("%d", node.Id))
		for _, item := range node.LL0Items {
			rts := ""
			for idx := range item.RightTokens {
				if int64(idx) == item.CurPos {
					rts += "* "
				}
				rts += item.RightTokens[idx]
				rts += " "
			}
			if int64(len(item.RightTokens)) == item.CurPos {
				rts += "* "
			}
			common.Debug(fmt.Sprintf("%s -> %s", item.LeftToken, rts))
		}
		for nextToken := range pg.LL0NodesMapping[node.Id] {
			common.Debug(fmt.Sprintf("%d => %s -> %d", node.Id, nextToken, pg.LL0NodesMapping[node.Id][nextToken]))
		}
		common.Debug("\n")
	}

	common.Debug("\nLALR1 Nodes:")
	for _, node := range pg.LALR1Node {
		common.Debug(fmt.Sprintf("%d", node.Id))
		for _, item := range node.LALR1Items {
			rts := ""
			for idx := range item.RightTokens {
				if int64(idx) == item.CurPos {
					rts += "* "
				}
				rts += item.RightTokens[idx]
				rts += " "
			}
			if int64(len(item.RightTokens)) == item.CurPos {
				rts += "* "
			}
			common.Debug(fmt.Sprintf("%s -> %s [%s]", item.LeftToken, rts, item.End))
		}
		for nextToken := range pg.LALR1NodesMapping[node.Id] {
			common.Debug(fmt.Sprintf("%d => %s -> %d", node.Id, nextToken, pg.LALR1NodesMapping[node.Id][nextToken]))
		}
		common.Debug("\n")
	}
}

func (pg *ParserGenerator) getLL0NodeNextTokens(node *LL0Node) []string {
	nextTokens := []string{}

	for _, item := range node.LL0Items {
		if int64(len(item.RightTokens)) == item.CurPos {
			continue
		}

		nextToken := item.RightTokens[item.CurPos]
		if common.StringInSlice(nextToken, nextTokens) == false {
			nextTokens = append(nextTokens, nextToken)
		}
	}

	return nextTokens
}

func (pg *ParserGenerator) getLL0NodeShiftedByToken(node *LL0Node, shiftToken string) *LL0Node {
	shiftedNode := &LL0Node{LL0Items: []*LL0Item{}, Id: -1, Parsed: false,}

	for _, item := range node.LL0Items {
		if int64(len(item.RightTokens)) == item.CurPos {
			continue
		}

		if item.RightTokens[item.CurPos] == shiftToken {
			newItem := &LL0Item{
				Rule: item.Rule,
				Project: item.Project,
				LeftToken: item.LeftToken,
				RightTokens: item.RightTokens,
				CurPos: item.CurPos+1,
			}
			shiftedNode.LL0Items = append(shiftedNode.LL0Items, newItem)
		}
	}
	return shiftedNode
}

func (pg *ParserGenerator) ifLL0NodeEqual(nodeA *LL0Node, nodeB *LL0Node) bool {
	if len(nodeA.LL0Items) != len(nodeB.LL0Items) {
		return false
	}

	// closure 函数保证一个node中不会存在相同的item
	for _, nodeAItem := range nodeA.LL0Items {
		itemExist := false
		for _, nodeBItem := range nodeB.LL0Items {
			if nodeAItem.CurPos != nodeBItem.CurPos {
				continue
			}
			if nodeAItem.LeftToken != nodeBItem.LeftToken {
				continue
			}
			if common.SliceStringEqual(nodeAItem.RightTokens, nodeBItem.RightTokens) == false {
				continue
			}
			itemExist = true
			break
		}
		if itemExist == false {
			return false
		}
	}
	return true
}

func (pg *ParserGenerator) ifLL0NodeExist(node *LL0Node) (bool, *LL0Node) {
	for _, currentNode := range pg.LL0Nodes {
		if pg.ifLL0NodeEqual(currentNode, node) == true {
			return true, currentNode
		}
	}
	return false, nil
}

func (pg *ParserGenerator) getLL0() {
	// 生成CC0
	var uniqId int64 = 0
	cc0 := pg.closure([]*LL0Item{&LL0Item{
		Rule: pg.initRule,
		Project: pg.initProjection,
		LeftToken: pg.initProjection.LeftToken,
		RightTokens: pg.initProjection.RightTokens,
		CurPos: 0,
		Ends: []string{},
	}})
	cc0.Id = uniqId
	uniqId += 1
	cc0.Parsed = false

	pg.LL0Nodes = append(pg.LL0Nodes, cc0)

	hasNew := true

	for {
		if hasNew == false {
			break
		}
		hasNew = false

		for _, node := range pg.LL0Nodes {
			if node.Parsed {
				continue
			}

			node.Parsed = true
			// 获取此node的shift token，对每个shift token执行一次移动操作然后执行closure，接着判断新生成的node是否已经存在，若不存在则加入
			nextTokens := pg.getLL0NodeNextTokens(node)
			for _, nextToken := range nextTokens {
				// 获取当前node shift nextTokne或得到的新node
				shiftedNode := pg.closure(pg.getLL0NodeShiftedByToken(node, nextToken).LL0Items)
				// 判断新的node是否已经存在，如果不存在则加入
				nodeExist, existedNode := pg.ifLL0NodeExist(shiftedNode)
				if nodeExist == false {
					shiftedNode.Parsed = false
					shiftedNode.Id = uniqId
					uniqId += 1
					hasNew = true
					if _, ok := pg.LL0NodesMapping[node.Id]; ok == false {
						pg.LL0NodesMapping[node.Id] = make(map[string]int64)
					}
					pg.LL0NodesMapping[node.Id][nextToken] = shiftedNode.Id
					pg.LL0Nodes = append(pg.LL0Nodes, shiftedNode)
				} else {
					if _, ok := pg.LL0NodesMapping[node.Id]; ok == false {
						pg.LL0NodesMapping[node.Id] = make(map[string]int64)
					}
					pg.LL0NodesMapping[node.Id][nextToken] = existedNode.Id
				}
			}

			if hasNew {
				// 此时循环不应该继续，因为修改了循环体
				break
			}
		}
	}
}

func (pg *ParserGenerator) getLL0ItemByProjectionLeftToken(leftToken string) []*LL0Item {
	items := []*LL0Item{}

	for _, rule := range pg.grammarContent.Rules {
		if rule.Projection.LeftToken == leftToken {
			item := &LL0Item{RightTokens: []string{}, Ends: []string{},}

			item.LeftToken = leftToken
			item.RightTokens = rule.Projection.RightTokens
			item.CurPos = 0
			item.Project = rule.Projection
			item.Rule = rule

			items = append(items, item)
		}
	}

	return items
}

func (pg *ParserGenerator) LL0ItemEqual(item0 *LL0Item, item1 *LL0Item) bool {
	if item0.LeftToken != item1.LeftToken {
		return false
	}

	if item0.CurPos != item1.CurPos {
		return false
	}

	if common.SliceStringEqualStrict(item0.RightTokens, item1.RightTokens) == false {
		return false
	}

	return true
}

func (pg *ParserGenerator) LL0NodeHasItem(node *LL0Node, item *LL0Item) bool {
	for _, nodeItem := range node.LL0Items {
		if pg.LL0ItemEqual(nodeItem, item) == true {
			return true
		}
	}
	return false
}

func (pg *ParserGenerator) LL0ItemExist(items []*LL0Item, item *LL0Item) bool {
	for _, nodeItem := range items {
		if pg.LL0ItemEqual(nodeItem, item) == true {
			return true
		}
	}
	return false
}

func (pg *ParserGenerator) closure(items []*LL0Item) *LL0Node {
	node := &LL0Node{LL0Items: []*LL0Item{}, Id: -1, Parsed: false}
	node.LL0Items = items
	hasNewItem := true
	for {
		if hasNewItem == false {
			break
		}
		hasNewItem = false

		tmpItems := []*LL0Item{}
		for _, nodeItem := range node.LL0Items {
			if pg.LL0ItemExist(tmpItems, nodeItem) == false {
				tmpItems = append(tmpItems, nodeItem)
			}

			if int64(len(nodeItem.RightTokens)) == nodeItem.CurPos {
				continue
			}

			nextToken := nodeItem.RightTokens[nodeItem.CurPos]

			if common.StringInSlice(nextToken, pg.grammarContent.TerminalTokens) {
				continue
			}

			// 找到nextToken开始的Project并生成item加入到node中
			closureItems := pg.getLL0ItemByProjectionLeftToken(nextToken)
			for _, closureItem := range closureItems {
				if pg.LL0ItemExist(tmpItems, closureItem) == false {
					tmpItems = append(tmpItems, closureItem)
				}
			}
		}

		if len(tmpItems) != len(node.LL0Items) {
			hasNewItem = true
		}

		node.LL0Items = tmpItems
		tmpItems = []*LL0Item{}
	}

	for _, item := range node.LL0Items {
		if len(item.RightTokens) == 1 && item.CurPos == 0 && item.RightTokens[0] == pg.grammarContent.EmptyToken {
			item.CurPos = 1
		}
	}

	return node
}

func (pg *ParserGenerator) basicParse() {
	// 获取initToken
	for _, nt := range pg.grammarContent.NoTerminalTokens {
		isInitToken := true
		// 如果这个nt不在任何的project的rightTokens中，则这个nt为initToken
		for _, rule := range pg.grammarContent.Rules {
			for _, rightToken := range rule.Projection.RightTokens {
				if nt == rightToken {
					isInitToken = false
					break
				}
			}
			if isInitToken == false {
				break
			}
		}
		if isInitToken {
			pg.initToken = nt
			break
		}
	}

	if pg.initToken == "" {
		common.ErrorP("InitToken not found.")
	}

	// 获取initProjection和initRule
	for _, rule := range pg.grammarContent.Rules {
		if rule.Projection.LeftToken == pg.initToken {
			pg.initProjection = rule.Projection
			pg.initRule = rule
		}
	}
}

func (pg *ParserGenerator) genFile() {
	pg.output.Run()
}

func (pg *ParserGenerator) Run() {
	// 处理grammarContent
	pg.parse()

	// 生成文件
	pg.genFile()
}