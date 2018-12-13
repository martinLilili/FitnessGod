//
//  Utils.swift
//  FitnessGod
//
//  Created by cruzr on 2018/12/5.
//  Copyright © 2018 martin. All rights reserved.
//

import UIKit

func quxiaoshudianhoudeling(testNumber:String) -> String{
    var outNumber = testNumber
    var i = 1
    if testNumber.contains("."){
        while i < testNumber.count{
            if outNumber.hasSuffix("0"){
                outNumber.remove(at: outNumber.index(before: outNumber.endIndex))
                i = i + 1
            }else{
                break
            }
        }
        if outNumber.hasSuffix("."){
            outNumber.remove(at: outNumber.index(before: outNumber.endIndex))
        }
        return outNumber
    }
    else{
        return testNumber
    }
}

func getDayNext(aDate : Date, days : Int) -> Date? {
    let gregorian = Calendar(identifier: .gregorian)
    var components: DateComponents = gregorian.dateComponents([.weekday, .year, .month, .day], from: aDate)
    components.day = components.day! + days
    return gregorian.date(from: components)
}

func getDateString(aDate : Date) -> String {
    if NSCalendar.current.isDateInToday(aDate) {
        return "今天"
    } else if NSCalendar.current.isDateInTomorrow(aDate) {
        return "明天"
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM月dd日"
    return dateFormatter.string(from: aDate)
}

func getWeekDay(aDate : Date) -> Int? {
    let gregorian = Calendar(identifier: .gregorian)
    var components: DateComponents = gregorian.dateComponents([.weekday, .year, .month, .day], from: aDate)
    //周日是1,周一是2...
    return components.weekday
}

typealias Task = (_ cancel : Bool) -> Void

func delay(time:TimeInterval, task:@escaping ()->()) ->  Task? {
    func dispatch_later(block:@escaping ()->()) {
        //        let additionalTime: DispatchTimeInterval = .seconds(Int(time))
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            block()
        }
    }
    var closure: (()->())? = task
    var result: Task?
    let delayedClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    result = delayedClosure
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    return result;
}


class Utils: NSObject {

}
