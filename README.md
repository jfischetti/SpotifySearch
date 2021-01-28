# SpotifySearch
This app is a client for the Spotify API. It allows you to search for artists by keyword and view some information about them. 

The app was developed using RxSwift and the MVVM design pattern.

# Requirements
   * Xcode 12.3 or later
   * Cocoapods 1.10.0 or later
   * Created an account and registered for a client ID and secret with Spotify at (https://developer.spotify.com/documentation/general/guides/app-settings/#register-your-app)

# Installation
```
git clone https://github.com/jfischetti/SpotifySearch.git
cd SpotifySearch/
pod install
```

# Running the App
1. Open SpotifySearch.xcworkspace using Xcode
1. Open SpotifySearch/Network/NetworkConstants.swift
1. Locate the clientID and clientSecret values and replace them with your own.
1. Click on run!

# Attributions
All artist data is retrieved using the Spotify API (https://developer.spotify.com/documentation/web-api/reference/).

Icons were sourced from FontAwesome (https://github.com/thii/FontAwesome.swift).