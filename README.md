# Upcoming Movies Mobile App
Want to find the latest upcoming movies? Well then the "Upcoming Movies Mobile App" is just for you. Not only it shows the latest upcoming movies but it also allow you to search any movie you want!

### Release Notes
##### Issues with API
1. The Upcoming Movies API sometimes returns duplicates. I have added a check in the code to handle them.
2. The API does not return data sorted by date across pages. This means that say if page 1 returns data from 10/10/2016 to 10/20/2016 then the page 2 also returns data from approximately 10/10/2016 to 10/20/2016. Because the application is sorting the data based on date, when the application lazy loads more data, the tableview gets updated and there is a slight jitter.


##### Implementation Notes
1. Autolayout and size classes are used, this means that the view will appropriately adjust for different sizes. 
2. Although the application design are more suitable to iPhone, the application also works perfectly well on iPad. 
3. Offline functionality is supported. We have used core data for storing movies. Only upcoming movies are stored in database. Refreshing upcoming movies will reset the database with the latest data.
4. Local filtering on upcoming movies is supported.
5. Searching using API is also supported. You can search using the API by tapping on the green button at the end of the tableview when user is performing filtering.
5. The movies are divided into section by date.
6. Pagination is supported on Upcoming Movies API as well as Search API
7. Images are cached locally
8. I am pre-fetching images to make the overall experience better. 

### Build Instructions
1. Clone or download the application using `https://github.com/ali9091/UpcomingMoviesMobileApp.git`
2. Open terminal redirect terminal to where the application was cloned or downloaded
3. Run the command `pod install`
4. Open `UpcomingMoviesMobileApp.xcworkspace`
5. Choose `UpcomingMoviesMobileApp Dev` target
6. Choose the desired device or simulator
7. Click on play button to run the application

### ScreenShots
<img src="https://www.dropbox.com/s/qcy2h6uw31ud0z8/1.png?dl=0&&raw=1" alt="Drawing" width="200" />
<img src="https://www.dropbox.com/s/bdaxkamsx1jum9a/2.png?dl=0&&raw=1" alt="Drawing" width="200" />
<img src="https://www.dropbox.com/s/bb17jni8sizh1ua/3.png?dl=0&&raw=1" alt="Drawing" width="200" />
<img src="https://www.dropbox.com/s/0iwbrcpm6bhnjlt/4.png?dl=0&&raw=1" alt="Drawing" width="200" />

### Third Party Libraries
##### AFNetworking
Very powerful networking library. Used for making network calls to the server. 
##### MBProgressHUD
Used for showing progress HUD when there is a network call in progress. This progress HUD is used when the application starts and when the user uses the Search API.
##### Reachability
Used for checking internet connectivity before making a call to the server.
##### SDWebImage
Used for downloading and caching images.
##### MagicalRecord
This library is a wrapper over Apple's Core Data framework. It is used for coordinating with CoreData objects as well as for converting JSON to core data objects.
##### SVPullToRefresh
Used for pull to refresh and infinite scrolling.
##### Mantle
Used for converting JSON to non-core data objects


