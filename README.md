# LCPG

lcpg是一个可以生成swift后端的LALR1语法解析器，用户可以基于这个工具在IOS端开发相应的需要用到语法解析的app。

用户在使用此工具前，最好需要对LALR1规则有一定了解。

## 用法

```
➜  lcpg ls
Makefile _vendor  bin      example  pkg      src
➜  lcpg make all
go install cmds/lcpg
➜  lcpg cat example/GrammarExpr.swift 

import Foundation


/* -*- METADATA-BEGIN -*- */

// name = Expr
// empty_token = EMPTY
// eof_token = EOF
// fix_point = Expr

/* -*- METADATA-END -*- */



/* -*- GRAMMAR-BEGIN -*- */

// Program -> Expr
func Program_Expr(datas: [LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    return elementData
} //

// Expr -> ( Expr )
func Expr_LPExprRP(datas: [LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    return elementData
} //

// Expr -> Expr Op name
func Expr_ExprOpName(datas: [LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    return elementData
} //

// Expr -> name
func Expr_Name(datas: [LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    return elementData
} //

// Op -> +
func Op_Plus(datas: [LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    return elementData
} //

// Op -> -
func Op_Minus(datas: [LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    return elementData
} //

// Op -> *
func Op_Mul(datas: [LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    return elementData
} //

// Op -> /
func Op_Div(datas: [LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    return elementData
} //

// Expr -> A B C
func Expr_ABC(datas: [LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    return elementData
} //

// A -> EMPTY
func A_EMPTY(datas: [LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    return elementData
} //

// B -> EMPTY
func B_EMPTY(datas: [LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    return elementData
} //

// A -> a
func A_a(datas: [LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    return elementData
} //

// B -> b
func B_b(datas: [LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    return elementData
} //

// C -> c
func C_c(datas: [LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    return elementData
} //

/* -*- GRAMMAR-END -*- */
➜  lcpg bin/lcpg example/GrammarExpr.swift  
//
//  libcode
//
//  Created by thuanqin
//  Copyright © 2017年 tianhuan. All rights reserved.
//

import Foundation


var LCPGExprCoreInitialised = false
	var LCPGExprCore: [Int: [String: LCPGRSActionInfo]] = [:]
	let LCPGExprGoto: [Int: [String: Int]] = [0: ["Expr": 1,"(": 2,"name": 3,"A": 4,"a": 5,],1: ["+": 7,"-": 8,"*": 9,"/": 10,"Op": 6,],2: ["a": 5,"Expr": 11,"(": 2,"name": 3,"A": 4,],4: ["B": 12,"b": 13,],6: ["name": 14,],11: ["+": 7,"-": 8,"*": 9,"/": 10,")": 15,"Op": 6,],12: ["C": 16,"c": 17,],]
let LCPGExprFixPoints: [String] = ["Expr", ]

class LCPGParserExpr: LCPGParserBase {
	init() {
        if LCPGExprCoreInitialised == false {
LCPGExprCore[0] = ["Expr": LCPGRSActionInfo(action: .shift, nextState: 1), "(": LCPGRSActionInfo(action: .shift, nextState: 2), "name": LCPGRSActionInfo(action: .shift, nextState: 3), "A": LCPGRSActionInfo(action: .shift, nextState: 4), "a": LCPGRSActionInfo(action: .shift, nextState: 5), "b": LCPGRSActionInfo(action: .reduce, count: 0, reduceToken: "A", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"c": LCPGRSActionInfo(action: .reduce, count: 0, reduceToken: "A", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),]
		
LCPGExprCore[1] = ["Op": LCPGRSActionInfo(action: .shift, nextState: 6), "+": LCPGRSActionInfo(action: .shift, nextState: 7), "-": LCPGRSActionInfo(action: .shift, nextState: 8), "*": LCPGRSActionInfo(action: .shift, nextState: 9), "/": LCPGRSActionInfo(action: .shift, nextState: 10), "EOF": LCPGRSActionInfo(action: .accept, count: 1, reduceToken: "Program", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),]
		
LCPGExprCore[2] = ["Expr": LCPGRSActionInfo(action: .shift, nextState: 11), "(": LCPGRSActionInfo(action: .shift, nextState: 2), "name": LCPGRSActionInfo(action: .shift, nextState: 3), "A": LCPGRSActionInfo(action: .shift, nextState: 4), "a": LCPGRSActionInfo(action: .shift, nextState: 5), "b": LCPGRSActionInfo(action: .reduce, count: 0, reduceToken: "A", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"c": LCPGRSActionInfo(action: .reduce, count: 0, reduceToken: "A", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),]
		
LCPGExprCore[3] = [")": LCPGRSActionInfo(action: .reduce, count: 1, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"+": LCPGRSActionInfo(action: .reduce, count: 1, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"-": LCPGRSActionInfo(action: .reduce, count: 1, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"*": LCPGRSActionInfo(action: .reduce, count: 1, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"/": LCPGRSActionInfo(action: .reduce, count: 1, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"EOF": LCPGRSActionInfo(action: .reduce, count: 1, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),]
		
LCPGExprCore[4] = ["B": LCPGRSActionInfo(action: .shift, nextState: 12), "b": LCPGRSActionInfo(action: .shift, nextState: 13), "c": LCPGRSActionInfo(action: .reduce, count: 0, reduceToken: "B", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),]
		
LCPGExprCore[5] = ["b": LCPGRSActionInfo(action: .reduce, count: 1, reduceToken: "A", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"c": LCPGRSActionInfo(action: .reduce, count: 1, reduceToken: "A", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),]
		
LCPGExprCore[6] = ["name": LCPGRSActionInfo(action: .shift, nextState: 14), ]
		
LCPGExprCore[7] = ["name": LCPGRSActionInfo(action: .reduce, count: 1, reduceToken: "Op", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),]
		
LCPGExprCore[8] = ["name": LCPGRSActionInfo(action: .reduce, count: 1, reduceToken: "Op", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),]
		
LCPGExprCore[9] = ["name": LCPGRSActionInfo(action: .reduce, count: 1, reduceToken: "Op", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),]
		
LCPGExprCore[10] = ["name": LCPGRSActionInfo(action: .reduce, count: 1, reduceToken: "Op", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),]
		
LCPGExprCore[11] = [")": LCPGRSActionInfo(action: .shift, nextState: 15), "Op": LCPGRSActionInfo(action: .shift, nextState: 6), "+": LCPGRSActionInfo(action: .shift, nextState: 7), "-": LCPGRSActionInfo(action: .shift, nextState: 8), "*": LCPGRSActionInfo(action: .shift, nextState: 9), "/": LCPGRSActionInfo(action: .shift, nextState: 10), ]
		
LCPGExprCore[12] = ["C": LCPGRSActionInfo(action: .shift, nextState: 16), "c": LCPGRSActionInfo(action: .shift, nextState: 17), ]
		
LCPGExprCore[13] = ["c": LCPGRSActionInfo(action: .reduce, count: 1, reduceToken: "B", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),]
		
LCPGExprCore[14] = [")": LCPGRSActionInfo(action: .reduce, count: 3, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"+": LCPGRSActionInfo(action: .reduce, count: 3, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"-": LCPGRSActionInfo(action: .reduce, count: 3, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"*": LCPGRSActionInfo(action: .reduce, count: 3, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"/": LCPGRSActionInfo(action: .reduce, count: 3, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"EOF": LCPGRSActionInfo(action: .reduce, count: 3, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),]
		
LCPGExprCore[15] = ["EOF": LCPGRSActionInfo(action: .reduce, count: 3, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),")": LCPGRSActionInfo(action: .reduce, count: 3, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"+": LCPGRSActionInfo(action: .reduce, count: 3, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"-": LCPGRSActionInfo(action: .reduce, count: 3, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"*": LCPGRSActionInfo(action: .reduce, count: 3, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"/": LCPGRSActionInfo(action: .reduce, count: 3, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),]
		
LCPGExprCore[16] = [")": LCPGRSActionInfo(action: .reduce, count: 3, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"+": LCPGRSActionInfo(action: .reduce, count: 3, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"-": LCPGRSActionInfo(action: .reduce, count: 3, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"*": LCPGRSActionInfo(action: .reduce, count: 3, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"/": LCPGRSActionInfo(action: .reduce, count: 3, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"EOF": LCPGRSActionInfo(action: .reduce, count: 3, reduceToken: "Expr", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),]
		
LCPGExprCore[17] = [")": LCPGRSActionInfo(action: .reduce, count: 1, reduceToken: "C", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"+": LCPGRSActionInfo(action: .reduce, count: 1, reduceToken: "C", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"-": LCPGRSActionInfo(action: .reduce, count: 1, reduceToken: "C", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"*": LCPGRSActionInfo(action: .reduce, count: 1, reduceToken: "C", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"/": LCPGRSActionInfo(action: .reduce, count: 1, reduceToken: "C", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),"EOF": LCPGRSActionInfo(action: .reduce, count: 1, reduceToken: "C", function: { (datas) -> LCPGElementData in
	    let elementData = LCPGElementData()
    return elementData
}),]
		LCPGExprCoreInitialised = true
        }
        super.init(core: LCPGExprCore, goto: LCPGExprGoto, fixPoints: LCPGExprFixPoints)
}}
```

在生成上面的swift文件后，基于 example/LCPGParser.swift 就可以进行相关的解析工作了。
