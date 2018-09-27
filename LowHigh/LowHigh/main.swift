//
//  main.swift
//  LowHigh
//
//  Created by 박길남 on 2018. 9. 27..
//  Copyright © 2018년 swieeft. All rights reserved.
//

/*
 Low-High 는 사용자로부터 숫자를 입력받아 랜덤(1~100)으로 생성된 값과 비교하여,
 
 - 큰 값이 입력되면 High
 - 작은 값이 입력되면 Low
 - 같으면 Correct! 를 출력합니다.
 - Correct 출력 시 시도했던 횟수를 함께 출력합니다.
 - 수행은 Correct가 될 때까지 무한반복됩니다.
 - 숫자가 입력되지 않으면 Wrong 을 출력합니다.
 */

import Foundation

/* non-FP Code -----------------------------------
 let answer = Int(arc4random() % 100) + 1
 var count = 0
 
 while true {
 
 let userInput = readLine()
 
 guard let unwrappedInput = userInput, let inputNumber = Int(unwrappedInput) else {
 print("Wrong")
 continue
 }
 
 if inputNumber == answer {
 print("Correct! : \(count)")
 break
 }
 
 if inputNumber > answer {
 print("High")
 }
 
 if inputNumber < answer {
 print("Low")
 }
 
 count += 1
 }
 ----------------------------------------------*/

// FP Code ------------------------------------------

enum Result: String {
    case wrong = "wrong"
    case correct = "Correct!"
    case low = "Low"
    case high = "High"
}

func generateAnswer(_ min:Int, _ max:Int) -> Int {
    return Int(arc4random()) % (max - min) + min
}

func inputAndCheck(_ answer:Int) -> () -> Bool {
    return { printResult(evaluateInput(answer)) }
}

func evaluateInput(_ answer:Int) -> Result {
    guard let inputNumber = Int(readLine() ?? "") else {
        return .wrong
    }
    
    if inputNumber > answer { return .high }
    if inputNumber < answer { return .low }
    
    return .correct
}

func printResult(_ r:Result) -> Bool{
    if case .correct = r { return false }
    
    print(r.rawValue)
    return true
}

func corrected(_ count:Int) {
    print("Correct! : \(count)")
}

func countingLoop(_ needContinue: @escaping () -> Bool, _ finished:(Int) -> Void) {
    func counter(_ c:Int) -> Int {
        if needContinue() == false { return c }
        return counter(c + 1)
    }

    finished(counter(0))
}

countingLoop(inputAndCheck(generateAnswer(1, 100)), corrected)
