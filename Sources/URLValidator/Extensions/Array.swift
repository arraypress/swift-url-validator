//
//  Array.swift
//  URLValidator
//
//  Created by David Sherlock on 09/08/2025.
//

import Foundation

extension Array where Element == String {
    
    /// Filters URLs by platform
    public func filterURLs(platform: Platform) -> [String] {
        filter { $0.urlPlatform == platform }
    }
    
    /// Filters URLs by platform category
    public func filterURLs(category: PlatformCategory) -> [String] {
        filter { $0.urlPlatformCategory == category }
    }
    
    /// Filters URLs by media type
    public func filterURLs(mediaType: MediaType) -> [String] {
        filter { $0.urlMediaType == mediaType }
    }
    
    /// Groups URLs by platform
    public func groupURLsByPlatform() -> [Platform: [String]] {
        Dictionary(grouping: self) { url in
            URLValidator.detectPlatform(from: url)
        }
    }
    
    /// Groups URLs by platform category
    public func groupURLsByCategory() -> [PlatformCategory: [String]] {
        Dictionary(grouping: self) { url in
            url.urlPlatformCategory ?? .unknown
        }
    }
    
    /// Groups URLs by media type
    public func groupURLsByMediaType() -> [MediaType: [String]] {
        Dictionary(grouping: self) { url in
            URLValidator.detectMediaType(from: url)
        }
    }
    
    /// Filters and returns only valid URLs
    public var validURLs: [String] {
        filter { $0.isValidURL }
    }
    
    /// Filters and returns only HTTPS URLs
    public var httpsURLs: [String] {
        filter { $0.isHTTPS }
    }
    
    /// Filters and returns only alternative platform URLs
    public var alternativePlatformURLs: [String] {
        filter { $0.isAlternativePlatformURL }
    }
    
    /// Filters and returns only Web3 platform URLs
    public var web3URLs: [String] {
        filter { $0.isWeb3PlatformURL }
    }
    
    /// Filters and returns only gaming platform URLs
    public var gamingURLs: [String] {
        filter { $0.isGamingPlatformURL }
    }
    
    /// Filters and returns only dating platform URLs
    public var datingURLs: [String] {
        filter { $0.isDatingPlatformURL }
    }
    
}
