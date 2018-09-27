//
//  main.swift
//  FizzBuzz
//
//  Created by 박길남 on 2018. 9. 27..
//  Copyright © 2018년 swieeft. All rights reserved.
//

/*
 FizzBuzz 프로그램은 1 ~ 100 까지의 숫자를 출력하되, 3으로 나누어 떨어진다면 fizz, 5로 나누어 떨어진다면 buzz, 3과 5 둘 다 나누어 떨어지면 fizzbuzz를 출력하는 프로그램 입니다.
 */

import Foundation

/* non-FP Code --------------------------
 
var i = 1
while i <= 100 {
    if i % 3 == 0 && i % 5 == 0 {
        print("fizzbuzz")
    }
    else if i % 3 == 0 {
        print("fizz")
    }
    else if i % 5 == 0 {
        print("buzz")
    }
    else {
        print(i)
    }
    
    i += 1
}
-------------------------------------- */

// FP Code ------------------------------

let fizz = { i in i % 3 == 0 ? "fizz" : "" }
let buzz = { i in i % 5 == 0 ? "buzz" : "" }
let fizzbuzz:(Int) -> String = { i in { a, b in b.isEmpty ? a : b }("\(i)", fizz(i) + buzz(i)) }

func loop(min:Int, max:Int, do f:(Int) -> Void) {
    Array(min...max).forEach(f)
}

loop(min: 1, max: 100) { print(fizzbuzz($0)) }

