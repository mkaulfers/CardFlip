# CardFlip
### Features
- Firebase
- RESTful API
- JSON
- Core Data
- Auto-Layout (hC wC -> hR wR) (iPhone & iPad)
- UI Animations

### To-Do
- (CRITICAL) Fix constraints on leaderboard button. (Breaks iPad App)
- (MAJOR) Fix proportional constraints on "Win" popup.
- (Feature) Add firebase support for the leaderboard.
- (Feature) Add card generation and replace "Random" with "Generate"

### Details
This app is a simple card matching app. There are two versions a 4x5 version for `.phone` idioms and there is a 5x6 version for `.pad` idioms. The app can dynamically detect the device type and assign code for that respective device. Due to the nature of the varied controls per device there is a high-level of re-usability involved to prevent having to re-code for multiple devices. The constraints are primarily assigned to wC and hC wR to distinguish between landscape and portrait orientation. The difference here is for the `.pad` where the constraints are setup for hR wR. There are included animations, sounds, and other User Experience elements included with this project. It will eventually be pushed to the App-Store upon feature completion.

[<img src="https://imgur.com/a/QZj3er5.jpg">](http://www.imgur.com/)

