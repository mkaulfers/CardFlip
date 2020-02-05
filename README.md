# CardFlip

____

### Features
- Firebase
- RESTful API
- JSON
- Core Data
- Auto-Layout (hC wC -> hR wR) (iPhone & iPad)
- UI Animations

____

### To-Do
- (CRITICAL) Fix constraints on leaderboard button. (Breaks iPad App)
- (MAJOR) Fix proportional constraints on "Win" popup.
- (Feature) Add firebase support for the leaderboard.
- (Feature) Add card generation and replace "Random" with "Generate"

____

### Details
This app is a simple card matching app. There are two versions a 4x5 version for `.phone` idioms and there is a 5x6 version for `.pad` idioms. The app can dynamically detect the device type and assign code for that respective device. Due to the nature of the varied controls per device there is a high-level of re-usability involved to prevent having to re-code for multiple devices. The constraints are primarily assigned to wC and hC wR to distinguish between landscape and portrait orientation. The difference here is for the `.pad` where the constraints are setup for hR wR. There are included animations, sounds, and other User Experience elements included with this project. It will eventually be pushed to the App-Store upon feature completion.

____

# ART, Design, Details!

![Imgur](https://i.imgur.com/adBMBEN.jpg)
(Image Above: Card examples included in app.)

### Gameplay Elements

____

The app includes 4 sets of icons to be added to the cards. There are robots, monsters kittens and cyborgs! The UI was actually designed around the color palette from the icons. I found a really cool API at [https://robohash.org/](https://robohash.org/) . It allows you to generate, based on sets, different icons. Checking out the code shows that it's being done by a hash value to randomly generate and return an image that is built on the fly from a set of *Components*. As listed in the To-Do I'll be adding functionality to do this within CardFlip itself, perhaps even allow the user to save the image sets for future use.  This is also where the firebase will come into play and setting up for monetization. 

### The Nerdy Stuff

____

#### - Custom Cells

We are using re-usable cells in this project, specifically for the leaderboard. It's also sorted accordingly. There will be some changes as time goes on, to make this interface look a little better. 



```swift
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentHighScores.sort(by: { $0.playerTime < $1.playerTime})
        tableView.reloadData()
    }
```



#### - Win Handling

This is actually an interesting way of handling the multiple cards on the app. The images are stored to an array for obvious reasons, but then everything is setup as a tag on the images themselves. The tags are a critical component as it will allow us to ensure that the card that is flipped, is the array element # that matches the array. It appeared to me to be the best way to handle what card, when the image isn't known, is being selected. Reusability was a high driving factor for doing it this way as well.  We also add, programmatically, `UITouchGestureRecognizers` to the `[UIImageView]` collection. 

### Monetization 

____

This is the part where we get to talk about making money from this app. This is a bit trickier to accomplish because I'm not a developer who likes to spam the user with ADs or click-bait videos, or some gimmicky pay to play type store-front. Ultimately I'd like to create a game, that is intuitive, and generate revenue without making my users uninstall. The generate functionality will pull in new image sets, randomly. This will be a sign in required feature. Having the user sign in will allow me to associate their device with their image sets and store them in firebase. By default users will be given 1 slot for an image-set, more slots purchasable. Alternatively more slots given by sharing on social. If a purchase is made, ads are removed, if shared on social ads are removed. 



