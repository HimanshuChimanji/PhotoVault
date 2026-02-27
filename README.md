📸 PhotoVault
iOS Engineer Technical Assessment

Candidate: Himanshu Chimanji
Platform: iOS 15+
Language: Swift 5
Architecture: MVVM
UI Framework: UIKit (XIB-based)
Networking: URLSession (Custom Network Layer)
Persistence: Core Data
Image Loading: SDWebImage


📌 Overview

PhotoVault is an iOS application that fetches photo data from a REST API, displays it in a paginated list with thumbnail images and titles, persists data locally using Core Data, and allows users to edit titles and delete records.

The project focuses on clean architecture, performance optimization, and robust error handling.


🌐 API

Endpoint:
https://jsonplaceholder.typicode.com/photos

Method: GET
Total Records: 5000

Each photo includes:
    {
        "albumId": 1,
        "id": 1,
        "title": "accusamus beatae ad facilis cum similique qui sunt",
        "url": "https://via.placeholder.com/600/92c952",
        "thumbnailUrl": "https://via.placeholder.com/150/92c952"
    }


🏗 Architecture

PhotoVault follows the MVVM pattern with clear separation of concerns.

Project Structure

Network Layer
    NetworkServiceProtocol
    NetworkService
    Request
    HTTPMethod
    NetworkError
Module
    PhotoListDetail
        View
        ViewModal
    PhotoList
        Model
        Network
        View
        ViewModel
Utils
CoreData


🚀 Features

Fetch & Display
    Data fetched using URLSession
    Displayed in UITableView
    Custom XIB-based cell
    Loading indicator during fetch
Pagination
    Batch loading (30 records)
    Lazy loading on scroll
    Optimized memory usage
Image Loading
    Implemented using SDWebImage
    In-memory caching
    Placeholder image support
    Graceful handling of DNS failures for image host
    
    Note: The image URLs provided by the API use the host via.placeholder.com, which is currently not resolving (DNS failure) in certain regions/networks. This is an external service issue and not related to the app’s networking implementation. Image loading failures are handled gracefully using SDWebImage with fallback placeholder images to ensure a stable user experience.

Core Data
    Saves API data locally
    Loads from Core Data on subsequent launches
    Duplicate prevention using unique id
    Full CRUD operations supported
Edit Title
    Tap a row to open detail screen
    Editable title field
    Changes saved to Core Data
    UI updates immediately
Delete Record
    Swipe-to-delete in list screen
    Confirmation alert before deletion
    Immediate Core Data and UI update
    No delete button on detail screen
    

⚡ Performance Optimizations
    
    Pagination
    Lazy image loading
    SDWebImage caching
    Minimal main-thread blocking
    Efficient Core Data operations


🛠 Setup Instructions
    1. Clone the repository
    2. Open in the latest version of Xcode
    3. Ensure deployment target is iOS 15+
    4. Build and run
    5. No additional configuration required.
    
📦 Dependencies

The following third-party libraries are used:

    • SDWebImage
        Used for:
            Asynchronous image downloading
            In-memory caching
            Automatic placeholder handling
            Efficient image reuse in scrolling lists
    • KBProgressHUD
        Used for:
            Displaying loading indicators during network requests
            Providing a clean and responsive user experience
            Both libraries are integrated via Swift Package Manager.
            

🔎 Image Host Note

    The image URLs returned by the API use the host via.placeholder.com, which is currently not resolving (DNS failure) on certain networks/regions. This is an external service issue and not related to the app’s networking implementation.
    Image loading failures are handled gracefully using SDWebImage with fallback placeholder images to maintain UI stability.
