
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

