//
//  LCPGParser.swift
//  libcode
//
//  Created by thuanqin on 2017/10/28.
//  Copyright © 2017年 tianhuan. All rights reserved.
//

import Foundation

enum LCPGActionType {
    case reduce
    case shift
    case accept
}

class LCPGRSActionInfo {
    // 动作类型
    let action: LCPGActionType
    // Reduce/Accept时的被归并token数目
    let count: Int!
    // R/S后跳转到的状态
    let nextState: Int!
    // reduce生成的token
    let reduceToken: String!
    // Reduce/Accept时执行的动作
    let function: (([LCPGElementData]) -> LCPGElementData)!
    
    init(action: LCPGActionType, count: Int, reduceToken: String, function: @escaping (([LCPGElementData]) -> LCPGElementData)) {
        self.action = action
        self.count = count
        self.nextState = nil
        self.reduceToken = reduceToken
        self.function = function
    }
    
    init(action: LCPGActionType, nextState: Int) {
        self.action = action
        self.count = nil
        self.nextState = nextState
        self.reduceToken = nil
        self.function = nil
    }
}

enum LCPGElementType {
    case state
    case data
}

class LCPGElementData {
    var ast: AST!
    var cst: CST!
    
    init() {
        self.ast = nil
        self.cst = nil
    }
    
    init(ast: AST) {
        self.ast = ast
        self.cst = nil
    }
    
    init(cst: CST) {
        self.ast = nil
        self.cst = cst
    }
    
    init(ast: AST, cst: CST) {
        self.ast = ast
        self.cst = cst
    }
}

class LCPGElement {
    let type: LCPGElementType
    let state: Int!
    let data: LCPGElementData!
    
    init(state: Int) {
        self.type = .state
        self.state = state
        self.data = nil
    }
    
    init(data: LCPGElementData) {
        self.type = .data
        self.state = nil
        self.data = data
    }
}

class LCPGStack {
    private var elements: [LCPGElement]
    
    init() {
        self.elements = []
    }
    
    func push(element: LCPGElement) {
        self.elements.append(element)
    }
    
    func top() -> LCPGElement? {
        if self.elements.count == 0 {
            return nil
        }
        return self.elements[self.elements.count-1]
    }
    
    func top2() -> LCPGElement? {
        if self.elements.count < 2 {
            return nil
        }
        return self.elements[self.elements.count-2]
    }
    
    func pop() -> LCPGElement? {
        if self.elements.count == 0 {
            return nil
        }
        let element = self.top()
        self.elements.remove(at: self.elements.count-1)
        return element
    }
    
    func dump() -> String {
        var result = ""
        for element in elements {
            switch element.type {
            case .state:
                result += "S\(element.state!) "
            case .data:
                result += "D[\(element.data.cst.type)] "
            }
        }
        return result
    }
}

class LCPGParserBase {
    var tokens: [Token]
    var parser: ParserProtocol!
    let stack: LCPGStack
    var tokenPos: Int
    var ast: AST?
    var cst: CST?
    
    // core状态集
    let core: [Int: [String: LCPGRSActionInfo]]
    // goto状态集
    let goto: [Int: [String: Int]]
    // 修复点
    let fixPoints: [String]
    
    init(core: [Int: [String: LCPGRSActionInfo]], goto: [Int: [String: Int]], fixPoints: [String]) {
        self.tokens = []
        self.parser = nil
        self.stack = LCPGStack()
        self.tokenPos = 0
        self.core = core
        self.fixPoints = fixPoints
        self.goto = goto
    }
    
    func setParser(parser: ParserProtocol) {
        self.parser = parser
    }
    
    func setTokens(tokens: [Token]) {
        self.tokens = tokens
    }
    
    func getAST() -> AST? {
        return self.ast
    }
    
    func getCST() -> CST? {
        return self.cst
    }
    
    private func nextToken() -> Token? {
        if self.tokenPos == self.tokens.count {
            self.tokenPos += 1
            return Token(type: "EOF")
        } else if self.tokenPos > self.tokens.count {
            return nil
        } else {
            self.tokenPos += 1
            return self.tokens[self.tokenPos-1]
        }
    }
    
    func parse() {
        // 推入初始状态
        self.stack.push(element: LCPGElement(state: 0))
        // 当前处理的元素
        var currentElement = self.stack.top()!
        // nextToken
        var nextToken = self.nextToken()
        
        // 工具函数
        func shift(actionInfo: LCPGRSActionInfo) {
            let newData = LCPGElementData()
            newData.cst = CST(type: nextToken!.type, elementData: newData)
            nextToken!.setCST(cst: newData.cst)
            let nextElement = LCPGElement(data: newData)
            self.stack.push(element: nextElement)
            self.stack.push(element: LCPGElement(state: actionInfo.nextState))
            nextToken = self.nextToken()
            currentElement = self.stack.top()!
        }
        
        func reduce(actionInfo: LCPGRSActionInfo) {
            var args = [LCPGElementData]()
            for _ in 0 ..< actionInfo.count {
                _ = self.stack.pop()
                args.append(self.stack.pop()!.data!)
            }
            currentElement = self.stack.top()!
            let newData = actionInfo.function(args.reversed())
            let nextElement = LCPGElement(data: newData)
            // 建立CST关系
            newData.cst = CST(type: actionInfo.reduceToken, elementData: newData)
            for childElementData in args.reversed() {
                childElementData.cst.setParent(parent: newData.cst)
                newData.cst.addChild(child: childElementData.cst)
            }
            self.stack.push(element: nextElement)
            self.stack.push(element: LCPGElement(state: self.goto[currentElement.state]![actionInfo.reduceToken]!))
            currentElement = self.stack.top()!
        }
        
        func accept(actionInfo: LCPGRSActionInfo) -> LCPGElementData {
            var args = [LCPGElementData]()
            for _ in 0 ..< actionInfo.count {
                _ = self.stack.pop()
                args.append(self.stack.pop()!.data!)
            }
            currentElement = self.stack.top()!
            let newData = actionInfo.function(args.reversed())
            // 建立CST关系
            newData.cst = CST(type: actionInfo.reduceToken, elementData: newData)
            for childElementData in args.reversed() {
                childElementData.cst.setParent(parent: newData.cst)
                newData.cst.addChild(child: childElementData.cst)
            }
            return newData
        }
    
        while true {
            if nextToken == nil {
                ast = nil
                cst = nil
                break
            }
            
            print(self.stack.dump())
            print("nextToken: \(nextToken!.type)")
            
            if let actionInfo = self.core[currentElement.state]![nextToken!.type] {
                if actionInfo.action == .shift {
                    shift(actionInfo: actionInfo)
                } else if actionInfo.action == .reduce {
                    reduce(actionInfo: actionInfo)
                } else if actionInfo.action == .accept {
                    let parseResult = accept(actionInfo: actionInfo)
                    self.ast = parseResult.ast
                    self.cst = parseResult.cst
                    break
                }
            } else {
                print("syntax error. nextToken: \(nextToken!.type) pos: \(nextToken!.posBegin) : \(nextToken!.posEnd). current stack: \(self.stack.dump())")
                if Config.parseSyntaxErrorRaise {
                    break
                }
                var fixed = false
                // 是否在寻找fix point的时候有element被pop，若有的话不需要获取nextToken
                var hasElementPop = false
                // 语法错误，跳转到最近的一个修复点，然后一直读取token直到可以正常处理
                while true {
                    let dataElement = self.stack.top2()
                    if dataElement == nil {
                        fixed = false
                        break
                    }
                    
                    for fixPoint in self.fixPoints {
                        if fixPoint == dataElement?.data.cst.type {
                            fixed = true
                            break
                        }
                    }
                    if fixed {
                        break
                    }
                    
                    _ = self.stack.pop()
                    _ = self.stack.pop()
                    hasElementPop = true
                }
                
                nextToken!.setInSyntaxError(inSyntaxError: true)
                if fixed {
                    // stack已经回退到修复点，此时忽略当前的token
                    currentElement = self.stack.top()!
                    if !hasElementPop {
                        nextToken = self.nextToken()
                    }
                    continue
                } else {
                    // 没有任何的修复点，此时可以将stack恢复为最初状态并继续
                    while let _ = self.stack.pop() {
                    }
                    self.stack.push(element: LCPGElement(state: 0))
                    currentElement = self.stack.top()!
                    if !hasElementPop {
                        nextToken = self.nextToken()
                    }
                    continue
                }
            }
        }
    }
}







