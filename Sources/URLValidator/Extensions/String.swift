//
//  String.swift
//  URLValidator
//
//  Created by David Sherlock on 09/08/2025.
//

import Foundation

extension String {
    
    /// Helper to check if string is empty after trimming whitespace
    internal var nilIfEmpty: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
    
    // MARK: - URL Validation
    
    /// Checks if the string is a valid URL
    public var isValidURL: Bool {
        URLValidator.isValid(self)
    }
    
    /// Normalizes the URL string
    public var normalizedURL: String {
        URLValidator.normalize(self)
    }
    
    /// Analyzes the URL and returns comprehensive information
    public var urlAnalysis: URLAnalysis {
        URLValidator.analyze(self)
    }
    
    // MARK: - Platform Detection
    
    /// Gets the platform for this URL
    public var urlPlatform: Platform? {
        let platform = URLValidator.detectPlatform(from: self)
        return platform != .unknown ? platform : nil
    }
    
    /// Gets the platform category for this URL
    public var urlPlatformCategory: PlatformCategory? {
        guard let platform = urlPlatform else { return nil }
        return URLValidator.category(for: platform)
    }
    
    // MARK: - Media Type Detection
    
    /// Detects the media type from the URL's file extension
    public var urlMediaType: MediaType? {
        let mediaType = URLValidator.detectMediaType(from: self)
        return mediaType != .unknown ? mediaType : nil
    }
    
    // MARK: - Platform Category Checks
    
    /// Checks if URL is from a video platform
    public var isVideoPlatformURL: Bool {
        urlPlatformCategory == .video
    }
    
    /// Checks if URL is from an audio platform
    public var isAudioPlatformURL: Bool {
        urlPlatformCategory == .audio
    }
    
    /// Checks if URL is from a social media platform
    public var isSocialMediaURL: Bool {
        urlPlatformCategory == .social
    }
    
    /// Checks if URL is from a messaging platform
    public var isMessagingPlatformURL: Bool {
        urlPlatformCategory == .messaging
    }
    
    /// Checks if URL is from a developer platform
    public var isDeveloperPlatformURL: Bool {
        urlPlatformCategory == .developer
    }
    
    /// Checks if URL is from an alternative tech platform
    public var isAlternativePlatformURL: Bool {
        urlPlatformCategory == .alternative
    }
    
    /// Checks if URL is from a Web3/crypto platform
    public var isWeb3PlatformURL: Bool {
        urlPlatformCategory == .web3
    }
    
    /// Checks if URL is from a gaming platform
    public var isGamingPlatformURL: Bool {
        urlPlatformCategory == .gaming
    }
    
    /// Checks if URL is from a financial platform
    public var isFinancialPlatformURL: Bool {
        urlPlatformCategory == .financial
    }
    
    /// Checks if URL is from a dating platform
    public var isDatingPlatformURL: Bool {
        urlPlatformCategory == .dating
    }
    
    /// Checks if URL is from a subscription/creator platform
    public var isSubscriptionPlatformURL: Bool {
        urlPlatformCategory == .subscription
    }
    
    // MARK: - File Type Checks
    
    /// Checks if URL has a video file extension
    public var hasVideoExtension: Bool {
        urlMediaType == .video
    }
    
    /// Checks if URL has an audio file extension
    public var hasAudioExtension: Bool {
        urlMediaType == .audio
    }
    
    /// Checks if URL has an image file extension
    public var hasImageExtension: Bool {
        urlMediaType == .image
    }
    
    /// Checks if URL has a document file extension
    public var hasDocumentExtension: Bool {
        urlMediaType == .document
    }
    
    // MARK: - Security Checks
    
    /// Checks if URL uses HTTPS
    public var isHTTPS: Bool {
        URL(string: normalizedURL)?.scheme == "https"
    }
    
    /// Checks if URL uses HTTP
    public var isHTTP: Bool {
        URL(string: normalizedURL)?.scheme == "http"
    }
    
    /// Checks if URL is a file URL
    public var isFileURL: Bool {
        URL(string: normalizedURL)?.isFileURL ?? false
    }
    
    // MARK: - URL Components
    
    /// Gets the domain from the URL
    public var urlDomain: String? {
        URL(string: normalizedURL)?.host
    }
    
    /// Gets the path from the URL
    public var urlPath: String? {
        guard let path = URL(string: normalizedURL)?.path,
              !path.isEmpty else { return nil }
        return path
    }
    
    /// Gets the query string from the URL
    public var urlQuery: String? {
        URL(string: normalizedURL)?.query
    }
    
    /// Gets the file extension from the URL
    public var urlExtension: String? {
        guard let url = URL(string: normalizedURL) else { return nil }
        let ext = url.pathExtension
        return ext.isEmpty ? nil : ext.lowercased()
    }
    
    // MARK: - ID Extraction
    
    /// Extracts YouTube video ID from the URL
    public var youtubeVideoID: String? {
        urlAnalysis.extractedIDs["youtube_video_id"]
    }
    
    /// Extracts Twitter/X tweet ID from the URL
    public var tweetID: String? {
        urlAnalysis.extractedIDs["tweet_id"]
    }
    
    /// Extracts Instagram post ID from the URL
    public var instagramPostID: String? {
        urlAnalysis.extractedIDs["instagram_post_id"]
    }
    
    /// Extracts TikTok video ID from the URL
    public var tiktokVideoID: String? {
        urlAnalysis.extractedIDs["tiktok_video_id"]
    }
    
    /// Extracts Spotify content ID from the URL
    public var spotifyID: String? {
        let analysis = urlAnalysis
        return analysis.extractedIDs.first { $0.key.hasPrefix("spotify_") }?.value
    }
    
    /// Extracts Reddit post ID from the URL
    public var redditPostID: String? {
        urlAnalysis.extractedIDs["reddit_post_id"]
    }
    
    /// Extracts GitHub repository info from the URL
    public var githubRepo: (owner: String, repo: String)? {
        let analysis = urlAnalysis
        guard let owner = analysis.extractedIDs["github_owner"],
              let repo = analysis.extractedIDs["github_repo"] else { return nil }
        return (owner, repo)
    }
    
}
