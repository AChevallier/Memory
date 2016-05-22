//
//  FileSave.swift
//  Memory
//
//  Created by Alexandre Chevallier on 04/04/16.
//  Copyright © 2016 achevallier. All rights reserved.
//

import Foundation

class Score: NSObject, NSCoding {
    var nickname: String
    var score: String
    var time: String
    var level : Int
    
    init(nickname:String, score: String, time:String, level : Int) {
        self.nickname = nickname
        self.score = score
        self.time = time
        self.level = level
    }
    
    // MARK: NSCoding
    required convenience init(coder decoder: NSCoder) {
        
        let nickname = decoder.decodeObjectForKey("nickname") as! String
        let score = decoder.decodeObjectForKey("score")as! String
        let time = decoder.decodeObjectForKey("time") as! String
        let level = decoder.decodeObjectForKey("level") as! Int
        
        self.init(nickname:nickname, score:score,time:time, level:level)
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.nickname, forKey: "nickname")
        coder.encodeObject(self.score, forKey: "score")
        coder.encodeObject(self.time, forKey: "time")
        coder.encodeObject(self.level, forKey: "level")
    }
}