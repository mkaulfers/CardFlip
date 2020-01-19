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
        DispatchQueue.global(qos: .default).async {
            for card in self.cardsPhone
            {
                DispatchQueue.main.async {
                    self.flipCard(sender: card)
                }
                usleep(20000)
            }
        }
        cardsSelected = 0
        firstSelectedCard = UIImage()
        secondSelectedCard = UIImage()
        setCardView()
    }
    
    //MARK: - Play Logic
    var firstSelectedCard = UIImage()
    var secondSelectedCard = UIImage()
    var cardsSelected = 0
    
    @objc func playCard(_ sender: UITapGestureRecognizer)
    {
        
        
        print("Hit playCard")
        if let selectedCard = sender.view?.tag
        {
            if cardsSelected == 0
            {
                //INFO: Store first selection.
                firstSelectedCard = cardsImages[selectedCard]
                
                //INFO: Advance to next card.
                cardsSelected += 1
                
                flipCard(sender: cardsPhone[selectedCard])
            }
            else if cardsSelected == 1
            {
                //INFO: Store second selection.
                secondSelectedCard = cardsImages[selectedCard]
                
                //INFO: Check for match condition.
                if firstSelectedCard == secondSelectedCard
                {
                    print("Match")
                }
                else{
                    print("No match")
                }
                
                //INFO: Reset to a different attempt.
                cardsSelected = 0
                firstSelectedCard = UIImage()
                secondSelectedCard = UIImage()
                
                flipCard(sender: cardsPhone[selectedCard])
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
        sender.image = UIImage()
        UIView.transition(with: sender, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
}

