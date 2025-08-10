//
//  URLValidator+IDExtraction.swift
//  URLValidator
//
//  ID extraction methods for various platforms
//
//  Created by David Sherlock on 09/08/2025.
//

import Foundation

extension URLValidator {
    
    // MARK: - Main ID Extraction
    
    /// Main ID extraction method that delegates to platform-specific extractors
    /// - Parameters:
    ///   - url: The URL to analyze
    ///   - platform: The detected platform
    /// - Returns: Dictionary of extracted IDs with descriptive keys
    ///
    /// Supported platforms:
    /// - YouTube (video IDs)
    /// - Twitter/X (tweet IDs)
    /// - Instagram (post IDs)
    /// - TikTok (video IDs)
    /// - Spotify (track/album/playlist IDs)
    /// - Reddit (post IDs)
    /// - GitHub (owner/repo/PR/issue)
    /// - LinkedIn (activity IDs)
    /// - Vimeo (video IDs)
    /// - Facebook (post/video IDs)
    /// - Twitch (clip IDs)
    /// - SoundCloud (artist/track)
    /// - Medium (user/article IDs)
    internal static func extractIDs(from url: URL, platform: Platform) -> [String: String] {
        let path = url.path
        let host = url.host?.lowercased() ?? ""
        
        switch platform {
            // Video Platforms
        case .youtube, .youtubeMusic, .youtubeShorts:
            return extractYouTubeIDs(from: url, host: host)
        case .vimeo:
            return extractVimeoIDs(from: path)
        case .twitch:
            return extractTwitchIDs(from: url, host: host)
            
            // Short-form Video
        case .tiktok:
            return extractTikTokIDs(from: path)
        case .instagram, .instagramReels:
            return extractInstagramIDs(from: path)
            
            // Social Media
        case .twitter:
            return extractTwitterIDs(from: path)
        case .facebook:
            return extractFacebookIDs(from: url)
        case .reddit:
            return extractRedditIDs(from: path)
        case .linkedin:
            return extractLinkedInIDs(from: path)
            
            // Audio/Music
        case .spotify:
            return extractSpotifyIDs(from: path)
        case .soundcloud:
            return extractSoundCloudIDs(from: path)
            
            // Developer
        case .github:
            return extractGitHubIDs(from: path)
            
            // Publishing
        case .medium:
            return extractMediumIDs(from: path)
            
        default:
            return [:]
        }
    }
    
    // MARK: - YouTube
    
    /// Extracts YouTube video ID from various YouTube URL formats
    private static func extractYouTubeIDs(from url: URL, host: String) -> [String: String] {
        var ids: [String: String] = [:]
        
        if host == "youtu.be" {
            // Format: youtu.be/VIDEO_ID
            let videoId = url.path.dropFirst() // Remove leading /
            if !videoId.isEmpty {
                ids["youtube_video_id"] = String(videoId)
            }
        } else if let query = url.query {
            // Format: youtube.com/watch?v=VIDEO_ID
            let params = query.split(separator: "&")
            for param in params {
                let parts = param.split(separator: "=", maxSplits: 1)
                if parts.count == 2 && parts[0] == "v" {
                    ids["youtube_video_id"] = String(parts[1])
                    break
                }
            }
        } else if url.path.contains("/shorts/") {
            // Format: youtube.com/shorts/VIDEO_ID
            let components = url.path.split(separator: "/")
            if let shortsIndex = components.firstIndex(of: "shorts"),
               shortsIndex + 1 < components.count {
                ids["youtube_video_id"] = String(components[shortsIndex + 1])
            }
        }
        
        return ids
    }
    
    // MARK: - Social Media
    
    /// Extracts Twitter/X tweet ID from a URL path
    private static func extractTwitterIDs(from path: String) -> [String: String] {
        var ids: [String: String] = [:]
        
        let components = path.split(separator: "/")
        if let statusIndex = components.firstIndex(of: "status"),
           statusIndex + 1 < components.count {
            ids["tweet_id"] = String(components[statusIndex + 1])
        }
        
        return ids
    }
    
    /// Extracts Instagram post or reel ID from a URL path
    private static func extractInstagramIDs(from path: String) -> [String: String] {
        var ids: [String: String] = [:]
        
        let components = path.split(separator: "/")
        if let postIndex = components.firstIndex(where: { $0 == "p" || $0 == "reel" }),
           postIndex + 1 < components.count {
            ids["instagram_post_id"] = String(components[postIndex + 1])
        }
        
        return ids
    }
    
    /// Extracts TikTok video ID from a URL path
    private static func extractTikTokIDs(from path: String) -> [String: String] {
        var ids: [String: String] = [:]
        
        if let range = path.range(of: "/video/", options: .caseInsensitive) {
            let afterVideo = String(path[range.upperBound...])
            let id = afterVideo
                .components(separatedBy: "/")[0]
                .components(separatedBy: "?")[0]
                .components(separatedBy: "#")[0]
            
            if !id.isEmpty {
                ids["tiktok_video_id"] = id
            }
        }
        
        return ids
    }
    
    /// Extracts Facebook post and video IDs from a URL
    /// - Parameter url: The URL to analyze
    /// - Returns: Dictionary containing facebook_post_id and/or facebook_video_id
    ///
    /// Examples:
    /// - Post: "facebook.com/username/posts/123456789" → ["facebook_post_id": "123456789"]
    /// - Video: "facebook.com/watch/?v=987654321" → ["facebook_video_id": "987654321"]
    private static func extractFacebookIDs(from url: URL) -> [String: String] {
        var ids: [String: String] = [:]
        let path = url.path
        
        // Facebook post: facebook.com/username/posts/123456789
        if path.contains("/posts/") {
            let components = path.split(separator: "/")
            if let postsIndex = components.firstIndex(of: "posts"),
               postsIndex + 1 < components.count {
                ids["facebook_post_id"] = String(components[postsIndex + 1])
            }
        }
        
        // Facebook video: facebook.com/watch/?v=123456789
        if let query = url.query {
            let params = query.split(separator: "&")
            for param in params {
                let parts = param.split(separator: "=", maxSplits: 1)
                if parts.count == 2 && parts[0] == "v" {
                    ids["facebook_video_id"] = String(parts[1])
                    break
                }
            }
        }
        
        return ids
    }
    
    /// Extracts LinkedIn activity ID from a URL path
    private static func extractLinkedInIDs(from path: String) -> [String: String] {
        var ids: [String: String] = [:]
        
        guard path.contains("/posts/") else { return ids }
        
        let components = path.split(separator: "/")
        guard let postsIndex = components.firstIndex(of: "posts"),
              postsIndex + 1 < components.count else { return ids }
        
        let postPart = String(components[postsIndex + 1])
        if let activityID = postPart.split(separator: "-").last.map(String.init) {
            ids["linkedin_activity_id"] = activityID
        }
        
        return ids
    }
    
    /// Extracts Reddit post ID from a URL path
    private static func extractRedditIDs(from path: String) -> [String: String] {
        var ids: [String: String] = [:]
        
        let components = path.split(separator: "/")
        if let commentsIndex = components.firstIndex(of: "comments"),
           commentsIndex + 1 < components.count {
            ids["reddit_post_id"] = String(components[commentsIndex + 1])
        }
        
        return ids
    }
    
    // MARK: - Audio/Music
    
    /// Extracts Spotify content IDs from a URL path
    /// - Parameter path: The URL path to analyze
    /// - Returns: Dictionary containing the Spotify content type and ID
    ///
    /// Supported content types:
    /// - track (songs)
    /// - album (albums)
    /// - playlist (playlists)
    /// - episode (podcast episodes)
    /// - show (podcasts)
    /// - artist (artist profiles)
    ///
    /// Example:
    /// - Input: "/track/4cOdK2wGLETKBW3PvgPWqT"
    /// - Output: ["spotify_track_id": "4cOdK2wGLETKBW3PvgPWqT"]
    private static func extractSpotifyIDs(from path: String) -> [String: String] {
        var ids: [String: String] = [:]
        let components = path.split(separator: "/")
        if components.count >= 2 {
            let type = String(components[components.count - 2])
            let id = String(components[components.count - 1])
            if ["track", "album", "playlist", "episode", "show", "artist"].contains(type) {
                ids["spotify_\(type)_id"] = id
            }
        }
        return ids
    }
    
    /// Extracts SoundCloud artist and track information from a URL path
    /// - Parameter path: The URL path to analyze
    /// - Returns: Dictionary containing soundcloud_artist and soundcloud_track if found
    ///
    /// Example:
    /// - Input: "/artist-name/track-name"
    /// - Output: ["soundcloud_artist": "artist-name", "soundcloud_track": "track-name"]
    private static func extractSoundCloudIDs(from path: String) -> [String: String] {
        var ids: [String: String] = [:]
        
        // SoundCloud track: soundcloud.com/artist/track-name
        let components = path.split(separator: "/").filter { !$0.isEmpty }
        if components.count >= 2 {
            ids["soundcloud_artist"] = String(components[0])
            ids["soundcloud_track"] = String(components[1])
        }
        
        return ids
    }
    
    // MARK: - Video Platforms
    
    /// Extracts Vimeo video ID from a URL path
    private static func extractVimeoIDs(from path: String) -> [String: String] {
        var ids: [String: String] = [:]
        
        let components = path.split(separator: "/")
        
        // Handle player.vimeo.com/video/ID format
        if components.count >= 2 && components[components.count - 2] == "video" {
            let videoID = components.last!
            if videoID.allSatisfy({ $0.isNumber }) {
                ids["vimeo_video_id"] = String(videoID)
            }
        }
        // Handle standard vimeo.com/ID format
        else if let videoID = components.last,
                videoID.allSatisfy({ $0.isNumber }) {
            ids["vimeo_video_id"] = String(videoID)
        }
        
        return ids
    }
    
    /// Extracts Twitch clip ID from a URL
    private static func extractTwitchIDs(from url: URL, host: String) -> [String: String] {
        var ids: [String: String] = [:]
        let path = url.path
        
        // Twitch clip: clips.twitch.tv/ClipName
        if host == "clips.twitch.tv" {
            let clipID = path.dropFirst() // Remove leading /
            if !clipID.isEmpty {
                ids["twitch_clip_id"] = String(clipID)
            }
        }
        // Or: twitch.tv/username/clip/ClipName
        else if path.contains("/clip/") {
            let components = path.split(separator: "/")
            if let clipIndex = components.firstIndex(of: "clip"),
               clipIndex + 1 < components.count {
                ids["twitch_clip_id"] = String(components[clipIndex + 1])
            }
        }
        
        return ids
    }
    
    // MARK: - Developer Platforms
    
    /// Extracts GitHub repository and issue/PR information from a URL path
    /// - Parameter path: The URL path to analyze
    /// - Returns: Dictionary containing github_owner, github_repo, and optionally github_pr_number or github_issue_number
    ///
    /// Supported formats:
    /// - github.com/owner/repo (repository)
    /// - github.com/owner/repo/pull/123 (pull request)
    /// - github.com/owner/repo/issues/456 (issue)
    ///
    /// Example:
    /// - Input: "/apple/swift/pull/12345"
    /// - Output: ["github_owner": "apple", "github_repo": "swift", "github_pr_number": "12345"]
    private static func extractGitHubIDs(from path: String) -> [String: String] {
        var ids: [String: String] = [:]
        let components = path.split(separator: "/").map(String.init)
        
        if components.count >= 2 {
            ids["github_owner"] = components[0]
            ids["github_repo"] = components[1]
            
            if components.count >= 4 {
                if components[2] == "pull" {
                    ids["github_pr_number"] = components[3]
                } else if components[2] == "issues" {
                    ids["github_issue_number"] = components[3]
                }
            }
        }
        
        return ids
    }
    
    // MARK: - Publishing/Blogging
    
    /// Extracts Medium user and article IDs from a URL path
    /// - Parameter path: The URL path to analyze
    /// - Returns: Dictionary containing medium_user and/or medium_article_id
    ///
    /// Example:
    /// - Input: "/@username/article-title-abc123def456"
    /// - Output: ["medium_user": "username", "medium_article_id": "abc123def456"]
    ///
    /// - Note: Medium article IDs are typically 12+ characters and appear after the last dash in the URL
    private static func extractMediumIDs(from path: String) -> [String: String] {
        var ids: [String: String] = [:]
        
        // Medium article: medium.com/@username/article-title-abc123
        guard path.contains("@") else { return ids }
        
        // Split and filter out empty components
        let components = path.split(separator: "/").filter { !$0.isEmpty }
        
        // Extract username
        if let userComponent = components.first(where: { $0.hasPrefix("@") }) {
            ids["medium_user"] = String(userComponent.dropFirst()) // Remove @
        }
        
        // Extract article ID (last component often has article ID at the end)
        if let lastComponent = components.last,
           let dashIndex = lastComponent.lastIndex(of: "-") {
            let articleID = lastComponent[lastComponent.index(after: dashIndex)...]
            if articleID.count > 10 { // Medium IDs are usually long
                ids["medium_article_id"] = String(articleID)
            }
        }
        
        return ids
    }
    
}
