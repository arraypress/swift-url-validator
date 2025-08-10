# Swift URL Validator

![Swift Version](https://img.shields.io/badge/Swift-6.1+-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS%2015%2B%20|%20macOS%2012%2B%20|%20tvOS%2015%2B%20|%20watchOS%208%2B%20|%20visionOS%201%2B-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![SPM Compatible](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg)
![Platform Coverage](https://img.shields.io/badge/Coverage-300%2B%20Platforms-purple.svg)

**A comprehensive URL validation and classification library for Swift**

Intelligently detects platforms, extracts IDs, and validates URLs using native Apple APIs

---

## ✨ Features

- 🔍 **Smart URL Validation** - Validates URLs with or without schemes
- 🌐 **300+ Platform Detection** - Recognizes major platforms like YouTube, Spotify, GitHub, etc.
- 📁 **Media Type Detection** - Identifies file types using Apple's UTType system
- 🎯 **ID Extraction** - Extracts video IDs, tweet IDs, and other platform-specific identifiers
- 🏷️ **Platform Categorization** - Groups platforms into categories (video, audio, social, etc.)
- 🔒 **Security Checks** - Identifies HTTPS, HTTP, and file URLs
- ⚡ **High Performance** - Optimized pattern matching without regex
- 🧵 **Thread Safe** - Fully Sendable compliant for Swift concurrency
- 📱 **Multi-Platform** - Supports iOS, macOS, tvOS, watchOS, and visionOS
- 🧪 **Thoroughly Tested** - 70+ test cases with comprehensive coverage

## 📋 Requirements

| Platform | Minimum Version |
|----------|----------------|
| iOS | 15.0+ |
| macOS | 12.0+ |
| tvOS | 15.0+ |
| watchOS | 8.0+ |
| visionOS | 1.0+ |
| **Swift** | **6.1+** |
| **Xcode** | **15.0+** |

## 📦 Installation

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

## 🚀 Quick Start

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

## 🌍 Supported Platforms

<details>
<summary><b>Video Platforms (20+)</b></summary>

- YouTube, YouTube Shorts, YouTube Music, YouTube Studio
- Vimeo, Dailymotion
- TikTok, Instagram Reels
- Twitch, Kick
- Rumble, BitChute, Odysee
- PeerTube, DTube
- And more...
</details>

<details>
<summary><b>Audio/Music Platforms (25+)</b></summary>

- Spotify, Apple Music
- SoundCloud, Bandcamp
- Tidal, Deezer
- Amazon Music, YouTube Music
- Qobuz, Mixcloud
- Podcasts: Apple Podcasts, Google Podcasts, Overcast
- And more...
</details>

<details>
<summary><b>Social Media (30+)</b></summary>

- Facebook, Twitter/X, Instagram
- LinkedIn, Reddit, Pinterest
- Tumblr, Mastodon, Threads, Bluesky
- Truth Social, Gab, Parler
- WeChat, Weibo, TikTok
- And more...
</details>

<details>
<summary><b>Developer Platforms (15+)</b></summary>

- GitHub, GitLab, Bitbucket
- Stack Overflow
- CodePen, CodeSandbox, Replit
- Figma, Dribbble, Behance
- And more...
</details>

<details>
<summary><b>Other Categories</b></summary>

- **Gaming**: Steam, Epic Games, Battle.net, GOG, itch.io
- **Financial**: PayPal, Venmo, Cash App, Coinbase, Binance
- **Messaging**: WhatsApp, Telegram, Discord, Slack, Signal
- **Cloud Storage**: Dropbox, Google Drive, OneDrive, iCloud
- **E-commerce**: Amazon, eBay, Etsy, Shopify
- **Web3**: OpenSea, Rarible, Foundation
- **And 200+ more platforms!**
</details>

## 📊 Platform Categories

| Category | Description | Example Platforms |
|----------|-------------|-------------------|
| `video` | Video hosting and streaming | YouTube, Vimeo, TikTok |
| `audio` | Music and podcast platforms | Spotify, Apple Music, SoundCloud |
| `social` | Social media networks | Facebook, Twitter, Instagram |
| `messaging` | Chat and communication | WhatsApp, Telegram, Discord |
| `developer` | Code and design platforms | GitHub, GitLab, Figma |
| `gaming` | Game stores and platforms | Steam, Epic Games, Xbox |
| `financial` | Payment and trading | PayPal, Venmo, Coinbase |
| `ecommerce` | Online shopping | Amazon, eBay, Etsy |
| `cloud` | File storage services | Dropbox, Google Drive |
| `learning` | Educational platforms | Udemy, Coursera, Khan Academy |
| `web3` | Blockchain and NFT | OpenSea, Rarible |
| `alternative` | Alternative tech platforms | Rumble, BitChute, Mastodon |

## 🔧 Advanced Features

### Security Checks

```swift
"https://example.com".isHTTPS     // true
"http://example.com".isHTTP       // true
"file:///path/to/file".isFileURL  // true
```

### URL Components

```swift
let url = "https://example.com/path?query=value#fragment"

url.urlDomain     // "example.com"
url.urlPath       // "/path"
url.urlQuery      // "query=value"
url.urlExtension  // nil
```

## ⚡ Performance

The library is optimized for performance with:
- **No Regular Expressions** - Dictionary-based pattern matching
- **Efficient String Processing** - Minimal string allocations
- **Lazy Evaluation** - Computations only when needed
- **Thread Safe** - Fully concurrent-ready with Sendable compliance
- **Native APIs** - Leverages Apple's UTType system

## 🧪 Testing

The library includes comprehensive test coverage:
- 70+ test cases
- Platform detection tests
- ID extraction tests
- Edge case handling
- Performance benchmarks
- Thread safety tests

Run tests:
```bash
swift test
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

URLValidator is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## 🙏 Acknowledgments

- Uses Apple's UTType system for robust file type detection
- Inspired by the need for comprehensive URL validation in Swift
- Built with Swift 6 concurrency in mind

## 📬 Contact

- **GitHub Issues**: [Report a bug](https://github.com/arraypress/swift-url-validator/issues)
- **Discussions**: [Ask questions](https://github.com/arraypress/swift-url-validator/discussions)

---

Made with ❤️ by [ArrayPress](https://github.com/arraypress)
