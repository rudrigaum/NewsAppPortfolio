
NewsApp
A modern news application for iOS built with SwiftUI, showcasing a clean user interface and robust data fetching capabilities.

✨ Features
Dynamic News Feed: Fetches and displays top headlines from the NewsAPI.

Category Filtering: Allows users to filter news by category (e.g., Technology, Business, Sports).

Image Loading: Asynchronously loads article images with a placeholder for a smooth user experience.

Detail View: Navigates to a detailed view of the selected article.

In-App Browser: Opens the full article in a web view without leaving the application.

Pull-to-Refresh: Supports refreshing the news feed with a simple pull gesture.

Error Handling: Displays user-friendly error messages for network or API failures.

🚀 Technologies Used
SwiftUI: Declarative UI framework for building the application interface.

Swift Concurrency: Utilizes async/await for efficient and safe asynchronous operations.

URLSession: Manages all network requests to the NewsAPI.

JSONDecoder: Parses JSON responses into Swift data models.

GitHub: Version control for the project.

📱 Screenshots
To add screenshots, simply take some from your simulator and upload them to a /screenshots folder in your repository. Then, replace the placeholder URLs above with the correct path.

⚙️ How to Run
Clone the repository:

Bash

git clone [your-repository-url]
Get an API Key:

Sign up for a free API key at NewsAPI.org.

Add Your API Key:

Create a file named Secrets.swift in the root of the project.

Add your API key to this file as a constant:

Swift

let apiKey = "YOUR_API_KEY_HERE"
Important: Do not commit Secrets.swift to git. Add Secrets.swift to your .gitignore file to keep your API key private.

Open in Xcode:

Open the NewsApp.xcodeproj file.

Run:

Select a simulator or a physical device and run the project.

📈 Future Enhancements
Implement a search bar to search for specific news articles.

Add a persistence layer (e.g., SwiftData or Core Data) to save favorite articles.

Introduce a "dark mode" toggle for a better user experience.

Add support for multiple languages and countries.
