//
//  GrammarPython2.swift
//  libcode
//
//  Created by thuanqin on 2017/10/29.
//  Copyright © 2017年 tianhuan. All rights reserved.
//

import Foundation


/* -*- METADATA-BEGIN -*- */

// name = Python2
// empty_token = EMPTY
// eof_token = EOF
// fix_point = stmts

/* -*- METADATA-END -*- */

/* -*- HEADER-BEGIN -*- */

class Python2AST_Empty: AST {
    override func getName() -> String {
        return "EMPTY"
    }
}

class Python2AST_Stmts: AST {
    var stmts: [Python2AST_Stmt]
    
    override init() {
        self.stmts = []
    }
    
    override func getName() -> String {
        return "Stmts"
    }
    
    func addStmt(stmt: Python2AST_Stmt) {
        self.stmts.append(stmt)
    }
}

class Python2AST_Exprs: AST {
    
    var exprs: [Python2AST_Expr]
    
    override init() {
        self.exprs = []
    }
    
    override func getName() -> String {
        return "Exprs"
    }
}

class Python2AST_ExprStmtParts: Python2AST_Expr {
    
    var exprStmtParts: Python2AST_Expr!
    var value: Python2AST_Expr
    
    init(value: Python2AST_Expr) {
        self.exprStmtParts = nil
        self.value = value
    }
    
    init(exprStmtParts: Python2AST_Expr, value: Python2AST_Expr) {
        self.exprStmtParts = exprStmtParts
        self.value = value
    }
    
    override func getName() -> String {
        return "ExprStmtParts"
    }
}

func Python2AST_AST_FOR_SUITE(data: LCPGElementData) -> [Python2AST_Stmt] {
    return []
}

func Python2AST_AST_FOR_ARGUMENTS(data: LCPGElementData) -> [Python2AST_Arguments] {
    return []
}

func Python2AST_AST_FOR_TESTS(data: LCPGElementData) -> [Python2AST_Expr] {
    return []
}

func Python2AST_AST_FOR_TESTLIST(data: LCPGElementData) -> Python2AST_Expr {
    return Python2AST_Expr()
}

func Python2AST_AST_FOR_EXPRLIST(data: LCPGElementData) -> [Python2AST_Expr] {
    return []
}

func Python2AST_AST_FOR_DECORATORS(data: LCPGElementData) -> [Python2AST_Expr] {
    return []
}

func Python2AST_AST_FOR_ALIAS(data: LCPGElementData) -> [Python2AST_Alias] {
    return []
}


func Python2AST_AST_FOR_EXPRS(data: LCPGElementData) -> [Python2AST_Expr] {
    return []
}

func Python2AST_AST_FOR_TEST(data: LCPGElementData) -> Python2AST_Expr {
    return Python2AST_Expr()
}

func Python2AST_AST_FOR_EXPR(data: LCPGElementData) -> Python2AST_Expr {
    return Python2AST_Expr()
}

/* -*- HEADER-END -*- */

/* -*- GRAMMAR-BEGIN -*- */

// Program -> file_input
func Program_FileInput(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// file_input -> ENDMARKER
func FileInput_ENDMARKER(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = Python2AST_Module()
    return elementData
}

// file_input -> stmts ENDMARKER
func FileInput_StmtsENDMARKER(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Module()
    
    let stmts = datas[0].ast as! Python2AST_Stmts
    for stmt in stmts.stmts {
        ast.addStmt(stmt: stmt)
    }
    
    elementData.ast = ast
    return elementData
}

// stmts -> NEWLINE
func Stmts_NEWLINE(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = Python2AST_Stmts()
    return elementData
}

// stmts -> stmt
func Stmts_stmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Stmts()
    
    let stmts = datas[0].ast as! Python2AST_Stmts
    for stmt in stmts.stmts {
        ast.addStmt(stmt: stmt)
    }
    
    elementData.ast = ast
    return elementData
}

// stmts -> stmts NEWLINE
func Stmts_StmtsNEWLINE(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// stmts -> stmts stmt
func Stmts_StmtsStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    
    let stmts = datas[0].ast as! Python2AST_Stmts
    let stmts2 = datas[1].ast as! Python2AST_Stmts
    for stmt in stmts2.stmts {
        stmts.addStmt(stmt: stmt)
    }
    
    elementData.ast = stmts
    return elementData
}

// stmt -> simple_stmt
func Stmt_SimpleStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// stmt -> compound_stmt
func Stmt_CompoundStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Stmts()
    ast.addStmt(stmt: datas[0].ast as! Python2AST_Stmt)
    elementData.ast = ast
    return elementData
}

// simple_stmt -> small_stmt small_stmts NEWLINE
func SimpleStmt_SmallStmtSmallStmtsNEWLINE(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Stmts()
    
    ast.addStmt(stmt: datas[0].ast as! Python2AST_Stmt)
    let stmts = datas[1].ast as! Python2AST_Stmts
    for stmt in stmts.stmts {
        ast.addStmt(stmt: stmt)
    }
    
    elementData.ast = ast
    return elementData
}

// simple_stmt -> small_stmt small_stmts ; NEWLINE
func SimpleStmt_SmallStmtSmallStmtsNEWLINE2(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Stmts()
    
    ast.addStmt(stmt: datas[0].ast as! Python2AST_Stmt)
    let stmts = datas[1].ast as! Python2AST_Stmts
    for stmt in stmts.stmts {
        ast.addStmt(stmt: stmt)
    }
    
    elementData.ast = ast
    return elementData
}

// small_stmts -> EMPTY
func SmallStmts_EMPTY(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Stmts()
    elementData.ast = ast
    return elementData
}

// small_stmts -> small_stmts ; small_stmt
func SmallStmts_SmallStmtsSmallStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    
    let ast = datas[0].ast as! Python2AST_Stmts
    let smallStmt = datas[2].ast as! Python2AST_Stmt
    ast.addStmt(stmt: smallStmt)
    
    elementData.ast = ast
    return elementData
}

// small_stmt -> expr_stmt
func SmallStmt_ExprStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// small_stmt -> print_stmt
func SmallStmt_PrintStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// small_stmt -> del_stmt
func SmallStmt_DelStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// small_stmt -> pass_stmt
func SmallStmt_PassStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// small_stmt -> flow_stmt
func SmallStmt_FlowStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// small_stmt -> import_stmt
func SmallStmt_ImportStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// small_stmt -> global_stmt
func SmallStmt_GlobalStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// small_stmt -> exec_stmt
func SmallStmt_ExecStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// small_stmt -> assert_stmt
func SmallStmt_AssertStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// compound_stmt -> if_stmt
func CompoundStmt_IfStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// compound_stmt -> while_stmt
func CompoundStmt_WhileStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// compound_stmt -> for_stmt
func CompoundStmt_ForStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// compound_stmt -> try_stmt
func CompoundStmt_TryStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// compound_stmt -> with_stmt
func CompoundStmt_WithStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// compound_stmt -> funcdef
func CompoundStmt_FuncdefStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// compound_stmt -> classdef
func CompoundStmt_ClassdefStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// compound_stmt -> decorated
func CompoundStmt_DecoratedStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// print_stmt -> print
func PrintStmt_Print(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Print()
    elementData.ast = ast
    return elementData
}

// print_stmt -> print tests test
func PrintStmt_PrintTestsTest(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Print()
    
    var values = Python2AST_AST_FOR_TESTS(data: datas[1])
    let value = Python2AST_AST_FOR_TEST(data: datas[2])
    values.append(value)
    ast.values = values
    
    elementData.ast = ast
    return elementData
}

// print_stmt -> print tests test ,
func PrintStmt_PrintTestsTest2(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Print()
    
    var values = Python2AST_AST_FOR_TESTS(data: datas[1])
    let value = Python2AST_AST_FOR_TEST(data: datas[2])
    values.append(value)
    ast.values = values
    
    elementData.ast = ast
    return elementData
}

// del_stmt -> del exprlist
func DelStmt_DelExprlist(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Delete()
    
    let targets = Python2AST_AST_FOR_EXPRLIST(data: datas[1])
    ast.targets = targets
    
    elementData.ast = ast
    return elementData
}

// pass_stmt -> pass
func PassStmt_Pass(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Pass()
    
    elementData.ast = ast
    return elementData
}

// flow_stmt -> break_stmt
func FlowStmt_BreakStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// flow_stmt -> continue_stmt
func FlowStmt_ContinueStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// flow_stmt -> return_stmt
func FlowStmt_ReturnStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// flow_stmt -> raise_stmt
func FlowStmt_RaiseStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// flow_stmt -> yield_stmt
func FlowStmt_YieldStmt(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// assert_stmt -> assert test
func AssertStmt_AssertTest(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    
    let test = Python2AST_AST_FOR_TEST(data: datas[1])
    
    let ast = Python2AST_Assert(test: test)
    elementData.ast = ast
    return elementData
}

// assert_stmt -> assert test , test
func AssertStmt_AssertTestTest(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    
    let test = Python2AST_AST_FOR_TEST(data: datas[1])
    let msg = Python2AST_AST_FOR_TEST(data: datas[3])
    
    let ast = Python2AST_Assert(test: test, msg: msg)
    elementData.ast = ast
    return elementData
}

// global_stmt -> global NAME names2
func GlobalStmt_GlobalNameNames2(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Global()
    
    var identifiers = [Python2AST_Identifier]()
    identifiers.append(Python2AST_Identifier(identifier: datas[1].cst!.token!))
    
    // names2
    var names2 = datas[2].cst!
    while true {
        // names2 -> EMPTY
        if names2.children.count == 1 {
            break
        }
        // names2 -> names2 , NAME
        identifiers.append(Python2AST_Identifier(identifier: names2.children[2].token!))
        names2 = names2.children[0]
    }
    
    ast.names = identifiers
    elementData.ast = ast
    return elementData
}

// exec_stmt -> exec expr
func ExecStmt_ExecExpr(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    
    let body = Python2AST_AST_FOR_EXPR(data: datas[1])
    
    let ast = Python2AST_Exec(body: body)
    elementData.ast = ast
    return elementData
}

// exec_stmt -> exec expr in test
func ExecStmt_ExecExprInTest(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    
    let body = Python2AST_AST_FOR_EXPR(data: datas[1])
    let globals = Python2AST_AST_FOR_TEST(data: datas[3])
    
    let ast = Python2AST_Exec(body: body, globals: globals)
    elementData.ast = ast
    return elementData
}

// exec_stmt -> exec expr in test , test
func ExecStmt_ExecExprInTestTest(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    
    let body = Python2AST_AST_FOR_EXPR(data: datas[1])
    let globals = Python2AST_AST_FOR_TEST(data: datas[3])
    let locals = Python2AST_AST_FOR_TEST(data: datas[5])
    
    let ast = Python2AST_Exec(body: body, globals: globals, locals: locals)
    elementData.ast = ast
    return elementData
}

// yield_expr -> yield
func YieldExpr_Yield(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_YieldExpr()
    elementData.ast = ast
    return elementData
}

// yield_expr -> yield testlist
func YieldExpr_YieldTestlist(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let testlist = Python2AST_AST_FOR_TESTLIST(data: datas[1])
    let ast = Python2AST_YieldExpr(value: testlist)
    elementData.ast = ast
    return elementData
}

// augassign -> +=
func AugAssign_0(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_AugAssignOperator()
    ast.augOperator = "+="
    elementData.ast = ast
    return elementData
}

// augassign -> -=
func AugAssign_1(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_AugAssignOperator()
    ast.augOperator = "-="
    elementData.ast = ast
    return elementData
}

// augassign -> *=
func AugAssign_2(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_AugAssignOperator()
    ast.augOperator = "*="
    elementData.ast = ast
    return elementData
}

// augassign -> /=
func AugAssign_3(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_AugAssignOperator()
    ast.augOperator = "/="
    elementData.ast = ast
    return elementData
}

// augassign -> %=
func AugAssign_4(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_AugAssignOperator()
    ast.augOperator = "%="
    elementData.ast = ast
    return elementData
}

// augassign -> &=
func AugAssign_5(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_AugAssignOperator()
    ast.augOperator = "&="
    elementData.ast = ast
    return elementData
}

// augassign -> |=
func AugAssign_6(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_AugAssignOperator()
    ast.augOperator = "|="
    elementData.ast = ast
    return elementData
}

// augassign -> ^=
func AugAssign_7(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_AugAssignOperator()
    ast.augOperator = "^="
    elementData.ast = ast
    return elementData
}

// augassign -> <<=
func AugAssign_8(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_AugAssignOperator()
    ast.augOperator = "<<="
    elementData.ast = ast
    return elementData
}

// augassign -> >>=
func AugAssign_9(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_AugAssignOperator()
    ast.augOperator = ">>="
    elementData.ast = ast
    return elementData
}

// augassign -> **=
func AugAssign_10(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_AugAssignOperator()
    ast.augOperator = "**="
    elementData.ast = ast
    return elementData
}

// augassign -> //=
func AugAssign_11(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_AugAssignOperator()
    ast.augOperator = "//="
    elementData.ast = ast
    return elementData
}

// expr_stmt -> testlist augassign yield_expr
func ExprStmt_TestlistAugassignYieldExpr(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    
    let target = Python2AST_AST_FOR_TESTLIST(data: datas[0])
    let value = datas[2].ast as! Python2AST_YieldExpr
    let op = datas[1].ast as! Python2AST_Operator
    
    let ast = Python2AST_AugAssign(target: target, op: op, value: value)
    elementData.ast = ast
    return elementData
}

// expr_stmt -> testlist augassign testlist
func ExprStmt_TestlistAugassignTestlist(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    
    let target = Python2AST_AST_FOR_TESTLIST(data: datas[0])
    let value = Python2AST_AST_FOR_TESTLIST(data: datas[2])
    let op = datas[1].ast as! Python2AST_Operator
    
    let ast = Python2AST_AugAssign(target: target, op: op, value: value)
    elementData.ast = ast
    return elementData
}

// expr_stmt_parts -> = yield_expr
func ExprStmtParts_YieldExpr(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_ExprStmtParts(value: datas[1].ast as! Python2AST_Expr)
    elementData.ast = ast
    return elementData
}

// expr_stmt_parts -> = testlist
func ExprStmtParts_Testlist(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_ExprStmtParts(value: Python2AST_AST_FOR_TESTLIST(data: datas[1]))
    elementData.ast = ast
    return elementData
}

// expr_stmt_parts -> expr_stmt_parts = yield_expr
func ExprStmtParts_YieldExpr2(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_ExprStmtParts(exprStmtParts: datas[0].ast as! Python2AST_Expr, value: datas[1].ast as! Python2AST_Expr)
    elementData.ast = ast
    return elementData
}

// expr_stmt_parts -> expr_stmt_parts = testlist
func ExprStmtParts_Testlist2(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_ExprStmtParts(exprStmtParts: datas[0].ast as! Python2AST_Expr, value: Python2AST_AST_FOR_TESTLIST(data: datas[1]))
    elementData.ast = ast
    return elementData
}

// expr_stmt -> testlist expr_stmt_parts
func ExprStmt_TestlistExprStmtParts(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    
    // 除了最后一个yield_expr/teslist外，其余的都认为是target
    var targets = [Python2AST_Expr]()
    var value = Python2AST_Expr()

    targets.append(Python2AST_AST_FOR_TESTLIST(data: datas[0]))
    var exprStmtParts = datas[1].ast
    while true {
        if (exprStmtParts as! Python2AST_ExprStmtParts).exprStmtParts == nil {
            value = (exprStmtParts as! Python2AST_ExprStmtParts).value
            break
        }
        targets.append((exprStmtParts as! Python2AST_ExprStmtParts).value)
        exprStmtParts = (exprStmtParts as! Python2AST_ExprStmtParts).exprStmtParts
    }
    
    let ast = Python2AST_Assign(targets: targets, value: value)
    elementData.ast = ast
    return elementData
}

// break_stmt -> break
func BreakStmt_Break(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = Python2AST_Break()
    return elementData
}

// continue_stmt -> continue
func ContinueStmt_Continue(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = Python2AST_Continue()
    return elementData
}

// return_stmt -> return
func ReturnStmt_Return(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = Python2AST_Return()
    return elementData
}

// return_stmt -> return testlist
func ReturnStmt_ReturnTestlist(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let testlist = Python2AST_AST_FOR_TESTLIST(data: datas[1])
    elementData.ast = Python2AST_Return(value: testlist)
    return elementData
}

// raise_stmt -> raise
func RaiseStmt_Raise(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Raise()
    elementData.ast = ast
    return elementData
}

// raise_stmt -> raise test
func RaiseStmt_RaiseTest(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let type = datas[1].ast as! Python2AST_Expr
    let ast = Python2AST_Raise()
    ast.type = type
    elementData.ast = ast
    return elementData
}

// raise_stmt -> raise test , test
func RaiseStmt_RaiseTestTest(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let type = datas[1].ast as! Python2AST_Expr
    let inst = datas[3].ast as! Python2AST_Expr
    let ast = Python2AST_Raise()
    ast.type = type
    ast.inst = inst
    elementData.ast = ast
    return elementData
}

// raise_stmt -> raise test , test , test
func RaiseStmt_RaiseTestTestTest(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let type = datas[1].ast as! Python2AST_Expr
    let inst = datas[3].ast as! Python2AST_Expr
    let tback = datas[5].ast as! Python2AST_Expr
    let ast = Python2AST_Raise()
    ast.type = type
    ast.inst = inst
    ast.tback = tback
    elementData.ast = ast
    return elementData
}

// yield_stmt -> yield_expr
func YieldStmt_YieldExpr(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let yieldExpr = datas[0].ast as! Python2AST_Expr
    let ast = Python2AST_Yield(yield: yieldExpr)
    elementData.ast = ast
    return elementData
}

// if_stmt -> if test : suite elif_parts
func IfStmt_IfTestSuiteElifParts(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let target = datas[1].ast as! Python2AST_Expr
    let suite = Python2AST_AST_FOR_SUITE(data: datas[3])
    let orelse = datas[4].ast as! Python2AST_If
    let ast = Python2AST_If(target: target, body: suite, orelse: [orelse])
    elementData.ast = ast
    return elementData
}

// if_stmt -> if test : suite elif_parts else : suite
func IfStmt_IfTestSuiteElifPartsElseSuite(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let target = datas[1].ast as! Python2AST_Expr
    let suite = Python2AST_AST_FOR_SUITE(data: datas[3])
    let orelse = datas[4].ast as! Python2AST_If
    let elses = Python2AST_AST_FOR_SUITE(data: datas[7])
    
    // 获取到orelse的最后一个if语句，设置其orelse
    var tmp = orelse
    while tmp.orelse.count != 0 {
        tmp = tmp.orelse[tmp.orelse.count-1] as! Python2AST_If
    }
    tmp.orelse = elses
    
    let ast = Python2AST_If(target: target, body: suite, orelse: [orelse])
    elementData.ast = ast
    return elementData
}

// elif_parts -> EMPTY
func ElifParts_EMPTY(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = Python2AST_Empty()
    return elementData
}

// elif_parts -> elif_parts elif_part
func ElifParts_ElifPartsElifPart(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    if datas[0].ast!.getName() == "EMPTY" {
        elementData.ast = datas[1].ast as! Python2AST_Stmt
    } else {
        let ifStmt = datas[0].ast as! Python2AST_If
        elementData.ast = ifStmt
        // 获取到ifStmt最后一个orelse
        if ifStmt.orelse.count == 0 {
            ifStmt.orelse.append(datas[1].ast as! Python2AST_Stmt)
        } else {
            var orelse = ifStmt.orelse[ifStmt.orelse.count-1] as! Python2AST_If
            while true {
                if orelse.orelse.count == 0 {
                    orelse.orelse.append(datas[1].ast as! Python2AST_Stmt)
                    break
                } else {
                    orelse = orelse.orelse[ifStmt.orelse.count-1] as! Python2AST_If
                }
            }
        }
    }
    return elementData
}

// elif_part -> elif test : suite
func ElifPart_ElifTestSuite(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let target = datas[1].ast as! Python2AST_Expr
    let suite = Python2AST_AST_FOR_SUITE(data: datas[3])
    let ast = Python2AST_If(target: target, body: suite, orelse: [])
    elementData.ast = ast
    return elementData
}

// while_stmt -> while test : suite
func WhileStmt_WhileTestSuite(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let target = datas[0].ast as! Python2AST_Expr
    let body = Python2AST_AST_FOR_SUITE(data: datas[3])
    let ast = Python2AST_While(target: target, body: body, orelse: [])
    elementData.ast = ast
    return elementData
}

// while_stmt -> while test : suite else : suite
func WhileStmt_WhileTestSuiteElseSuite(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let target = datas[0].ast as! Python2AST_Expr
    let body = Python2AST_AST_FOR_SUITE(data: datas[3])
    let orelse = Python2AST_AST_FOR_SUITE(data: datas[6])
    let ast = Python2AST_While(target: target, body: body, orelse: orelse)
    elementData.ast = ast
    return elementData
}

// for_stmt -> for exprlist in testlist : suite
func ForStmt_ForExprlistInTestlistSuite(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let target = Python2AST_AST_FOR_EXPRLIST(data: datas[1])
    let iter = Python2AST_AST_FOR_TESTLIST(data: datas[3])
    let body = Python2AST_AST_FOR_SUITE(data: datas[5])
    let ast = Python2AST_For(target: target, iter: iter, body: body, orelse: [])
    elementData.ast = ast
    return elementData
}

// for_stmt -> for exprlist in testlist : suite else : suite
func ForStmt_ForExprlistInTestlistSuiteElseSuite(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let target = Python2AST_AST_FOR_EXPRLIST(data: datas[1])
    let iter = Python2AST_AST_FOR_TESTLIST(data: datas[3])
    let body = Python2AST_AST_FOR_SUITE(data: datas[5])
    let orelse = Python2AST_AST_FOR_SUITE(data: datas[9])
    let ast = Python2AST_For(target: target, iter: iter, body: body, orelse: orelse)
    elementData.ast = ast
    return elementData
}

// with_stmt -> with with_item with_item_parts : suite
func WithStmt_WithWithItemWithItemPartsSuite(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_With(items: [], body: [])
    
    ast.items.append(datas[1].ast as! Python2AST_WithItem)
    let exprs = datas[2].ast as! Python2AST_Exprs
    for expr in exprs.exprs {
        ast.items.append(expr as! Python2AST_WithItem)
    }
    
    let suite = Python2AST_AST_FOR_SUITE(data: datas[4])
    ast.body = suite
    
    elementData.ast = ast
    return elementData
}

// with_item_parts -> EMPTY
func WithItemPart_EMPTY(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Exprs()
    elementData.ast = ast
    return elementData
}

// with_item_parts -> with_item_parts with_item_part
func WithItemParts_WithItemPartsWithItemPart(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = datas[0].ast as! Python2AST_Exprs
    ast.exprs.append(datas[1].ast as! Python2AST_Expr)
    elementData.ast = ast
    return elementData
}

// with_item_part -> , with_item
func WithItemPart_WithItem(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Exprs()
    ast.exprs.append(datas[1].ast as! Python2AST_Expr)
    elementData.ast = ast
    return elementData
}

// with_item -> test
func WithItem_Test(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let expr = datas[0].ast as! Python2AST_Expr
    let ast = Python2AST_WithItem(itemExpr: expr)
    elementData.ast = ast
    return elementData
}

// with_item -> test as expr
func WithItem_TestAsExpr(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let expr = datas[0].ast as! Python2AST_Expr
    let name = datas[2].ast as! Python2AST_Expr
    let ast = Python2AST_WithItem(itemExpr: expr, itemName: name)
    elementData.ast = ast
    return elementData
}

// try_stmt -> try : suite finally : suite
func TryStmt_TrySuiteFinallySuite(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Try()
    ast.body = Python2AST_AST_FOR_SUITE(data: datas[2])
    ast.finalbody = Python2AST_AST_FOR_SUITE(data: datas[5])
    elementData.ast = ast
    return elementData
}

// try_stmt -> try : suite except_clauses
func TryStmt_TrySuiteExceptClauses(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Try()
    ast.body = Python2AST_AST_FOR_SUITE(data: datas[2])
    
    let exceptClauses = datas[3].ast as! Python2AST_Stmts
    for stmt in exceptClauses.stmts {
        ast.excepts.append(stmt as! Python2AST_TryExcept)
    }
    
    elementData.ast = ast
    return elementData
}

// try_stmt -> try : suite except_clauses else : suite
func TryStmt_TrySuiteExceptClausesElseSuite(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Try()
    ast.body = Python2AST_AST_FOR_SUITE(data: datas[2])
    
    let exceptClauses = datas[3].ast as! Python2AST_Stmts
    for stmt in exceptClauses.stmts {
        ast.excepts.append(stmt as! Python2AST_TryExcept)
    }
    ast.orelse = Python2AST_AST_FOR_SUITE(data: datas[6])
    
    elementData.ast = ast
    return elementData
}

// try_stmt -> try : suite except_clauses finally : suite
func TryStmt_TrySuiteExceptClausesFinallySuite(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Try()
    ast.body = Python2AST_AST_FOR_SUITE(data: datas[2])
    
    let exceptClauses = datas[3].ast as! Python2AST_Stmts
    for stmt in exceptClauses.stmts {
        ast.excepts.append(stmt as! Python2AST_TryExcept)
    }
    ast.finalbody = Python2AST_AST_FOR_SUITE(data: datas[6])
    
    elementData.ast = ast
    return elementData
}

// try_stmt -> try : suite except_clauses else : suite finally : suite
func TryStmt_TrySuiteExceptClausesElseSuiteFinallySuite(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Try()
    ast.body = Python2AST_AST_FOR_SUITE(data: datas[2])
    
    let exceptClauses = datas[3].ast as! Python2AST_Stmts
    for stmt in exceptClauses.stmts {
        ast.excepts.append(stmt as! Python2AST_TryExcept)
    }
    ast.orelse = Python2AST_AST_FOR_SUITE(data: datas[6])
    ast.finalbody = Python2AST_AST_FOR_SUITE(data: datas[9])
    
    elementData.ast = ast
    return elementData
}

// except_clauses -> except_clause : suite
func ExceptClauses_ExceptClauseSuite(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_Stmts()
    
    let exceptClause = datas[0].ast as! Python2AST_TryExcept
    exceptClause.body = Python2AST_AST_FOR_SUITE(data: datas[2])
    ast.stmts.append(exceptClause)
    
    elementData.ast = ast
    return elementData
}

// except_clauses -> except_clauses except_clause : suite
func ExceptClauses_ExceptClausesExceptClauseSuite(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = datas[0].ast as! Python2AST_Stmts
    let exceptClause = datas[1].ast as! Python2AST_TryExcept
    exceptClause.body = Python2AST_AST_FOR_SUITE(data: datas[3])
    ast.stmts.append(exceptClause)
    elementData.ast = ast
    return elementData
}

// except_clause -> except
func ExceptClause_Expect(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_TryExcept()
    elementData.ast = ast
    return elementData
}

// except_clause -> except test
func ExceptClause_ExpectTest(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_TryExcept()
    ast.item = datas[1].ast as! Python2AST_Expr
    elementData.ast = ast
    return elementData
}

// except_clause -> except test as test
func ExceptClause_ExpectTestAsTest(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_TryExcept()
    ast.item = datas[1].ast as! Python2AST_Expr
    ast.name = datas[3].ast as! Python2AST_Expr
    elementData.ast = ast
    return elementData
}

// except_clause -> except test , test
func ExceptClause_ExpectTestTest(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = Python2AST_TryExcept()
    ast.item = datas[1].ast as! Python2AST_Expr
    ast.name = datas[3].ast as! Python2AST_Expr
    elementData.ast = ast
    return elementData
}

// funcdef -> def NAME parameters : suite
func FuncDef_DefNameParametersSuite(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    
    let identifier = Python2AST_Identifier(identifier: datas[1].cst!.token!)
    let ast = Python2AST_FunctionDef(identifier: identifier)
    
    ast.args = Python2AST_AST_FOR_ARGUMENTS(data: datas[2])
    ast.body = Python2AST_AST_FOR_SUITE(data: datas[4])
    
    elementData.ast = ast
    return elementData
}

// classdef -> class NAME : suite
func ClassDef_ClassNameSuite(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let identifier = Python2AST_Identifier(identifier: datas[1].cst!.token!)
    let ast = Python2AST_ClassDef(identifier: identifier)
    ast.body = Python2AST_AST_FOR_SUITE(data: datas[3])
    elementData.ast = ast
    return elementData
}

// classdef -> class NAME ( ) : suite
func ClassDef_ClassNameSuite2(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let identifier = Python2AST_Identifier(identifier: datas[1].cst!.token!)
    let ast = Python2AST_ClassDef(identifier: identifier)
    ast.body = Python2AST_AST_FOR_SUITE(data: datas[5])
    elementData.ast = ast
    return elementData
}

// classdef -> class NAME ( testlist ) : suite
func ClassDef_ClassNameTestlistSuite(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let identifier = Python2AST_Identifier(identifier: datas[1].cst!.token!)
    let ast = Python2AST_ClassDef(identifier: identifier)
    ast.bases = Python2AST_AST_FOR_TESTLIST(data: datas[3])
    ast.body = Python2AST_AST_FOR_SUITE(data: datas[6])
    elementData.ast = ast
    return elementData
}

// decorated -> decorators classdef
func Decorated_decoratorsClassDef(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = datas[1].ast as! Python2AST_ClassDef
    ast.decoratorList = Python2AST_AST_FOR_DECORATORS(data: datas[0])
    elementData.ast = ast
    return elementData
}

// decorated -> decorators funcdef
func Decorated_decoratorsFuncDef(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let ast = datas[1].ast as! Python2AST_FunctionDef
    ast.decoratorList = Python2AST_AST_FOR_DECORATORS(data: datas[0])
    elementData.ast = ast
    return elementData
}

// import_stmt -> import_name
func ImportStmt_ImportName(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// import_name -> import dotted_as_names
func ImportName_ImportDottedAsNames(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    let names = Python2AST_AST_FOR_ALIAS(data: datas[1])
    let ast = Python2AST_Import(names: names)
    elementData.ast = ast
    return elementData
}

// import_stmt -> import_from
func ImportStmt_ImportFrom(datas:[LCPGElementData]) -> LCPGElementData {
    let elementData = LCPGElementData()
    elementData.ast = datas[0].ast
    return elementData
}

// import_from -> from . import import_from_import

// import_from -> from dotted_name import import_from_import

// import_from -> from import_from_from import import_from_import

// tests -> EMPTY

// tests -> tests , test

// import_from_from -> dots dotted_name

// import_from_from -> dots .

// dots -> .

// dots -> dots .

// import_from_import -> *

// import_from_import -> ( import_as_names )

// import_from_import -> import_as_names

// import_as_name -> NAME

// import_as_name -> NAME as NAME

// dotted_as_name -> dotted_name

// dotted_as_name -> dotted_name as NAME

// dotted_as_names -> dotted_as_name

// dotted_as_names -> dotted_as_name dotted_as_names_parts

// dotted_as_names_parts -> dotted_as_names_part

// dotted_as_names_parts -> dotted_as_names_parts dotted_as_names_part

// dotted_as_names_part -> , dotted_as_name

// import_as_names -> import_as_name import_as_name_parts

// import_as_names -> import_as_name import_as_name_parts ,

// import_as_name_parts -> EMPTY

// import_as_name_parts -> import_as_name_parts import_as_name_part

// import_as_name_part -> , import_as_name

// dotted_name -> NAME names

// names -> EMPTY

// names -> names . NAME

// names2 -> EMPTY

// names2 -> names2 , NAME

// test -> or_test

// test -> or_test if or_test else test

// test -> lambdef

// or_test -> and_test or_test_parts

// or_test_parts -> EMPTY

// or_test_parts -> or_test_parts or_test_part

// or_test_part -> or and_test

// and_test -> not_test and_test_parts

// and_test_parts -> EMPTY

// and_test_parts -> and_test_parts and_test_part

// and_test_part -> and not_test

// not_test -> not not_test

// not_test -> comparison

// comparison -> expr comparison_parts

// comparison_parts -> EMPTY

// comparison_parts -> comparison_parts comparison_part

// comparison_part -> comp_op expr

// comp_op -> <

// comp_op -> >

// comp_op -> ==

// comp_op -> >=

// comp_op -> <=

// comp_op -> <>

// comp_op -> !=

// comp_op -> in

// comp_op -> not in

// comp_op -> is

// comp_op -> is not

// expr -> xor_expr expr_parts

// expr_parts -> EMPTY

// expr_parts -> expr_parts expr_part

// expr_part -> | xor_expr

// xor_expr -> and_expr xor_expr_parts

// xor_expr_parts -> EMPTY

// xor_expr_parts -> xor_expr_parts xor_expr_part

// xor_expr_part -> ^ and_expr

// and_expr -> shift_expr and_expr_parts

// and_expr_parts -> EMPTY

// and_expr_parts -> and_expr_parts and_expr_part

// and_expr_part -> & shift_expr

// shift_expr -> arith_expr shift_expr_parts

// shift_expr_parts -> EMPTY

// shift_expr_parts -> shift_expr_parts shift_expr_part

// shift_expr_part -> << arith_expr

// shift_expr_part -> >> arith_expr

// arith_expr -> term arith_expr_parts

// arith_expr_parts -> EMPTY

// arith_expr_parts -> arith_expr_parts arith_expr_part

// arith_expr_part -> + term

// arith_expr_part -> - term

// term -> factor term_parts

// term_parts -> EMPTY

// term_parts -> term_parts term_part

// term_part -> * factor

// term_part -> / factor

// term_part -> % factor

// term_part -> // factor

// factor -> + factor

// factor -> - factor

// factor -> ~ factor

// factor -> power

// power -> atom trailers

// power -> atom trailers ** factor

// trailers -> EMPTY

// trailers -> trailers trailer

// suite -> simple_stmt

// suite -> NEWLINE INDENT stmt_list DEDENT

// stmt_list -> stmt

// stmt_list -> stmt_list stmt

// testlist -> test tests

// testlist -> test tests ,

// exprs -> EMPTY

// exprs -> exprs , expr

// exprlist -> expr exprs

// exprlist -> expr exprs ,

// trailer -> . NAME

// trailer -> ( )

// trailer -> ( arglist )

// trailer -> [ subscriptlist ]

// subscriptlist -> subscript subscripts

// subscriptlist -> subscript subscripts ,

// subscripts -> EMPTY

// subscripts -> subscripts , subscript

// subscript -> . . .

// subscript -> test

// subscript -> :

// subscript -> test :

// subscript -> : test

// subscript -> : sliceop

// subscript -> test : test

// subscript -> test : sliceop

// subscript -> : test sliceop

// subscript -> test : test sliceop

// sliceop -> :

// sliceop -> : test

// arglist -> * test arguments

// arglist -> * test arguments , ** test

// arglist -> ** test

// arglist -> argument arguments

// arglist -> argument arguments ,

// arglist -> argument arguments , * test arguments

// arglist -> argument arguments , * test arguments , ** test

// arglist -> argument arguments , ** test

// arguments -> EMPTY

// arguments -> arguments , argument

// argument -> test

// argument -> test comp_for

// argument -> test = test

// comp_for -> for exprlist in or_test

// comp_for -> for exprlist in or_test comp_iter

// comp_iter -> comp_for

// comp_iter -> comp_if

// comp_if -> if old_test

// comp_if -> if old_test comp_iter

// old_test -> or_test

// old_test -> old_lambdef

// atom -> NAME

// atom -> NUMBER

// atom -> strings

// atom -> ( )

// atom -> ( yield_expr )

// atom -> ( testlist_comp )

// atom -> [ ]

// atom -> [ listmaker ]

// atom -> { }

// atom -> { dictorsetmaker }

// atom -> ` testlist1 `

// strings -> STRING

// strings -> strings STRING

// testlist1 -> test tests

// dictorsetmaker -> test : test comp_for

// dictorsetmaker -> test : test testtests

// dictorsetmaker -> test : test testtests ,

// dictorsetmaker -> test comp_for

// dictorsetmaker -> test tests

// dictorsetmaker -> test tests ,

// testtests -> EMPTY

// testtests -> testtests , test : test

// testlist_comp -> test tests

// testlist_comp -> test tests ,

// testlist_comp -> test comp_for

// listmaker -> test list_for

// listmaker -> test tests

// listmaker -> test tests ,

// list_for -> for exprlist in testlist_safe

// list_for -> for exprlist in testlist_safe list_iter

// list_iter -> list_for

// list_iter -> list_if

// list_if -> if old_test

// list_if -> if old_test list_iter

// testlist_safe -> old_test

// testlist_safe -> old_test old_tests

// testlist_safe -> old_test old_tests ,

// old_tests -> , old_test

// old_tests -> old_tests , old_test

// old_lambdef -> lambda : old_test

// old_lambdef -> lambda varargslist : old_test

// lambdef -> lambda : test

// lambdef -> lambda varargslist : test

// decorator -> @ dotted_name NEWLINE

// decorator -> @ dotted_name ( ) NEWLINE

// decorator -> @ dotted_name ( arglist ) NEWLINE

// decorators -> decorator

// decorators -> decorators decorator

// parameters -> ( )

// parameters -> ( varargslist )

// varargslist -> fpdef_expr * NAME

// varargslist -> fpdef_expr * NAME , ** NAME

// varargslist -> fpdef_expr ** NAME

// varargslist -> fpdef_expr fpdef_test

// varargslist -> fpdef_expr fpdef_test ,

// fpdef_test -> fpdef

// fpdef_test -> fpdef = test

// fpdef_expr -> EMPTY

// fpdef_expr -> fpdef_expr fpdef_test ,

// fpdef -> NAME

// fpdef -> ( fplist )

// fplist -> fpdef fpdefs

// fplist -> fpdef fpdefs ,

// fpdefs -> EMPTY

// fpdefs -> fpdefs , fpdef


/* -*- GRAMMAR-END -*- */
