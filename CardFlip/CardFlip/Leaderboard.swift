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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath) as! LeaderboardCell
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "LeaderboardCell", bundle: nil), forCellReuseIdentifier: "leaderboardCell")
        print("viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewDidAppear")
    }
}
