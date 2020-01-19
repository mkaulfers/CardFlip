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
    @IBOutlet weak var card1View: UIImageView!
    @IBOutlet weak var card2View: UIImageView!
    @IBOutlet weak var card3View: UIImageView!
    @IBOutlet weak var card4View: UIImageView!
    @IBOutlet weak var card5View: UIImageView!
    @IBOutlet weak var card6View: UIImageView!
    @IBOutlet weak var card7View: UIImageView!
    @IBOutlet weak var card8View: UIImageView!
    @IBOutlet weak var card9View: UIImageView!
    @IBOutlet weak var card10View: UIImageView!
    @IBOutlet weak var card11View: UIImageView!
    @IBOutlet weak var card12View: UIImageView!
    @IBOutlet weak var card13View: UIImageView!
    @IBOutlet weak var card14View: UIImageView!
    @IBOutlet weak var card15View: UIImageView!
    @IBOutlet weak var card16View: UIImageView!
    @IBOutlet weak var card17View: UIImageView!
    @IBOutlet weak var card18View: UIImageView!
    @IBOutlet weak var card19View: UIImageView!
    @IBOutlet weak var card20View: UIImageView!
    
    //INFO: Other UI Variables
    @IBOutlet weak var playButtonView: UIImageView!
    @IBOutlet weak var cardTypeSelection: UISegmentedControl!
    
    //INFO: Static Variables
    var cards: [UIImageView] = [UIImageView]()
    
    //MARK: - Start of Main
    override func viewDidLoad() {
        super.viewDidLoad()
        addCardsToArray()
        setCardView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setCardView()
    }
    
    //MARK: - Setup Methods
    //INFO: Prepare cards into an array.
    func addCardsToArray()
    {
        cards.append(card1View)
        cards.append(card2View)
        cards.append(card3View)
        cards.append(card4View)
        cards.append(card5View)
        cards.append(card6View)
        cards.append(card7View)
        cards.append(card8View)
        cards.append(card9View)
        cards.append(card10View)
        cards.append(card11View)
        cards.append(card12View)
        cards.append(card13View)
        cards.append(card14View)
        cards.append(card15View)
        cards.append(card16View)
        cards.append(card17View)
        cards.append(card18View)
        cards.append(card19View)
        cards.append(card20View)
    }
    
    func setCardView()
    {
        for (i, card) in cards.enumerated()
        {
            card.image = UIImage(named: "r\(i+1)")
        }
    }
    
    //MARK: - Custom Methods
    @IBAction func playButtonPressed()
    {
        setCardView()
        
        UIImageView.animate(withDuration: 0.5,  animations: {
            self.playButtonView.center = CGPoint(x: self.playButtonView.center.x, y: self.playButtonView.center.y + 15)
            
        })
    }
    
    //MARK: - GestureRecognizer Actions
    @IBAction func card1Selected(_ sender: Any) {
    }
    
    @IBAction func card2Selected(_ sender: Any) {
    }
    
    @IBAction func card3Selected(_ sender: Any) {
    }
    
    @IBAction func card4Selected(_ sender: Any) {
    }
    
    @IBAction func card5Selected(_ sender: Any) {
    }
    
    @IBAction func card6Selected(_ sender: Any) {
    }
    
    @IBAction func card7Selected(_ sender: Any) {
    }
    
    @IBAction func card8Selected(_ sender: Any) {
    }
    
    @IBAction func card9Selected(_ sender: Any) {
    }
    
    @IBAction func card10Selected(_ sender: Any) {
    }
    
    @IBAction func card11Selected(_ sender: Any) {
    }
    
    @IBAction func card12Selected(_ sender: Any) {
    }
    
    @IBAction func card13Selected(_ sender: Any) {
    }
    
    @IBAction func card14Selected(_ sender: Any) {
    }
    
    @IBAction func card15Selected(_ sender: Any) {
    }
    
    @IBAction func card16Selected(_ sender: Any) {
    }
    
    @IBAction func card17Selected(_ sender: Any) {
    }
    
    @IBAction func card18Selected(_ sender: Any) {
    }
    
    @IBAction func card19Selected(_ sender: Any) {
    }
    
    @IBAction func card20Selected(_ sender: Any) {
    }
    
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

