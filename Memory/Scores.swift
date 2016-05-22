//
//  Scores.swift
//  Memory
//
//  Created by Alexandre Chevallier on 11/04/16.
//  Copyright © 2016 achevallier. All rights reserved.
//

import Foundation

class Scores {
    var listScores:[Score]
    let defaults = NSUserDefaults.standardUserDefaults()
    
    init() {
        if(defaults.objectForKey("listScores") != nil){
           listScores = defaults.objectForKey("listScores") as! [Score]
        }
        else{
        listScores = [Score]()
        }
    }
    
    func addScore(nickname: String, score : String, time: String, level : Int){
        let score = Score(nickname: nickname, score : score, time: time, level : level)
        self.listScores.append(score)
        let myData = NSKeyedArchiver.archivedDataWithRootObject(listScores)
        defaults.setObject(myData, forKey: "listScores")
        dump(listScores)
    }
}