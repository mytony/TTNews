# TTNews
An iOS news app that provides US top headlines and category selection

**_App Demo_**

https://user-images.githubusercontent.com/9066296/158003097-dfab3326-5c20-4da0-a459-e225d3babe29.mov

**_Demo Highlights_**
(in timeline order)
1. Chooses different categories from the top
2. Views each news
3. Changes category filters in the Settings tab and the change is effective immediately when switching back to the News tab.
4. Dark mode
5. Scroll down and more news is loaded.

**_Code Highlights_**
* Fetches from endpoint
* Caches images
* JSON parsing
* Uses Async/await in the network calls

* Scroll view on top for viewing by categories
* Autolayout
* Modern collection view
* Utilizes diffable data source
* Pagination

* Use `Notification` and `Delegate` to communicate and pass data among view controllers and views
* Supports dark mode
* A custom view that allows creating selection buttons for any setting configuration. Initialize the view with a String array of options you want and it will create buttons in nice layout.
* Unit tests to test the notifications, helper functions, category settings, and UI
