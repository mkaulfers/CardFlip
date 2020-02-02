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
    @IBOutlet var cardsPad: [UIImageView]!
    
    //INFO: Other UI Variables
    @IBOutlet weak var playButtonView: UIImageView!
    @IBOutlet weak var countdownTimer: UILabel!
    @IBOutlet var detailsView: UIView!
    @IBOutlet var gameWonPopup: UIView!
    
    //INFO: Static Variables
    var cardsImages: [UIImage] = [UIImage]()
    
    //INFO: Image Set Variable
    var imageSet = "r"
    
    //MARK: - Start of Main
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameWonPopup.isHidden = true
        
        detailsView.layer.cornerRadius = 15
        detailsView.clipsToBounds = true
        
        startBackgroundMusic()
        
        
        //INFO: Sort so we can properly match
        cardsPhone.sort(by: {$0.tag < $1.tag})
        cardsPad.sort(by: {$0.tag < $1.tag})
        
        //INFO: Set their view.
        
        setCardViewPhone()
        
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
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            cardsImages = Array(getImageSet(numOfImagesToReturn: 10))
            
            //INFO: Make sure that we have 2 copies of each card in the images.
            cardsImages += cardsImages
            cardsImages.shuffle()
            
            //INFO: Assign images from our selectedImagesArray to the cards.
            for (i, card) in cardsPhone.enumerated()
            {
                card.image = cardsImages[i]
            }
        }
        else
        {
            cardsImages = Array(getImageSet(numOfImagesToReturn: 15))
            
            //INFO: Make sure that we have 2 copies of each card in the images.
            cardsImages += cardsImages
            cardsImages.shuffle()
            
            //INFO: Assign images from our selectedImagesArray to the cards.
            for (i, card) in cardsPad.enumerated()
            {
                card.image = cardsImages[i]
            }
        }
    }
    
    fileprivate func addGesturetoCards()
    {
        
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            //INFO: Add GestureRecognizer to each card and round corners.
            for card in cardsPhone
            {
                card.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(playCard(_:))))
                card.layer.cornerRadius = 15
                card.clipsToBounds = true
            }
        }
        else
        {
            //INFO: Add GestureRecognizer to each card and round corners.
            for card in cardsPad
            {
                card.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(playCard(_:))))
                card.layer.cornerRadius = 15
                card.clipsToBounds = true
            }
        }
    }
    
    func allCardsInteractionDisabled()
    {
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            for card in cardsPhone
            {
                card.isUserInteractionEnabled = false
            }
        }
        else
        {
            for card in cardsPad
            {
                card.isUserInteractionEnabled = false
            }
        }
    }
    
    func allCardsInteractionEnabled()
    {
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            for card in cardsPhone
            {
                card.isUserInteractionEnabled = true
            }
        }
        else
        {
            for card in cardsPad
            {
                card.isUserInteractionEnabled = true
            }
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
        matchedCards = [UIImageView]()
        
        
        self.currentMatches = 0
        self.currentAttempts = 0
        
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            //INFO: Disable cards while viewing.
            for card in cardsPhone
            {
                setColorImage(viewToModify: card, colorToSet: UIColor(named: "BackgroundColor")!)
                card.isUserInteractionEnabled = false
                flipCard(sender: card)
            }
        }
        else
        {
            //INFO: Disable cards while viewing.
            for card in cardsPad
            {
                attemptsLabel.text = "0"
                matchesLabel.text = "0"
                
                setColorImage(viewToModify: card, colorToSet: UIColor(named: "BackgroundColor")!)
                card.isUserInteractionEnabled = false
                flipCard(sender: card)
            }
        }
        
        
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 5) {
            
            
            
            if UIDevice.current.userInterfaceIdiom == .phone
            {
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
                        //INFO: If not exclusive, then it will result in an "Index Out Of Bounds" error.
                        card.isExclusiveTouch = true
                    }
                    
                    //INFO: Enable play button after cards are hidden to prevent crashing layout.
                    self.playButtonView.isUserInteractionEnabled = true
                }
            }
            else
            {
                for card in self.cardsPad
                {
                    DispatchQueue.main.async {
                        self.flipCard(sender: card)
                    }
                    usleep(20000)
                }
                
                DispatchQueue.main.async{
                    //INFO: Enable cards after hidden.
                    for card in self.cardsPad
                    {
                        card.isUserInteractionEnabled = true
                        //INFO: If not exclusive, then it will result in an "Index Out Of Bounds" error.
                        card.isExclusiveTouch = true
                    }
                    
                    //INFO: Enable play button after cards are hidden to prevent crashing layout.
                    self.playButtonView.isUserInteractionEnabled = true
                }
            }
        }
        
        cardsSelected = 0
        firstSelectedCard = UIImage()
        secondSelectedCard = UIImage()
        //PICKUP HERE
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            for card in cardsPhone
            {
                card.isHidden = false
            }
        }
        else
        {
            for card in cardsPhone
            {
                card.isHidden = false
            }
        }
        
        setCardViewPhone()
    }
    
    //MARK: - Play Card
    var firstSelectedCard = UIImage()
    var firstSelectedCardIndex = 0
    var secondSelectedCard = UIImage()
    var secondSelectedCardIndex = 0
    var firstSelectedTag = -1
    var cardsSelected = 0
    
    //INFO: Additional Stat Tracking
    var currentMatches = 0
    var currentAttempts = 0
    @IBOutlet weak var matchesLabel: UILabel!
    @IBOutlet weak var attemptsLabel: UILabel!
    
    //INFO: Track Matched Cards and block any attempts to use them.
    var matchedCards = [UIImageView]()
    
    @objc func playCard(_ sender: UITapGestureRecognizer)
    {
        //INFO: Outside conditional to fix issue where user could re-select the card that is matched.
        if !matchedCards.contains(sender.view as! UIImageView)
        {
            if let selectedCard = sender.view?.tag
            {
                if UIDevice.current.userInterfaceIdiom == .phone
                {
                    flipCard(sender: cardsPhone[selectedCard])
                }
                else
                {
                    flipCard(sender: cardsPad[selectedCard])
                }
                
                cardFlipSound()
                
                if self.cardsSelected == 0
                {
                    //INFO: Save the index selected for future use.
                    firstSelectedCardIndex = selectedCard
                    
                    
                    
                    if UIDevice.current.userInterfaceIdiom == .phone
                    {
                        self.cardsPhone[selectedCard].image = self.cardsImages[selectedCard]
                    }
                    else
                    {
                        self.cardsPad[selectedCard].image = self.cardsImages[selectedCard]
                    }
                    
                    //INFO: Set the tag for future use.
                    self.firstSelectedTag = selectedCard
                    
                    if UIDevice.current.userInterfaceIdiom == .phone
                    {
                        //INFO: Disable use of the selected card.
                        self.cardsPhone[selectedCard].isUserInteractionEnabled = false
                    }
                    else
                    {
                        //INFO: Disable use of the selected card.
                        self.cardsPad[selectedCard].isUserInteractionEnabled = false
                    }
                    
                    //INFO: Store first selection.
                    self.firstSelectedCard = self.cardsImages[selectedCard]
                    
                    //INFO: Advance to next card.
                    self.cardsSelected += 1
                }
                else if self.cardsSelected == 1
                {
                    //INFO: Save the index selected for future use.
                    secondSelectedCardIndex = selectedCard
                    
                    
                    
                    if UIDevice.current.userInterfaceIdiom == .phone
                    {
                        self.cardsPhone[selectedCard].image = self.cardsImages[selectedCard]
                        self.cardsPhone[selectedCard].isUserInteractionEnabled = false
                    }
                    else
                    {
                        self.cardsPad[selectedCard].image = self.cardsImages[selectedCard]
                        self.cardsPad[selectedCard].isUserInteractionEnabled = false
                    }
                    
                    //INFO: Disable use of the selected card.
                    allCardsInteractionDisabled()
                    
                    //INFO: Store second selection.
                    self.secondSelectedCard = self.cardsImages[selectedCard]
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+1)
                    {
                        //INFO: Check for match condition.
                        if self.firstSelectedCard == self.secondSelectedCard
                        {
                            self.laserSound()
                            
                            //INFO: Add match counter
                            self.currentMatches += 1
                            self.matchesLabel.text = "\(self.currentMatches)"
                            
                            if UIDevice.current.userInterfaceIdiom == .phone
                            {
                                self.setColorImage(viewToModify: self.cardsPhone[self.firstSelectedTag], colorToSet: UIColor.clear)
                                self.setColorImage(viewToModify: self.cardsPhone[selectedCard], colorToSet: UIColor.clear)
                                
                                self.matchedCards.append(self.cardsPhone[self.firstSelectedCardIndex])
                                self.matchedCards.append(self.cardsPhone[self.secondSelectedCardIndex])
                            }
                            else
                            {
                                self.setColorImage(viewToModify: self.cardsPad[self.firstSelectedTag], colorToSet: UIColor.clear)
                                self.setColorImage(viewToModify: self.cardsPad[selectedCard], colorToSet: UIColor.clear)
                                
                                self.matchedCards.append(self.cardsPad[self.firstSelectedCardIndex])
                                self.matchedCards.append(self.cardsPad[self.secondSelectedCardIndex])
                            }
                        }
                        else{
                            //INFO: Add attempts counter.
                            self.currentAttempts += 1
                            self.attemptsLabel.text = "\(self.currentAttempts)"
                            
                            if UIDevice.current.userInterfaceIdiom == .phone
                            {
                                //INFO: Re-enable selection because no match.
                                self.cardsPhone[self.firstSelectedTag].isUserInteractionEnabled = true
                                self.cardsPhone[selectedCard].isUserInteractionEnabled = true
                                
                                //INFO: Flip them back over.
                                self.flipCard(sender: self.cardsPhone[self.firstSelectedTag])
                                self.flipCard(sender: self.cardsPhone[selectedCard])
                            }
                            else
                            {
                                //INFO: Re-enable selection because no match.
                                self.cardsPad[self.firstSelectedTag].isUserInteractionEnabled = true
                                self.cardsPad[selectedCard].isUserInteractionEnabled = true
                                
                                //INFO: Flip them back over.
                                self.flipCard(sender: self.cardsPad[self.firstSelectedTag])
                                self.flipCard(sender: self.cardsPad[selectedCard])
                            }
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
    }
    
    //MARK: - Game Stats
    
    var minutes = 0
    var seconds = -5
    var currentTime: Timer?
    var timerIsRunning = false
    
    //INFO: Landscape variables.
    @IBOutlet weak var landscapeTimerCounter: UILabel!
    @IBOutlet weak var landscapeTimeLabel: UILabel!
    
    func startTimer()
    {
        currentTime = nil
        currentTime = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self ] (_) in
            
            guard let strongSelf = self else { return }
            
            strongSelf.seconds += 1
            
            if strongSelf.seconds == 60 {strongSelf.minutes += 1; strongSelf.seconds = 0}
            
            if strongSelf.seconds < 0
            {
                strongSelf.countdownTimer.text = "Start In: \(strongSelf.seconds)"
                strongSelf.landscapeTimeLabel.text = "Start In"
                strongSelf.landscapeTimerCounter.text = "\(strongSelf.seconds)"
            }
            else
            {
                strongSelf.countdownTimer.text = "Time: \(String(format: "%02d:%02d", strongSelf.minutes, strongSelf.seconds))"
                strongSelf.landscapeTimeLabel.text = "Time"
                strongSelf.landscapeTimerCounter.text = "\(String(format: "%02d:%02d", strongSelf.minutes, strongSelf.seconds))"
            }
        })
    }
    
    func stopTimer()
    {
        currentTime?.invalidate()
        currentTime = nil
        minutes = 0
        seconds = -5
    }
    
    //MARK: - Game Won
    //INFO: Variables to hold game won stats.
    var currentLeaderBoard = [HighScore]()
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var currentAttemptsLabel: UILabel!
    @IBOutlet var currentMatchesLabel: UILabel!
    
    
    func isGameWon()
    {
        if (currentMatches == 10 && UIDevice.current.userInterfaceIdiom == .phone) || (currentMatches == 15 && UIDevice.current.userInterfaceIdiom == .pad)
        {
            
            gameWonPopup.isHidden = false
            
            timeLabel.text = "\(String(format: "%02d:%02d", minutes, seconds))"
            
            currentMatchesLabel.text = currentMatches.description
            currentAttemptsLabel.text = currentAttempts.description
            
            currentTime?.invalidate()
            
            if UIDevice.current.userInterfaceIdiom == .phone
            {
                //INFO: Show all the matches from previous game.
                //BUG: They don't show properly at end of the game.
                for card in cardsPhone
                {
                    popIn(sender: card)
                    card.isHidden = false
                }
            }
            else
            {
                //INFO: Show all the matches from previous game.
                //BUG: They don't show properly at end of the game.
                for card in cardsPad
                {
                    popIn(sender: card)
                    card.isHidden = false
                }
            }
            allCardsInteractionDisabled()
        }
        else
        {
            allCardsInteractionEnabled()
        }
        
        
    }
    
    @IBOutlet var playersName: UITextField!
    
    @IBAction func addToHighScore(_ sender: Any) {
        currentLeaderBoard.append(HighScore(playerName: playersName.text ?? "Unknown", playerTime: timeLabel.text!, playerMatches: Int(currentMatchesLabel.text!)!, playerAttempts: Int(currentAttemptsLabel.text!)!))
        gameWonPopup.isHidden = true
    }
    
    @IBAction func cancelHighScore(_ sender: Any) {
        gameWonPopup.isHidden = true
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
    
    func setColorImage(viewToModify: UIImageView, colorToSet: UIColor)
    {
        let rect = CGRect(origin: .zero, size: viewToModify.layer.bounds.size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        colorToSet.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard (image?.cgImage) != nil else { return }
        viewToModify.image = image
        viewToModify.backgroundColor = colorToSet
        viewToModify.isUserInteractionEnabled = false
    }
    
    //MARK: - Animations
    func flipCard(sender: UIImageView)
    {
        playButtonView.isUserInteractionEnabled = false
        
        //INFO: If there is no UIImage, assign the appropriate image from the array.
        if sender.image == nil
        {
            sender.image = cardsImages[sender.tag]
            UIView.transition(with: sender, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
            //INFO: If there is an image, remove it and replace with no Image.
        else
        {
            let rect = CGRect(origin: .zero, size: sender.layer.bounds.size)
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
            UIColor.init(named: "BackgroundColor")?.setFill()
            UIRectFill(rect)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            guard let cgImage = image?.cgImage else { return }
            
            //BUG: Line of code causes views to disappear on new play.
            sender.image = UIImage(cgImage: cgImage)
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
    
    //MARK: - Segue's and Control
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? Leaderboard
        destination?.currentHighScores = currentLeaderBoard
    }
    
    //MARK: - Audio
    var backgroundMusic: AVAudioPlayer!
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
    
    var playButton: AVAudioPlayer!
    func playButtonSound()
    {
        let path = Bundle.main.path(forResource: "buttonHit", ofType:"mp3")
        
        do {
            
            playButton = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.mixWithOthers])
            
        } catch{
            print("Button sound did not load.")
        }
        playButton.volume = 0.5
        playButton.play()
    }
    
    var cardFlip: AVAudioPlayer!
    func cardFlipSound()
    {
        let path = Bundle.main.path(forResource: "cardFlip", ofType:"wav")
        
        do {
            
            cardFlip = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.mixWithOthers])
            
        } catch{
            print("Card sound did not load.")
        }
        cardFlip.volume = 1
        
        DispatchQueue.main.async {
            self.cardFlip.play()
        }
    }
    
    var matchCard: AVAudioPlayer!
    func laserSound()
    {
        let path = Bundle.main.path(forResource: "laserSound", ofType:"wav")
        
        do {
            
            matchCard = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.mixWithOthers])
            
        } catch{
            print("Card sound did not load.")
        }
        matchCard.volume = 0.5
        
        DispatchQueue.main.async {
            self.matchCard.play()
        }
    }
}

