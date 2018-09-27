//
//  main.swift
//  VendingMachine
//
//  Created by 박길남 on 2018. 9. 27..
//  Copyright © 2018년 swieeft. All rights reserved.
//

import Foundation

enum Product : Int{
    case cola = 1000
    case cider = 1100
    case fanta = 1200
    
    func name() -> String {
        switch self {
        case .cola:
            return "콜라"
        case .cider:
            return "사이다"
        case .fanta:
            return "환타"
        }
    }
}

enum Input {
    case moneyInput(Int)
    case productSelect(Product)
    case reset
    case none
}

enum Output {
    case displayMoney(Int)
    case productOut(Product)
    case shortMoneyError
    case change(Int)
}

struct State {
    let money:Int
}

func consoleInput() -> Input {
    guard let command = readLine() else {
        return .none
    }
    
    switch command {
    case "100":
        return .moneyInput(100)
    case "500":
        return .moneyInput(500)
    case "1000":
        return .moneyInput(1000)
    case "cola":
        return .productSelect(.cola)
    case "cider":
        return .productSelect(.cider)
    case "fanta":
        return .productSelect(.fanta)
    case "reset":
        return .reset
    default:
        return .none
    }
}

func consoleOutput(_ output:Output) {
    switch output {
    case .displayMoney(let m):
        print("현재 금액은 \(m)원 입니다.")
    case .productOut(let p):
        print("\(p.name())이 나왔습니다.")
    case .shortMoneyError:
        print("잔액이 부족합니다.")
    case .change(let c):
        print("잔액 \(c)원이 나왔습니다.")
    }
}

func operation(_ inp:@escaping () -> Input, _ oup:@escaping (Output) -> ()) -> (State) -> State {
    return { state in
        let input = inp()

        switch input {
        case .moneyInput(let m):
            let money = state.money + m
            oup(.displayMoney(money))
            return State(money: money)
        case .productSelect(let p):
            if state.money < p.rawValue {
                oup(.shortMoneyError)
                return state
            }
            oup(.productOut(p))
            
            let money = state.money - p.rawValue
            oup(.displayMoney(money))
            return State(money: money)
        case .reset:
            oup(.change(state.money))
            oup(.displayMoney(0))
            return State(money: 0)
        case .none:
            return state
        }
        
    }
}

func machineLoop(_ f: @escaping (State) -> State) {
    func loop(_ s:State) {
        loop(f(s))
    }
    loop(State(money: 0))
}

machineLoop(operation(consoleInput, consoleOutput))


















