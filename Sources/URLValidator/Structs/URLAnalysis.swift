//
//  URLAnalysis.swift
//  URLValidator
//
//  Created by David Sherlock on 09/08/2025.
//

import Foundation
import UniformTypeIdentifiers

/// Comprehensive analysis of a URL
public struct URLAnalysis: Sendable {
    public let originalURL: String
    public var isValid: Bool = false
    public var url: URL?
    
    // Basic properties
    public var scheme: String?
    public var host: String?
    public var path: String?
    public var query: String?
    public var fragment: String?
    public var port: Int?
    
    // Security
    public var isHTTPS: Bool = false
    public var isHTTP: Bool = false
    public var isFileURL: Bool = false
    
    // Platform detection
    public var platform: Platform = .unknown
    public var platformCategory: PlatformCategory = .unknown
    
    // Media type detection
    public var mediaType: MediaType = .unknown
    public var fileExtension: String?
    public var utType: UTType?
    public var mimeType: String?
    public var fileTypeDescription: String?
    
    // Extracted IDs
    public var extractedIDs: [String: String] = [:]
    
    /// A human-readable summary of the analysis
    public var summary: String {
        var parts: [String] = []
        
        if platform != .unknown {
            parts.append(platform.rawValue)
        }
        
        if mediaType != .unknown {
            parts.append(mediaType.rawValue)
        }
        
        if let ext = fileExtension {
            parts.append(".\(ext)")
        }
        
        if isHTTPS {
            parts.append("Secure")
        }
        
        if !extractedIDs.isEmpty {
            parts.append("\(extractedIDs.count) ID(s)")
        }
        
        return parts.isEmpty ? "Invalid URL" : parts.joined(separator: " • ")
    }
    
}
