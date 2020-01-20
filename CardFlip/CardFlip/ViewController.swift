//
//  ViewController.swift
//  CardFlip
//
//  Created by Matthew Kaulfers on 1/17/20.
//  Copyright © 2020 Matthew Kaulfers. All rights reserved.
//

import UIKit
import AVFoundation

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
        
        
        startBackgroundMusic()
        
        
        //INFO: Sort so we can properly match
        cardsPhone.sort(by: {$0.tag < $1.tag})
        
        //INFO: Set their view.
        
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            setCardViewPhone()
        }
        else
        {
            print("You're on something else. ")
        }
        
        //INFO: Disable all buttons.
        allCardsInteractionDisabled()
    }
    
    //MARK: - Setup And Control Methods
    
    func getImageSet(numOfImagesToReturn: Int) -> Set<UIImage>
    {
        //INFO: Create a set, they cannot contain duplicates.
        var selectedImages = Set<UIImage>()
        
        //INFO: Loop through adding random images until we reach a count of 10
        while selectedImages.count < numOfImagesToReturn
        {
            selectedImages.insert(UIImage(named: "\(imageSet)\(Int.random(in: 0...19))")!)
        }
        
        return selectedImages
    }
    
    func setCardViewPhone()
    {
        addGesturetoCards()
        //INFO: Convert set to an array, then shuffle.
        
        var numOfImagesToReturn = 0
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            numOfImagesToReturn = 10
        }
        else
        {
            numOfImagesToReturn = 15
        }
        
        cardsImages = Array(getImageSet(numOfImagesToReturn: numOfImagesToReturn))
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
    
    //MARK: - Play Button
    @IBOutlet weak var selectIconsControl: UISegmentedControl!
    
    @IBAction func playButtonPressed()
    {
        playButtonView.isUserInteractionEnabled = false
        stopTimer()
        startTimer()
        cardImageSetChanged(selectIconsControl)
        playButtonView.image = UIImage(named: "ReplayButton")
        buttonPressedAnimation(sender: playButtonView)
        
        
        self.currentMatches = 0
        self.currentAttempts = 0
        
        //INFO: Disable cards while viewing.
        for card in cardsPhone
        {
            card.isUserInteractionEnabled = false
            flipCard(sender: card)
        }
        
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 5) {
            
            for card in self.cardsPhone
            {
                DispatchQueue.main.async {
                    self.flipCard(sender: card)
                }
                usleep(20000)
            }
            DispatchQueue.main.sync{
                //INFO: Enable cards after hidden.
                for card in self.cardsPhone
                {
                    card.isUserInteractionEnabled = true
                }
                
                //INFO: Enable play button after cards are hidden to prevent crashing layout.
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
        
        setCardViewPhone()
    }
    
    //MARK: - Play Card
    var firstSelectedCard = UIImage()
    var secondSelectedCard = UIImage()
    var firstSelectedTag = -1
    var cardsSelected = 0
    
    //INFO: Additional Stat Tracking
    var currentMatches = 0
    var currentAttempts = 0
    @IBOutlet weak var matchesLabel: UILabel!
    @IBOutlet weak var attemptsLabel: UILabel!
    
    @objc func playCard(_ sender: UITapGestureRecognizer)
    {
        if let selectedCard = sender.view?.tag
        {
            flipCard(sender: cardsPhone[selectedCard])
            
            DispatchQueue.main.async {
                self.cardFlipSound()
            }
            
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
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1)
                {
                    //INFO: Check for match condition.
                    if self.firstSelectedCard == self.secondSelectedCard
                    {
                        //INFO: Add match counter
                        self.currentMatches += 1
                        self.matchesLabel.text = "Matches  \(self.currentMatches)"
                        
                        self.cardsPhone[self.firstSelectedTag].isHidden = true
                        self.cardsPhone[selectedCard].isHidden = true
                    }
                    else{
                        //INFO: Add attempts counter.
                        self.currentAttempts += 1
                        self.attemptsLabel.text = "Attempts  \(self.currentAttempts)"
                        
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
    var milliseconds = 0
    var currentTime = Timer()
    var timerIsRunning = false
    
    func startTimer()
    {
        currentTime = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: {[weak self ] (_) in
            
            guard let strongSelf = self else { return }
            
            strongSelf.milliseconds += 1
            if strongSelf.milliseconds == 100 { strongSelf.seconds += 1; strongSelf.milliseconds = 0 }
            else if strongSelf.seconds == 60 {strongSelf.minutes += 1; strongSelf.seconds = 0}
            
            if strongSelf.seconds < 0
            {
                strongSelf.countdownTimer.text = "Start In: \(strongSelf.seconds)"
            }
            else
            {
                strongSelf.countdownTimer.text = "Time: \(String(format: "%02d:%02d:%02d", strongSelf.minutes, strongSelf.seconds, strongSelf.milliseconds))"
            }
        })
    }
    
    func stopTimer()
    {
        currentTime.invalidate()
        minutes = 0
        seconds = -5
        milliseconds = 0
    }
    
    func isGameWon()
    {
        if currentMatches == 10
        {
            
            let alert = UIAlertController(title: "You Won!", message: "Time: \(String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds)) Matches:\(currentMatches) Attempts: \(currentAttempts)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
                self.playButtonView.image = UIImage(named: "PlayButton")
            }))
            
            
            currentTime.invalidate()
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
            imageSet = "h"
        case 4:
            let possibleSets = ["r", "k", "m", "h"]
            imageSet = possibleSets[Int.random(in: 0...3)]
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
    }
    
    func popIn(sender: UIImageView)
    {
        UIView.transition(with: sender, duration: 0.5, options: .transitionCurlDown, animations: nil, completion: nil)
    }
    
    func buttonPressedAnimation(sender: UIImageView)
    {
        DispatchQueue.main.async {
            self.playButtonSound()
        }
        
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
    
    //MARK: - Audio
    var backgroundMusic = AVAudioPlayer()
    func startBackgroundMusic()
    {
        let path = Bundle.main.path(forResource: "backgroundJam", ofType:"mp3")
        
        do {
            
            backgroundMusic = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient, mode: AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.duckOthers])
            
        } catch{
            print("Background music did not load.")
        }
        backgroundMusic.numberOfLoops = -1
        backgroundMusic.volume = 1
        backgroundMusic.play()
    }
    
    var playButton = AVAudioPlayer()
    func playButtonSound()
    {
        let path = Bundle.main.path(forResource: "buttonHit", ofType:"mp3")
        
        do {
            
            playButton = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.mixWithOthers])
            
        } catch{
            print("Button sound did not load.")
        }
        playButton.volume = 0.2
        playButton.play()
    }
    
    var cardFlip = AVAudioPlayer()
    func cardFlipSound()
    {
        let path = Bundle.main.path(forResource: "cardFlip", ofType:"wav")
        
        do {
            
            playButton = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.mixWithOthers])
            
        } catch{
            print("Card sound did not load.")
        }
        cardFlip.volume = 5
        cardFlip.play()
    }
}

