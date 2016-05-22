//
//  Option.swift
//  Memory
//
//  Created by Alexandre Chevallier on 02/05/16.
//  Copyright © 2016 achevallier. All rights reserved.
//

import Foundation

//
//  Login.swift
//  Memory
//
//  Created by Alexandre Chevallier on 04/04/16.
//  Copyright © 2016 achevallier. All rights reserved.
//

import Foundation

import UIKit

class ChooseVersoController: UIViewController{
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var segmentControle: UISegmentedControl!
        
    let defaults = NSUserDefaults.standardUserDefaults()
    var verso:String = ""
    let listVerso = ["verso.png","verso1.jpeg","verso2.jpg"]
    
    override func viewDidLoad() {
        
        if(self.defaults.objectForKey("verso") != nil){
            verso = self.defaults.objectForKey("verso") as! String
        }
        else{
            verso = "verso.png"
        }
        segmentControle.selectedSegmentIndex = listVerso.indexOf(verso)!
        
        imageView.image = UIImage(named: verso)
        super.viewDidLoad()
    }
    
    @IBAction func changeSeg(sender: AnyObject) {
        verso = listVerso[segmentControle.selectedSegmentIndex]
        imageView.image = UIImage(named: verso)
        self.defaults.setValue(verso, forKey: "verso")
    }
    
}
