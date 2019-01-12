package lcpg

type RuleProjection struct {
	LeftToken string
	RightTokens []string
}


type Rule struct {
	Projection *RuleProjection
	ReduceFuncTxt string
}

type GrammarContent struct {
	Rules []*Rule
	TerminalTokens []string
	NoTerminalTokens []string
	Firsts map[string][]string

	EmptyToken string
	EOFToken string

	// Header代码
	HeaderCodes string

	// 修复点
	FixPoints []string

	// 名称
	Name string

}

type LL0Item struct {
	Rule *Rule
	Project *RuleProjection

	LeftToken string
	RightTokens []string
	CurPos int64

	Ends []string
}

type LL0Node struct {
	LL0Items []*LL0Item
	Id int64
	Parsed bool
}

type LALR1Item struct {
	Rule *Rule
	Project *RuleProjection

	LeftToken string
	RightTokens []string
	CurPos int64

	End string
}

type LALR1Node struct {
	LALR1Items []*LALR1Item
	Id int64
}
