//
//  Workout.swift
//  FitnessGod
//
//  Created by cruzr on 2018/12/3.
//  Copyright © 2018 martin. All rights reserved.
//

import UIKit

enum PlanType : String, Codable {
    case typeA
    case typeB
}

enum WorkoutType : String, Codable {
    case squat
    case ohpress
    case deadlift
    case bench
    case row
}

struct PlanKey {
    static let planID = "planID"
    static let datetime = "datetime"
    static let data = "data"
}

class Workout : Codable{
    
    var workoutName = ""
    var targetKG : Double = 20
    var isDone = false
    var firstGroup = 0
    var secondGroup = 0
    var thirdGroup = 0
    var fourthGroup = 0
    var fifthGroup = 0
    
    var workoutType : WorkoutType = WorkoutType.squat {
        didSet {
            switch workoutType {
            case .squat:
                workoutName = "深蹲"
            case .bench:
                workoutName = "卧推"
            case .row:
                workoutName = "俯身划船"
            case .ohpress:
                workoutName = "过头推举"
            case .deadlift:
                workoutName = "硬拉"
            }
        }
    }
    
}

class Plan5x5 : Codable {
    
    var date : Date?
    
    var isDone = false
    
    var firstWorkout = Workout()
    var secondWorkout = Workout()
    var thirdWorkout = Workout()
    
    var planType : PlanType = PlanType.typeA {
        didSet {
            if planType == PlanType.typeA {
                firstWorkout.workoutType = .squat
                secondWorkout.workoutType = .bench
                thirdWorkout.workoutType = .row
            } else {
                firstWorkout.workoutType = .squat
                secondWorkout.workoutType = .ohpress
                thirdWorkout.workoutType = .deadlift
            }
        }
    }
    
    
}
