# Swift URL Validator

A comprehensive URL validation and classification library for Swift that intelligently detects platforms, media types, and validates URLs using native Apple APIs and UTType for maximum compatibility.

## Features

- 🔍 **Smart URL Validation** - Validates URLs with or without schemes
- 🌐 **300+ Platform Detection** - Recognizes major platforms like YouTube, Spotify, GitHub, etc.
- 📁 **Media Type Detection** - Identifies file types using Apple's UTType system
- 🎯 **ID Extraction** - Extracts video IDs, tweet IDs, and other platform-specific identifiers
- 🏷️ **Platform Categorization** - Groups platforms into categories (video, audio, social, etc.)
- 🔒 **Security Checks** - Identifies HTTPS, HTTP, and file URLs
- ⚡ **High Performance** - Optimized pattern matching without regex
- 🧵 **Thread Safe** - Fully Sendable compliant for Swift concurrency
- 📱 **Multi-Platform** - Supports iOS, macOS, tvOS, watchOS, and visionOS

## Requirements

- iOS 15.0+ / macOS 12.0+ / tvOS 15.0+ / watchOS 8.0+ / visionOS 1.0+
- Swift 6.1+
- Xcode 15.0+

## Installation

### Swift Package Manager

Add URLValidator to your project through Xcode:

1. File → Add Package Dependencies
2. Enter: `https://github.com/arraypress/swift-url-validator.git`
3. Select "Up to Next Major Version" with "1.0.0"

Or add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/arraypress/swift-url-validator.git", from: "1.0.0")
]
```

## Usage

### Basic URL Validation

```swift
import URLValidator

// Validate URLs
"https://youtube.com".isValidURL  // true
"not a url".isValidURL            // false
"google.com".isValidURL           // true (handles URLs without scheme)

// Normalize URLs (adds https:// if missing)
"google.com".normalizedURL        // "https://google.com"
```

### Platform Detection

```swift
// Detect platforms
"https://youtube.com/watch?v=123".urlPlatform         // .youtube
"spotify.com/track/456".urlPlatform                   // .spotify
"https://github.com/apple/swift".urlPlatform          // .github

// Check platform categories
"https://youtube.com/watch?v=123".isVideoPlatformURL  // true
"https://spotify.com/track/456".isAudioPlatformURL    // true
"https://twitter.com/user".isSocialMediaURL           // true
```

### Media Type Detection

```swift
// Detect file types
"example.com/video.mp4".urlMediaType      // .video
"example.com/song.mp3".urlMediaType       // .audio
"example.com/image.jpg".urlMediaType      // .image
"example.com/document.pdf".urlMediaType   // .document

// Check specific media types
"example.com/video.mp4".hasVideoExtension // true
"example.com/song.mp3".hasAudioExtension  // true
```

### ID Extraction

```swift
// Extract platform-specific IDs
"https://youtube.com/watch?v=dQw4w9WgXcQ".youtubeVideoID        // "dQw4w9WgXcQ"
"https://twitter.com/user/status/123456".tweetID                // "123456"
"https://instagram.com/p/ABC123".instagramPostID                // "ABC123"
"https://open.spotify.com/track/4cOdK2wGLETKBW3PvgPWqT".spotifyID // "4cOdK2wGLETKBW3PvgPWqT"

// Extract GitHub info
if let repo = "https://github.com/apple/swift".githubRepo {
    print(repo.owner)  // "apple"
    print(repo.repo)   // "swift"
}
```

### Comprehensive URL Analysis

```swift
let analysis = URLValidator.analyze("https://www.youtube.com/watch?v=dQw4w9WgXcQ#t=30s")

print(analysis.isValid)           // true
print(analysis.platform)          // .youtube
print(analysis.platformCategory)  // .video
print(analysis.isHTTPS)          // true
print(analysis.host)             // "www.youtube.com"
print(analysis.extractedIDs)    // ["youtube_video_id": "dQw4w9WgXcQ"]
print(analysis.summary)          // "YouTube • Video • Secure • 1 ID(s)"
```

### Array Extensions

```swift
let urls = [
    "https://youtube.com/watch?v=123",
    "https://spotify.com/track/456",
    "https://github.com/user/repo",
    "not-a-url"
]

// Filter valid URLs
let validURLs = urls.validURLs  // 3 URLs (excludes "not-a-url")

// Filter by platform
let youtubeURLs = urls.filterURLs(platform: .youtube)

// Filter by category
let audioURLs = urls.filterURLs(category: .audio)

// Group by platform
let grouped = urls.groupURLsByPlatform()
// [.youtube: [...], .spotify: [...], .github: [...]]
```

## Supported Platforms

### Video Platforms
YouTube, Vimeo, Dailymotion, Twitch, Kick, Rumble, BitChute, Odysee, TikTok, Instagram Reels, and more...

### Audio/Music Platforms
Spotify, Apple Music, SoundCloud, Bandcamp, Tidal, Deezer, Amazon Music, YouTube Music, Qobuz, and more...

### Social Media
Facebook, Twitter/X, Instagram, LinkedIn, Reddit, Pinterest, Tumblr, Mastodon, Threads, Bluesky, and more...

### Developer Platforms
GitHub, GitLab, Bitbucket, Stack Overflow, CodePen, CodeSandbox, Replit, Figma, and more...

### Gaming Platforms
Steam, Epic Games, Battle.net, GOG, itch.io, Roblox, Xbox, PlayStation, Nintendo, and more...

### Financial Platforms
PayPal, Venmo, Cash App, Coinbase, Binance, Stripe, and more...

### And Many More
Including messaging apps, cloud storage, e-commerce, dating apps, productivity tools, and Web3 platforms.

## Platform Categories

- **Video** - Video hosting and streaming platforms
- **Audio** - Music and podcast platforms
- **Social** - Social media networks
- **Messaging** - Chat and communication apps
- **Developer** - Code and design platforms
- **Gaming** - Game stores and platforms
- **Financial** - Payment and trading platforms
- **E-commerce** - Online shopping
- **Cloud** - File storage services
- **Learning** - Educational platforms
- **Web3** - Blockchain and NFT platforms
- **Alternative** - Alternative tech platforms
- **Subscription** - Creator economy platforms
- And more...

## Advanced Features

### Security Checks

```swift
"https://example.com".isHTTPS  // true
"http://example.com".isHTTP    // true
"file:///path/to/file".isFileURL // true
```

### URL Components

```swift
let url = "https://example.com/path?query=value#fragment"

url.urlDomain     // "example.com"
url.urlPath       // "/path"
url.urlQuery      // "query=value"
url.urlExtension  // nil
```

### Performance

The library is optimized for performance with:
- Dictionary-based pattern matching (no regex)
- Efficient string processing
- Minimal allocations
- Lazy evaluation where possible

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

URLValidator is available under the MIT license. See the LICENSE file for more info.

## Acknowledgments

- Uses Apple's UTType system for robust file type detection
- Inspired by the need for comprehensive URL validation in Swift
