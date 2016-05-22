//
//  Carte.swift
//  Memory
//
//  Created by etudiant on 29/02/2016.
//  Copyright © 2016 achevallier. All rights reserved.
//

import Foundation
import UIKit

class Carte{
    
    var id: Int!
    var decouvert = false
    var image: String?
    var pair: Int?
    var viewVerso : UIView?
    var viewPile : UIView?
    var viewGeneral : UIView?
    
    init (id: Int) {
        self.id = id
    }
    
    init (id: Int, image: String, pair: Int) {
        self.id = id
        self.image = image
        self.pair = pair
    }
    
    var toString : String{
        return "image=\(image)"
    }
}