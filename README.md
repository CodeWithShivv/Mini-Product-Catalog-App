# Mini Product Catalog App

## Video
https://drive.google.com/file/d/10v9-EGOzF33Och5pVaHEcTlzxJpHq_zj/view?usp=sharing

## Screenshots
![Screenshot 2025-02-20 at 10 25 33 AM](https://github.com/user-attachments/assets/4158bef4-2833-4730-8eac-4a13e88aef9f)


![Screenshot 2025-02-20 at 10 25 48 AM](https://github.com/user-attachments/assets/fe4d00c5-fc61-43d7-98e3-db488adf83ff)

![Screenshot 2025-02-20 at 10 26 12 AM](https://github.com/user-attachments/assets/1f007fb7-e6c2-47ef-a16d-e019c3fb5c10)
![Screenshot 2025-02-20 at 10 26 30 AM](https://github.com/user-attachments/assets/8f0d21f7-69ad-4a23-bcc3-b1f693184e4c)



## Overview
The **Mini Product Catalog App** is a Flutter-based application that allows users to browse products efficiently. It features **offline-first synchronization**, **pagination**, **search**, and **state management** using BLoC. The app follows the **MVVM Architecture** and a **Feature-Based Folder Structure** for maintainability and scalability.

## Features
- **Offline-first architecture** (local storage using Hive & Firebase Firestore for remote data)
- **Pagination** (fetches 10 products at a time from Firestore with lazy loading)
- **Product search** (supports online and offline search functionality)
- **State management** using **BLoC**
- **Dependency injection** with **GetIt**
- **Connectivity-aware sync mechanism** (syncs local storage with Firestore when online)
- **Optimized performance** (uses isolates for data processing in the background)
- **Cart and Favorites Feature** (Implemented using Hive & BLoC)
- **Connectivity Handling** (Triggers sync event in BLoC when internet is restored)
- **Splash Screen Initialization** (Triggers app initialization and sync on startup)
- **Pull To Refresh** (Triggers a sync event in BLoC )



---

## Setup Instructions
### 1. Prerequisites
- Install **Flutter** (version 3.x+ recommended)
- Set up **Firebase** for the project using Firebase CLI
- Enable **Firestore Database** in Firebase


### 2. Clone the Repository
git clone https://github.com/CodeWithShivv/Mini-Product-Catalog-App

### 3. Install Dependencies



### 4. Generate Code

Run the build\_runner to generate necessary files for Hive and other code generation tools:


### 5. Configure Firebase

-   Follow the official Firebase setup guide for Flutter to connect your app to your Firebase project.
-   Place the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files in the appropriate directories (`android/app` and `ios/Runner/`, respectively).

### 6. Run the Application

Launch the app on your emulator or physical device:
s

---

## Architectural Overview

The Mini Product Catalog App is built using the **MVVM Architecture**, promoting a clear separation of concerns and enhancing code maintainability.

### 1. Data Layer (Local & Remote Synchronization)

-   **Local Storage:** Utilizes Hive for persistent storage of products, cart items, and favorites, enabling offline access.
-   **Remote Storage:** Leverages Firebase Firestore for cloud-based data synchronization.
-   **Synchronization Strategy:**
    -   Uses `ConnectivityService` to monitor internet connectivity.
    -   When online, fetches paginated products from Firestore and updates the local Hive database.
    -   When offline, retrieves cached products from Hive for uninterrupted access.
    -   Upon reconnection, triggers a synchronization event in BLoC to fetch any missing data from Firestore.

### 2. Presentation Layer (BLoC & UI)

-   **State Management:** Employs the Flutter BLoC pattern for managing the application's state, ensuring predictability and maintainability.
-   **UI Updates:** UI components react to BLoC states such as `ProductLoading`, `ProductLoaded`, and `ProductError`, providing real-time feedback to the user.
-   **Connectivity Handling:** Listens for changes in connectivity and triggers synchronization events in the BLoC when the app comes back online.
-   **Splash Screen Initialization:**
    -   Initializes `SplashBloc` within a `BlocProvider` at app startup.
    -   Dispatches an `AppInitialized` event to the `SplashBloc`.
    -   Calls `fetchProducts()` in the `ProductRepository` to load initial data.
    -   Checks for connectivity and synchronizes products accordingly.
    -   Emits a `SplashSuccess` state upon successful data synchronization, signaling the app's readiness.

---

## Pagination Implementation

-   Fetches products in batches of 10 to optimize data loading and UI performance.
-   Utilizes Firestore queries with `startAfterDocument` to efficiently load the next set of products.
-   Maintains a reference to the last fetched document to enable smooth lazy loading.
-   Displays a loading indicator while fetching additional products, providing visual feedback to the user.
-   **Offline Pagination:**
    -   When offline, pagination is handled using locally stored data from Hive.
    -   The app retrieves subsequent sets of products directly from the Hive database.
    -   The UI remains responsive, allowing users to browse products without waiting for an internet connection.

---

## Search Implementation

- Implements **debounced search** (500ms delay) to minimize redundant API calls and optimize performance.
- Supports both **online and offline search**:
  - When **online**, fetches search results from **Firestore** using optimized queries.
  - When **offline**, searches within the **Hive database** to ensure uninterrupted functionality.
- Uses **`.where` filtering** for efficient matching of user input across product titles and descriptions.



## Cart & Favorites Implementation

### Cart Feature

-   **State Management:** Uses BLoC for managing the cart's state, ensuring consistency and predictability.
-   **Storage:** Cart items are stored locally in Hive, providing offline access and persistence.
-   **Operations:**
    -   Add products to the cart.
    -   Remove products from the cart.
    -   Fetch stored cart items from Hive.
    -   Display cart items on a dedicated screen.

### Favorites Feature

-   **State Management:** Employs BLoC for managing the list of favorite products.
-   **Storage:** Favorite products are stored in Hive, enabling offline access.
-   **Operations:**
    -   Mark products as favorites.
    -   Unmark products as favorites.
    -   Fetch favorite products from Hive.
    -   Display favorite items on a dedicated screen.

## Pull to Refresh Implementation

- **Added Pull to Refresh** functionality to the **Product Listing Screen**.
- When the user pulls down to refresh:
  - It **fetches the latest products** from Firestore.
  - It **syncs the local Hive database** with the updated product data.
  - Ensures **offline data consistency** after synchronization.
- **Triggers a sync event in BLoC**, ensuring state updates without requiring a full app restart.
- Enhances **user experience** by providing a seamless way to refresh and update product listings.



## Future Enhancements

-   Implement product filtering by category to enhance the browsing experience.
-   Add dark mode support for improved accessibility and user preference.


## License

MIT License. Feel free to use and modify this project!

---

## Contributions

Pull requests are welcome! If you'd like to contribute, please follow these steps:

1.  Fork the repository.
2.  Create a new feature branch (`git checkout -b feature-branch`).
3.  Commit your changes (`git commit -m 'Added new feature'`).
4.  Push to the branch (`git push origin feature-branch`).
5.  Open a Pull Request.

Happy coding! 🚀
