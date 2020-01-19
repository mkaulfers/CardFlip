//
//  ViewController.swift
//  CardFlip
//
//  Created by Matthew Kaulfers on 1/17/20.
//  Copyright © 2020 Matthew Kaulfers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Variables
    //INFO: Cards

    
    //INFO: Other UI Variables
    @IBOutlet weak var playButtonView: UIImageView!
    @IBOutlet weak var cardTypeSelection: UISegmentedControl!
    
    //INFO: Static Variables
    var cards: [UIImageView] = [UIImageView]()
    
    //MARK: - Start of Main
    override func viewDidLoad() {
        super.viewDidLoad()
        setCardView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setCardView()
    }
    
    //MARK: - Setup Methods
    
    func setCardView()
    {
        var randomSelection = [Int.random(in: 0...1), Int.random(in: 2...3),Int.random(in: 4...5),Int.random(in: 6...7),Int.random(in: 8...9),Int.random(in: 10...11),Int.random(in: 12...13),Int.random(in: 14...15),Int.random(in: 16...17),Int.random(in: 18...19)]
        
        randomSelection.shuffle()
        
        for i in 0...9
        {
            cards[i].image = UIImage(named: "r\(randomSelection[i])")
            cards[i+10].image = UIImage(named: "r\(randomSelection[i])")
        }
    }
    
    //MARK: - Custom Methods
    @IBAction func playButtonPressed()
    {
        setCardView()
        
//        UIImageView.animate(withDuration: 0.5,  animations: {
//            self.playButtonView.center = CGPoint(x: self.playButtonView.center.x, y: self.playButtonView.center.y + 15)
//
//        })
    }
    
    //MARK: - GestureRecognizer Actions
    
    
    //MARK: - Play Logic
    var firstSelectedCard = UIImageView()
    var secondSelectedCard = UIImageView()
    var cardsSelected = 0
    
    func playCard(card: UIImageView)
    {
        cardsSelected += 1
        
        switch cardsSelected
        {
        case 1:
            firstSelectedCard = card
        case 2:
            secondSelectedCard = card
        default:
            cardsSelected = 0
        }
        
        if cardsSelected == 2
        {
            if firstSelectedCard.image == secondSelectedCard.image
            {
                
            }
            else
            {
                
            }
        }
    }
    
    
}

