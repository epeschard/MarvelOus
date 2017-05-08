# iOS application that communicates with the Public Marvel API and meets the following requirements:

* Shows a list/collection of items from the Marvel API 
* Allows searching the contents of this list/collection with syntax highlighted results as you type
* All details of Comics are easily browsable including characters, creators, variations, dates, etc 
* The application is coded using Swift 3.1 using MVC (MVVM was not required since the classes remain comprehensible)
* Offline data is allowed using Realm (c) and the first 10 comics are loaded locally for a better initial launch UX
* All interactions with MARVEL server or local database are separated on the Interactor (like VIPER Architecture)
* The universal application uses AutoLayout with curated UI for small and larger screens
* Custom animations are explored to provide Attribution on the ComicSearch screen
* Unit tests are provided for the database loading as well as all calls to MARVEL servers
* UI tests were started for most functionalities
* All text supports dynamic text to easily adjust fontsize preferences
* Added branch with MARVEL custom font allover but hasn't been merged since it doesn't support Dynamic Font yet

### Info:
- Marvel API: http://developer.marvel.com/
