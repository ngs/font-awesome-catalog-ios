//
//  API.swift
//  FontAwesomeCatalog
//
//  Created by Atsushi Nagase on 2022/03/19.
//

import Foundation
import FontAwesome

// MARK: - Response
struct Response: Codable {
    let data: DataClass
}
// MARK: - DataClass
struct DataClass: Codable {
    let release: Release
}

// MARK: - Release
struct Release: Codable {
    let icons: [IconInfo]
}

// MARK: - IconInfo
struct IconInfo: Codable {
    let id, label: String
    let membership: Membership
    let shim: Shim?
    let unicode: String
}

// MARK: - Shim
struct Shim: Codable {
    let id: String
    let name: String?
    let shimPrefix: Prefix?

    enum CodingKeys: String, CodingKey {
        case id, name
        case shimPrefix = "prefix"
    }
}

enum Prefix: String, Codable {
    case fab
    case far
}

// MARK: - Membership
struct Membership: Codable {
    let free, pro: [Style]
}

enum Style: String, Codable {
    case brands
    case duotone
    case light
    case regular
    case solid
    case thin

    init(awesome: FontAwesome.Style) {
        switch awesome {
        case .brands:
            self = .brands
        case .duotone:
            self = .duotone
        case .light:
            self = .light
        case .regular:
            self = .regular
        case .solid:
            self = .solid
        case .thin:
            self = .thin
        }
    }

    var faStyle: FontAwesome.Style {
        switch self {
        case .brands:
            return .brands
        case .duotone:
            return .duotone
        case .light:
            return .light
        case .regular:
            return .regular
        case .solid:
            return .solid
        case .thin:
            return .thin
        }
    }
}
