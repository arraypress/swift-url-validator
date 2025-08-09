//
//  MediaType.swift
//  URLValidator
//
//  Created by David Sherlock on 09/08/2025.
//

import Foundation

/// Media types for URL content
public enum MediaType: String, CaseIterable, Sendable {
    case image = "Image"
    case video = "Video"
    case audio = "Audio"
    case document = "Document"
    case archive = "Archive"
    case code = "Code"
    case data = "Data"
    case executable = "Executable"
    case font = "Font"
    case model3d = "3D Model"
    case unknown = "Unknown"
}
