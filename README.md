# StarkBlaze


This was designed following the Model-View-ViewModel (MVVM) architectural pattern, with a strong emphasis on networking. The app consists of table views and a search controller to query an API based on user input. 
It also employs a tab bar for seamless navigation between Houses, Characters, and Books. The app makes extensive use of Apple's Combine framework for handling asynchronous events.

 # Why MVVM?
In the case of our app, networking can benefit from MVVM because the ViewModel can act as an intermediary between the View and the Model, which handles the networking. 
This means that the View doesn't need to know about the networking layer. It only needs to know about the ViewModel, which provides it with the data it needs. 
This makes the code more modular and easier to understand, test, and maintain.

# Why Combine?
In my app, Combine is used in the ViewModel to manage asynchronous tasks. 
This allows us to handle complex networking tasks with ease, making our code cleaner and more manageable. 
Furthermore, Combine works well with Swift and Apple APIs, providing a consistent and efficient way to handle asynchronous events.

# Features

Table Views
This app uses table views to display the data fetched from the API. Each row in a table view represents a house, a character, or a book, depending on the selected tab.

Search Controller
The app features a search controller that allows users to search for specific houses, characters, or books by querying the API based on the search text.

Tab Bar
A tab bar is used to separate each page according to Houses, Characters, and Books. This allows for easy navigation and a clean, organized user interface.

# Installation
As this app does not have any external dependencies and relies solely on Apple's frameworks, the installation process is straightforward.
Simply download the project and open it in Xcode to run it on your preferred simulator or device.

# Issue 1
- The API provided did not provide images, upon looking to integrate another API that provides images, it would be heavy on the app and not consistent with the requirements
- therefore only text and what the API provided is used


# Issue 2
- The search controller was quite difficult for me. It works well on the Book tab however, keeping it persistant on the other tabs proved to be quite difficult. A search can be made, but
- retaining that search and displaying it was a challenge

Thank you for the opportunity. I learnt alot.
