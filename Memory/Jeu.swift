//
//  Jeu.swift
//  Memory
//
//  Created by etudiant on 29/02/2016.
//  Copyright © 2016 achevallier. All rights reserved.
//

import Foundation
import UIKit

class Jeu {
    let transitionOptions = UIViewAnimationOptions.TransitionFlipFromLeft
    //static let sharedInstance = Jeu()
    
    let nbCartes: Int!
    var started = false
    var liste_carte = [Carte]()
    var liste_carte_already_unpaired = [Carte]()
    var liste_image = [String]()
    var view : UIView
    var controller : ViewController
    
    var choose_card = [Carte]()
    
    var taille = 1.0
    
    var nbCoups:Int! = 2
    var score:Int = 0
    
    var tailleCarteX:Double = 150.0
    var tailleCarteY:Double = 200.0
    
    init(controller : ViewController, viewCards : UIView, nbCartes : Int){
        self.controller = controller
        self.nbCartes = nbCartes
        self.view = viewCards
        initialisation()
    }
    init(controller : ViewController, viewCards : UIView){
        self.controller = controller
        self.view = viewCards
        self.nbCartes = 6
        initialisation()
    }
    
    func  matchTwoCards(card1 : Carte, card2: Carte) -> Bool{
        if(card1.id == card2.pair){
            return true
        }
        return false
    }


    func initialisation(){
        liste_image = ["1","2","3","4","5","6","7","8"]
        liste_carte.removeAll()
        liste_carte_already_unpaired.removeAll()
        score = 0
        
        for index in 0 ..< nbCartes{
            let carte = Carte(id: index)
            self.liste_carte.append(carte)
            self.liste_carte_already_unpaired.append(carte)
        }
        for _ in 0 ..< (liste_carte.count/2){
            let randomIndex1 = Int(arc4random_uniform(UInt32(liste_carte_already_unpaired.count)))
            let carte1 = liste_carte_already_unpaired[randomIndex1].id
            self.liste_carte_already_unpaired.removeAtIndex(randomIndex1)
        
            let randomIndex2 = Int(arc4random_uniform(UInt32(liste_carte_already_unpaired.count)))
            let carte2 = liste_carte_already_unpaired[randomIndex2].id
            self.liste_carte_already_unpaired.removeAtIndex(randomIndex2)
        
            let imageRandom = Int(arc4random_uniform(UInt32(liste_image.count)))
        
            liste_carte[carte1].pair = carte2
            liste_carte[carte1].image = liste_image[imageRandom]
        
            liste_carte[carte2].pair = carte1
            liste_carte[carte2].image = liste_image[imageRandom]
        
            self.liste_image.removeAtIndex(imageRandom)
        }
        
        view.subviews.forEach({ $0.removeFromSuperview() })
        //let jeu = Jeu.sharedInstance
        
        var w = 0
        var first = true
        
        
        if(self.nbCartes == 16 || self.nbCartes == 12){
            taille = 0.75
        }
        else
        {
            taille = 1.0
        }
        
        let X = 17.0
        let Y = 15.0
        var imageX:CGFloat = CGFloat(X * taille)
        var imageY:CGFloat = CGFloat(Y * taille)
        let translationX:CGFloat = CGFloat(160.0 * taille)
        let translationY:CGFloat = CGFloat(220.0 * taille)
        
        for card in self.liste_carte{
            if(self.nbCartes == 16 || self.nbCartes == 12){
                
                if(w%4 == 0 && !first){
                    imageY = imageY + translationY
                    imageX = CGFloat(X * taille)
                }
            }
            else{
                if(w%3 == 0 && !first){
                    imageY = imageY + translationY
                    imageX = CGFloat(X * taille)
                }
            }
            
            //View general
            let viewCard :UIView
            viewCard = UIView(frame:CGRectMake(imageX, imageY, CGFloat(self.tailleCarteX * taille), CGFloat(self.tailleCarteY * taille)));
            
            card.viewGeneral = viewCard
            
            //viewVerso
            var verso:String = "verso.png"
            let defaults = NSUserDefaults.standardUserDefaults()
            if(defaults.objectForKey("verso") != nil){
                verso = defaults.objectForKey("verso") as! String
            }
            
            let viewCardVerso :UIView
            viewCardVerso = UIView(frame:CGRectMake(0, 0, CGFloat(self.tailleCarteX * taille), CGFloat(self.tailleCarteY * taille)));
            
            let imageViewBackgroundVerso = UIImageView(frame: CGRectMake(0, 0, CGFloat(self.tailleCarteX * taille), CGFloat(self.tailleCarteY * taille)))
            imageViewBackgroundVerso.image = UIImage(named: verso)
            viewCardVerso.addSubview(imageViewBackgroundVerso)
            
            card.viewVerso = viewCardVerso
            
            //viewPile
            let viewCardPile :UIView
            viewCardPile = UIView(frame:CGRectMake(0, 0, CGFloat(self.tailleCarteX * taille), CGFloat(self.tailleCarteY * taille)));
            
            let imageViewBackgroundPile = UIImageView(frame: CGRectMake(0, 0, CGFloat(self.tailleCarteX * taille), CGFloat(self.tailleCarteY * taille)))
            imageViewBackgroundPile.image = UIImage(named: card.image!+".jpg")
            viewCardPile.addSubview(imageViewBackgroundPile)
            
            card.viewPile = viewCardPile
            
            //
            card.viewGeneral!.addSubview(viewCardVerso)
            
           
            view.addSubview(viewCard)
            
            //
            imageX = imageX + translationX
            
            self.nbCoups = 2
            
            viewCard.userInteractionEnabled = true
            let tapRecognizer = UITapGestureRecognizer(target: controller, action: "imageTapped:")
            //Add the recognizer to your view.
            viewCard.addGestureRecognizer(tapRecognizer)
            
            first = false
            w += 1
        }

    }
    
    func checkJeuFini() -> Bool
    {
        var cartesDecouvert = [Bool]()
        for carte in liste_carte{
            if(carte.decouvert == true){
                cartesDecouvert.append(true)
            }
        }
        if(cartesDecouvert.count == nbCartes){
            return true
        }
        return false
        
    }
    
    
    func versoAll(){
        for card in liste_carte{
            if(card.decouvert == true){
                UIView.transitionFromView( card.viewPile!, toView: card.viewVerso!, duration: 0.5, options: self.transitionOptions, completion: nil)
            }
        }
    }
}