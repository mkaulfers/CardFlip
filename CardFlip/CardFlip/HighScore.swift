//
//  HighScore.swift
//  CardFlip
//
//  Created by Matthew Kaulfers on 2/2/20.
//  Copyright © 2020 Matthew Kaulfers. All rights reserved.
//

import Foundation

class HighScore
{
    let playerName: String
    let playerTime: String
    let playerMatches: Int
    let playerAttempts: Int
    
    init()
    {
        self.playerName = "noPlayer"
        self.playerTime = "0:00"
        self.playerMatches = 99
        self.playerAttempts = 99
    }
    
    init(playerName: String, playerTime: String, playerMatches: Int, playerAttempts: Int)
    {
        self.playerName = playerName
        self.playerTime = playerTime
        self.playerMatches = playerMatches
        self.playerAttempts = playerAttempts
    }
}
