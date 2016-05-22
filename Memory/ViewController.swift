//
//  ViewController.swift
//  Memory
//
//  Created by etudiant on 29/02/2016.
//  Copyright © 2016 achevallier. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var nbCoupsText: UILabel!
    @IBOutlet weak var timerText: UILabel!
    @IBOutlet weak var viewCards: UIView!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    var nicknameSegue : String = ""
    
    var timer = NSTimer()
    var startTime = NSTimeInterval()
    var stringTime:String!
    var taille:Double!
    var jeu:Jeu!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let transitionOptions = UIViewAnimationOptions.TransitionFlipFromLeft
    var first = true
    override func viewDidLoad() {
        
        super.viewDidLoad()
        nicknameLabel.text = nicknameSegue
        
        jeu = Jeu(controller: self, viewCards: viewCards)
        self.first = true
        //self.viewCards.layer.borderWidth = 1
        //self.viewCards.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    @IBAction func touchNbCartes(segment: UISegmentedControl) {
        if(segment.selectedSegmentIndex == 0){
            jeu = Jeu(controller:self,viewCards: viewCards)
            
        }
        else if(segment.selectedSegmentIndex == 1){
            jeu = Jeu(controller:self,viewCards: viewCards, nbCartes: 12)
        }
        else if(segment.selectedSegmentIndex == 2){
            jeu = Jeu(controller:self,viewCards: viewCards, nbCartes: 16)
        }
        self.first = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        
        if(self.first){
            startChrono()
            self.first = false
        }
        //let jeu = Jeu.sharedInstance
        
        jeu.nbCoups = jeu.nbCoups + 1
        
        let viewV = gestureRecognizer.view! as UIView
        
        if(jeu.choose_card.count < 2)
        {
            for carte in jeu.liste_carte{
                if (carte.viewGeneral == viewV){
                    
                    UIView.transitionFromView(carte.viewVerso!, toView: carte.viewPile!, duration: 0.5, options: transitionOptions, completion: nil)
                    
                    jeu.choose_card.append(carte)
                    
                }
                carte.viewGeneral?.userInteractionEnabled = false
            }
            //wait 1sec
            var delay = 0.5 * Double(NSEC_PER_SEC)
            if(jeu.choose_card.count == 1){
               delay = 0 * Double(NSEC_PER_SEC)
            }
            
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                // After 2 seconds this line will be executed
                if(self.jeu.choose_card.count == 2){
                    
                    if(self.jeu.matchTwoCards(self.jeu.choose_card[0], card2: self.jeu.choose_card[1])){
                        for choseCard in self.jeu.choose_card{
                            
                            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                                
                                choseCard.viewGeneral!.alpha = 0.0
                                choseCard.viewGeneral?.userInteractionEnabled = false
                                choseCard.decouvert = true
                                
                                }, completion: nil)
                            
                        }
                        self.jeu.score = self.jeu.score + 40
                    }
                    else{
                        UIView.transitionFromView(self.jeu.choose_card[0].viewPile!, toView: self.jeu.choose_card[0].viewVerso!, duration: 0.5, options: self.transitionOptions, completion: nil)
                        UIView.transitionFromView(self.jeu.choose_card[1].viewPile!, toView: self.jeu.choose_card[1].viewVerso!, duration: 0.5, options: self.transitionOptions, completion: nil)
                        self.jeu.score = self.jeu.score - 10
                    }
                    self.jeu.choose_card.removeAll()
                    self.nbCoupsText.text = String((self.jeu.score-self.jeu.nbCoups/2))
                    if(self.jeu.checkJeuFini()){
                        self.timer.invalidate()
                        self.first = true
                        //###################
                        var score = [String : AnyObject]()
                        score["nickname"] = self.nicknameSegue
                        score["score"] = String((self.jeu.score-self.jeu.nbCoups/2))
                        score["time"] = self.stringTime!
                        score["level"] = self.jeu.nbCartes
                        
                        
                        var listScores = self.defaults.objectForKey("listScores") as? [[String : AnyObject]]
                        
                        if(listScores != nil){
                            listScores?.append(score)
                        }
                        else{
                            listScores = [score]
                        }
                        
                        self.defaults.setValue(listScores, forKey: "listScores")
                        dump(listScores)
                        //self.scores.addScore(self.nicknameSegue, score : String(self.jeu.nbCoups), time: self.stringTime!, level: self.jeu.nbCartes)
                        //###################
                        
                        
                        let actionSheetController: UIAlertController = UIAlertController(title: "Partie finie", message: "Score : " + String(self.jeu.score-self.jeu.nbCoups/2)+" en " + self.stringTime!, preferredStyle: .Alert)
                        
                        //Create and an option action
                        let nextAction: UIAlertAction = UIAlertAction(title: "Rejouer ?", style: .Default) { action -> Void in
                            self.jeu.initialisation()
                            //self.loadGame()
                        }
                        actionSheetController.addAction(nextAction)
                        
                        //Create and an option action
                        let ChangeNameAction: UIAlertAction = UIAlertAction(title: "Revenir au menu", style: .Default) { action -> Void in
                            self.performSegueWithIdentifier("goLogin", sender: self)
                        }
                        actionSheetController.addAction(ChangeNameAction)
                        
                        //Present the AlertController
                        self.presentViewController(actionSheetController, animated: true, completion: nil)
                    }
                }
                for carte in self.jeu.liste_carte{
                    carte.viewGeneral?.userInteractionEnabled = true
                }
            }
        }
        else{
            jeu.choose_card.removeAll()
            jeu.versoAll()
        }
        
    }
    
    
    func startChrono(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.updateTime), userInfo: nil, repeats: true)
        self.startTime = NSDate.timeIntervalSinceReferenceDate()
    }
    
    func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= NSTimeInterval(seconds)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        stringTime =  "\(strMinutes):\(strSeconds)"
        timerText.text = stringTime
        
    }
}


