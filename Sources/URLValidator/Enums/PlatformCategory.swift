//
//  PlatformCategory.swift
//  URLValidator
//
//  Created by David Sherlock on 09/08/2025.
//

import Foundation

/// Categories for grouping platforms
public enum PlatformCategory: String, CaseIterable, Sendable {
    case video = "Video"
    case audio = "Audio"
    case social = "Social Media"
    case messaging = "Messaging"
    case developer = "Developer"
    case ecommerce = "E-commerce"
    case cloud = "Cloud Storage"
    case streaming = "Live Streaming"
    case productivity = "Productivity"
    case maps = "Maps"
    case news = "News & Publishing"
    case learning = "E-Learning"
    case web3 = "Web3 & Crypto"
    case gaming = "Gaming"
    case financial = "Financial"
    case dating = "Dating"
    case food = "Food Delivery"
    case travel = "Travel & Booking"
    case subscription = "Subscription Platforms"
    case alternative = "Alternative Tech"
    case regional = "Regional"
    case unknown = "Unknown"
}
