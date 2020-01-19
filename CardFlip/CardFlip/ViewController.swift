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
    @IBOutlet var cardsPhone: [UIImageView]!
    
    //INFO: Other UI Variables
    @IBOutlet weak var playButtonView: UIImageView!
    @IBOutlet weak var cardTypeSelection: UISegmentedControl!
    @IBOutlet weak var countdownTimer: UILabel!
    
    //INFO: Static Variables
    var cardsImages: [UIImage] = [UIImage]()
    
    //INFO: Image Set Variable
    var imageSet = "r"
    
    //MARK: - Start of Main
    override func viewDidLoad() {
        super.viewDidLoad()
        cardsPhone.sort(by: {$0.tag < $1.tag})
        setCardView()
    }
    
    //MARK: - Setup Methods
    func setCardView()
    {
        //INFO: Add GestureRecognizer to each card
        for card in cardsPhone
        {
            card.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(playCard(_:))))
            card.layer.cornerRadius = 15
            card.clipsToBounds = true
        }
        
        //INFO: Create a set, they cannot contain duplicates.
        var selectedImages = Set<UIImage>()
        
        //INFO: Loop through adding random images until we reach a count of 10
        while selectedImages.count < 10
        {
            selectedImages.insert(UIImage(named: "\(imageSet)\(Int.random(in: 0...19))")!)
        }
        
        //INFO: Convert set to an array, then shuffle.
        cardsImages = Array(selectedImages)
        cardsImages += cardsImages
        cardsImages.shuffle()
        
        //INFO: Assign images from our selectedImagesArray to the cards.
        for (i, card) in cardsPhone.enumerated()
        {
            card.image = cardsImages[i]
        }
    }
    
    //MARK: - Custom Methods
    @IBAction func playButtonPressed()
    {
        //INFO: Disable cards while viewing.
        for card in cardsPhone
        {
            card.isUserInteractionEnabled = false
            flipCard(sender: card)
        }
        
        playButtonView.isUserInteractionEnabled = false
        
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 5) {
            for card in self.cardsPhone
            {
                DispatchQueue.main.async {
                    self.flipCard(sender: card)
                }
                usleep(20000)
            }
            DispatchQueue.main.async{
                
                
                //INFO: Enable cards after hidden.
                for card in self.cardsPhone
                {
                    card.isUserInteractionEnabled = true
                }
                self.playButtonView.isUserInteractionEnabled = true
            }
            
            
        }
        
        cardsSelected = 0
        firstSelectedCard = UIImage()
        secondSelectedCard = UIImage()
        
        for card in cardsPhone
        {
            card.isHidden = false
        }
        
        setCardView()
    }
    
    //MARK: - Play Logic
    var firstSelectedCard = UIImage()
    var secondSelectedCard = UIImage()
    var firstSelectedTag = -1
    var cardsSelected = 0
    
    @objc func playCard(_ sender: UITapGestureRecognizer)
    {
        print("Hit playCard")
        if let selectedCard = sender.view?.tag
        {
            flipCard(sender: cardsPhone[selectedCard])
            
            
            if self.cardsSelected == 0
            {
                //INFO: Set the tag for future use.
                self.firstSelectedTag = selectedCard
                
                //INFO: Disable use of the selected card.
                self.cardsPhone[selectedCard].isUserInteractionEnabled = false
                
                //INFO: Store first selection.
                self.firstSelectedCard = self.cardsImages[selectedCard]
                
                //INFO: Advance to next card.
                self.cardsSelected += 1
            }
            else if self.cardsSelected == 1
            {
                //INFO: Disable use of the selected card.
                for card in self.cardsPhone
                {
                    card.isUserInteractionEnabled = false
                }
                
                //INFO: Store second selection.
                self.secondSelectedCard = self.cardsImages[selectedCard]
                
                self.playButtonView.isUserInteractionEnabled = false
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1)
                {
                    //INFO: Check for match condition.
                    if self.firstSelectedCard == self.secondSelectedCard
                    {
                        
                        self.cardsPhone[self.firstSelectedTag].isHidden = true
                        self.cardsPhone[selectedCard].isHidden = true
                        
                    }
                    else{
                        print("No match")
                        
                        //INFO: Re-enable selection because no match.
                        self.cardsPhone[self.firstSelectedTag].isUserInteractionEnabled = true
                        self.cardsPhone[selectedCard].isUserInteractionEnabled = true
                        
                        //INFO: Flip them back over.
                        self.flipCard(sender: self.cardsPhone[self.firstSelectedTag])
                        self.flipCard(sender: self.cardsPhone[selectedCard])
                    }
                    
                    //INFO: Reset to a different attempt.
                    self.firstSelectedTag = -1
                    self.cardsSelected = 0
                    self.firstSelectedCard = UIImage()
                    self.secondSelectedCard = UIImage()
                    for card in self.cardsPhone
                    {
                        card.isUserInteractionEnabled = true
                        self.playButtonView.isUserInteractionEnabled = true
                    }
                }
            }
        }
    }
    
    //MARK: - User Options
    
    @IBAction func cardImageSetChanged(_ sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex {
        case 0:
            imageSet = "r"
        case 1:
            imageSet = "k"
        case 2:
            imageSet = "m"
        case 3:
            imageSet = "p"
        case 4:
            imageSet = "g"
        default:
            print("This should never happen...")
        }
    }
    
    //MARK: - Animations
    func flipCard(sender: UIImageView)
    {
        playButtonView.isUserInteractionEnabled = false
        if sender.image == UIImage()
        {
            sender.image = cardsImages[sender.tag]
            UIView.transition(with: sender, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
        else
        {
            sender.image = UIImage()
            UIView.transition(with: sender, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
        playButtonView.isUserInteractionEnabled = true
    }
}

