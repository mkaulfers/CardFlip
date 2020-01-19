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
    @IBOutlet weak var countdownTimer: UILabel!
    
    //INFO: Static Variables
    var cardsImages: [UIImage] = [UIImage]()
    
    //INFO: Image Set Variable
    var imageSet = "r"
    
    //MARK: - Start of Main
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //INFO: Sort so we can properly match
        cardsPhone.sort(by: {$0.tag < $1.tag})
        
        //INFO: Set their view.
        setCardView()
        
        //INFO: Disable all buttons.
        allCardsInteractionDisabled()
    }
    
    //MARK: - Setup And Control Methods
    
    
    func setCardView()
    {
        addGesturetoCards()
        
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
    
    fileprivate func addGesturetoCards()
    {
        //INFO: Add GestureRecognizer to each card and round corners.
        for card in cardsPhone
        {
            card.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(playCard(_:))))
            card.layer.cornerRadius = 15
            card.clipsToBounds = true
        }
    }
    
    func allCardsInteractionDisabled()
    {
        for card in cardsPhone
        {
            card.isUserInteractionEnabled = false
        }
    }
    
    func allCardsInteractionEnabled()
    {
        for card in cardsPhone
        {
            card.isUserInteractionEnabled = true
        }
    }
    
    //MARK: - Custom Methods
    var currentMatches = 0
    var currentPlays = 0
    
    @IBAction func playButtonPressed()
    {
        startTimer()
        playButtonView.image = UIImage(named: "ReplayButton")
        buttonPressedAnimation(sender: playButtonView)
        
        self.currentMatches = 0
        self.currentPlays = 0
        
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
                allCardsInteractionDisabled()
                
                //INFO: Store second selection.
                self.secondSelectedCard = self.cardsImages[selectedCard]
                
                self.playButtonView.isUserInteractionEnabled = false
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1)
                {
                    //INFO: Check for match condition.
                    if self.firstSelectedCard == self.secondSelectedCard
                    {
                        //INFO: Add match counter
                        self.currentMatches += 1
                        self.cardsPhone[self.firstSelectedTag].isHidden = true
                        self.cardsPhone[selectedCard].isHidden = true
                    }
                    else{
                        self.currentPlays += 1
                        
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
                    
                    self.isGameWon()
                    
                    self.playButtonView.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    //MARK: - Game Stats
    
    var minutes = 0
    var seconds = -5
    var currentTime = Timer()
    var timerIsRunning = false
    
    func startTimer()
    {
        currentTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer()
    {
        currentTime.invalidate()
        seconds = 0
    }
    
    @objc func updateTimer()
    {
        seconds += 1
        countdownTimer.text = "Time: \(currentTime.timeInterval.stringFromTimeInterval().minutes):\(currentTime.timeInterval.stringFromTimeInterval().milliseconds).\(currentTime.timeInterval.stringFromTimeInterval().milliseconds)"
    }
    
    func isGameWon()
    {
        print(currentMatches)
        if currentMatches == 10
        {
            print("Game won")
            let alert = UIAlertController(title: "You Won!", message: "Time: 0:00.000", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
                self.playButtonView.image = UIImage(named: "PlayButton")
            }))
            self.present(alert, animated: true, completion: nil)
            
            //INFO: Show all the matches from previous game.
            for card in cardsPhone
            {
                popIn(sender: card)
                card.isHidden = false
            }
            allCardsInteractionDisabled()
        }
        else
        {
            allCardsInteractionEnabled()
        }
    }
    
    //MARK: - User Options
    
    //INFO: Segmented Control
    @IBOutlet weak var cardTypeSelection: UISegmentedControl!
    
    //TODO: Imageset 4 needs to be implemented.
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
    
    func popIn(sender: UIImageView)
    {
        UIView.transition(with: sender, duration: 0.5, options: .transitionCurlDown, animations: nil, completion: nil)
    }
    
    func buttonPressedAnimation(sender: UIImageView)
    {
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(5.0),
                       
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
    }
}

//MARK: - Extensions
extension TimeInterval{
    
    func stringFromTimeInterval() -> (minutes: String, seconds: String, milliseconds: String) {
        
        let time = NSInteger(self)
        
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        
        return (String(minutes), String(seconds), String(ms))
        
    }
}

