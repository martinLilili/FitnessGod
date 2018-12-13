//
//  MainWorkoutDetailViewController.swift
//  FitnessGod
//
//  Created by cruzr on 2018/12/5.
//  Copyright © 2018 martin. All rights reserved.
//

import UIKit

protocol MainWorkoutDetailViewControllerDelegate : NSObjectProtocol {
    func didSave()
}

class MainWorkoutDetailViewController: UIViewController {
    
    var workout : Workout? = nil
    
    var targetKG : Double = 0
    
    @IBOutlet weak var targetKGLabel: UILabel!
    
    @IBOutlet weak var targetRemind: UILabel!
    
    @IBOutlet weak var warmup1remind: UILabel!
    
    @IBOutlet weak var warmup2remind: UILabel!
    
    @IBOutlet weak var warmup3remind: UILabel!
    
    weak var delegate : MainWorkoutDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = workout?.workoutName
        // Do any additional setup after loading the view.
        
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(MainWorkoutDetailViewController.saveItmClicked(item:)))
        
        self.navigationItem.rightBarButtonItem = saveItem
        
        if workout != nil {
            targetKG = workout!.targetKG
        }
        refreshData()
        
    }
    
    @objc func saveItmClicked (item : UIBarButtonItem) {
        if workout != nil {
            workout!.targetKG = targetKG
        }
        
        delegate?.didSave()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func refreshData() {
        if let wk = workout {
            targetKGLabel.text = "\(quxiaoshudianhoudeling(testNumber: "\(targetKG)"))KG"
            
            if wk.targetKG >= 20 {
                let shounum = (targetKG - 20)/2
                targetRemind.text = "杠铃每边添加\(quxiaoshudianhoudeling(testNumber: "\(shounum)"))KG"
            } else {
                targetRemind.text = "请选择适合的固定重量的小杠铃"
            }
            
            
            var firstwarm = Double(targetKG) * 0.5
            var secondwarm = Double(targetKG) * 0.65
            var thirdwarm = Double(targetKG) * 0.8
            thirdwarm = thirdwarm - thirdwarm.truncatingRemainder(dividingBy: 2.5)
            if Double(targetKG) - thirdwarm < 5 {
                thirdwarm = Double(targetKG) - 5
            }
            if thirdwarm < 5 {
                thirdwarm = 5
            }
            secondwarm = secondwarm - secondwarm.truncatingRemainder(dividingBy: 2.5)
            if thirdwarm - secondwarm < 5 {
                secondwarm = thirdwarm - 5
            }
            if secondwarm < 5 {
                secondwarm = 5
            }
            firstwarm = firstwarm - firstwarm.truncatingRemainder(dividingBy: 2.5)
            if secondwarm - firstwarm < 5 {
                firstwarm = secondwarm - 5
            }
            if firstwarm < 5 {
                firstwarm = 5
            }
            if firstwarm >= 20 {
                let shounum = (firstwarm - 20)/2
                warmup1remind.text = "热身组1：杠铃每边添加\(quxiaoshudianhoudeling(testNumber: "\(shounum)"))KG"
            } else {
                warmup1remind.text = "请选择适合的固定重量的小杠铃热身"
            }
            if secondwarm >= 20 {
                let shounum = (secondwarm - 20)/2
                warmup2remind.text = "热身组2：杠铃每边添加\(quxiaoshudianhoudeling(testNumber: "\(shounum)"))KG"
            } else {
                warmup2remind.text = "请选择适合的固定重量的小杠铃热身"
            }
            if thirdwarm >= 20 {
                let shounum = (thirdwarm - 20)/2
                warmup3remind.text = "热身组3：杠铃每边添加\(quxiaoshudianhoudeling(testNumber: "\(shounum)"))KG"
            } else {
                warmup3remind.text = "请选择适合的固定重量的小杠铃热身"
            }
        }
    }
    
    @IBAction func minusTouched(_ sender: UIButton) {
        if workout != nil {
            if targetKG > 0 {
                if workout!.workoutType == WorkoutType.deadlift {
                    if workout!.targetKG < 100 {
                        targetKG += 5
                    } else {
                        targetKG += 2.5
                    }
                    refreshData()
                } else {
                    targetKG -= 2.5
                    refreshData()
                }
            }
        }
    }
    
    @IBAction func addTouched(_ sender: UIButton) {
        if workout != nil {
            if workout!.workoutType == WorkoutType.deadlift {
                if workout!.targetKG < 100 {
                    targetKG += 5
                } else {
                    targetKG += 2.5
                }
                refreshData()
            } else {
                targetKG += 2.5
                refreshData()
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
