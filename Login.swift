//
//  Login.swift
//  Memory
//
//  Created by Alexandre Chevallier on 04/04/16.
//  Copyright © 2016 achevallier. All rights reserved.
//

import Foundation

import UIKit

class LoginController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet var segmentedControlScore: UISegmentedControl!
    @IBOutlet
    var tableView: UITableView!
    
    @IBOutlet weak var inputLogin: UITextField!
    
    var listScores:[[String : AnyObject]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        if(self.defaults.objectForKey("listScores") != nil){
            let list = self.defaults.objectForKey("listScores") as! [[String : AnyObject]]
            let listSorted = list.sort({ Int(($0["score"] as? String)!)! > Int(($1["score"] as? String)!)! })
            var bestScore:[String : AnyObject] = list[0]
            for score in listSorted{
                if(Int((score["score"] as? String)!)! > Int((bestScore["score"] as? String)!)!)
                {
                    bestScore = score
                }

                if(score["level"] != nil && score["level"] as! Int == 6){
                    listScores.append(score)
                }
            }
        }
        

        
    }

    
    @IBAction func touchSeg(sender: UISegmentedControl) {
        listScores = []
        tableView.reloadData()
        var nbCard = 6
        if(sender.selectedSegmentIndex == 0){
            nbCard = 6
        }else if(sender.selectedSegmentIndex == 1){
            nbCard = 12
        }else if(sender.selectedSegmentIndex == 2){
            nbCard = 16
        }
        if(self.defaults.objectForKey("listScores") != nil){
            let list = self.defaults.objectForKey("listScores") as! [[String : AnyObject]]
            
            let sorted = list.sort({ t1, t2 in
                if Int((t1["score"] as? String)!)! == Int((t2["score"] as? String)!)! {
                    return (t1["time"] as? String)! < (t2["time"] as? String)!
                }
                return Int((t1["score"] as? String)!)! > Int((t2["score"] as? String)!)!
            })
            
            if sorted.count > 0{
                for score in sorted{
                    if(score["level"] != nil && score["level"] as! Int == nbCard){
                        listScores.append(score)
                    }
                }
            }
        }
        
        tableView.reloadData()
    }

    // Permet d'envoyer des informations dans la seconde vue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "jouer"){
            let destinationViewController : ViewController = segue.destinationViewController as! ViewController;
            
            if(inputLogin.text! == ""){
                inputLogin.text! = "Default"
            }
            
            destinationViewController.nicknameSegue = inputLogin.text!;
        }
        
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listScores.count;
        //return 0 // your number of cell here
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        var showText = String(self.listScores[indexPath.row]["nickname"]!)
        showText += " - "
        showText += String(self.listScores[indexPath.row]["score"]!)
        showText += " - "
        showText += String(self.listScores[indexPath.row]["time"]!)
        
        cell.textLabel?.text = showText
        
        if(indexPath.row == 0){
            cell.imageView!.image = UIImage(named: "record-coupe.png")
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // cell selected code here
    }
    
}