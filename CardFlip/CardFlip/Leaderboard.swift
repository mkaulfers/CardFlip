//
//  Leaderboard.swift
//  CardFlip
//
//  Created by Matthew Kaulfers on 2/1/20.
//  Copyright © 2020 Matthew Kaulfers. All rights reserved.
//

import UIKit

class Leaderboard: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var currentHighScores = [HighScore]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentHighScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath) as! LeaderboardCell
        cell.highScoreName.text = currentHighScores[indexPath.row].playerName
        cell.highScoreTime.text = currentHighScores[indexPath.row].playerTime
        cell.highScoreMatches.text = currentHighScores[indexPath.row].playerMatches.description
        cell.highScoreAttempts.text = currentHighScores[indexPath.row].playerAttempts.description
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //INFO: Register our cell name.
        tableView.register(UINib(nibName: "LeaderboardCell", bundle: nil), forCellReuseIdentifier: "leaderboardCell")
        currentHighScores.append(HighScore())
        currentHighScores.append(HighScore())
        currentHighScores.append(HighScore())
        currentHighScores.append(HighScore())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
}
