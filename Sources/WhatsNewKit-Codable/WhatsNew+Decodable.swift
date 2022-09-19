//
//  WhatsNew+Decodable.swift
//  
//
//  Created by Christian Beer on 19.09.22.
//

import Foundation
import SwiftUI
import WhatsNewKit

/// Decodable extension for WhatsNew. Actions and Images are registered by string.
extension WhatsNew: Decodable {
    
    static var imageRegistry: [String:Feature.Image] = [:]
    static var primaryActionsRegistry: [String:PrimaryAction] = [:]
    static var secondaryActionsRegistry: [String:SecondaryAction] = [:]
    
    enum DecodeError: Error {
        case primaryActionMissing, imageNotFound(String)
    }
    
    public static func register(image: Feature.Image, as key: String) {
        imageRegistry[key] = image
    }
    public static func register(primaryAction action: PrimaryAction, as key: String) {
        primaryActionsRegistry[key] = action
    }
    public static func register(secondaryAction action: SecondaryAction, as key: String) {
        secondaryActionsRegistry[key] = action
    }
    
    // MARK: - Coding
    
    enum CodingKeys: String, CodingKey {
        case version, title, features, primaryAction, secondaryAction
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let version = try container.decode(Version.self, forKey: .version)
        let titleString = try container.decode(String.self, forKey: .title)
        let features = try container.decode([Feature].self, forKey: .features)
        let primaryActionId = try container.decode(String.self, forKey: .primaryAction)
        let secondaryActionId = try container.decode(String.self, forKey: .secondaryAction)
        
        guard let primaryAction = WhatsNew.primaryActionsRegistry[primaryActionId] else {
            throw DecodeError.primaryActionMissing
        }

        self.init(
            version: version,
            title: Title(stringLiteral: titleString),
            features: features,
            primaryAction: primaryAction,
            secondaryAction: WhatsNew.secondaryActionsRegistry[secondaryActionId]
        )
    }

}

extension WhatsNew.Version: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let version = try container.decode(String.self)
        self.init(stringLiteral: version)
    }
}
extension WhatsNew.Title: Decodable {
    enum CodingKeys: String, CodingKey { case text, foregroundColor }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let textString = try container.decode(String.self, forKey: .text)
        let foregroundColorString = try container.decode(String.self, forKey: .foregroundColor)
        self.init(text: WhatsNew.Text(textString), foregroundColor: Color(foregroundColorString))
    }
}
extension WhatsNew.Text: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        self.init(string)
    }
}
extension WhatsNew.Feature: Decodable {
    enum CodingKeys: String, CodingKey { case image, title, subtitle }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let imageString = try container.decode(String.self, forKey: .image)
        let title = try container.decode(WhatsNew.Text.self, forKey: .title)
        let subtitle = try container.decode(WhatsNew.Text.self, forKey: .subtitle)
        
        guard let image = WhatsNew.imageRegistry[imageString] else {
            throw WhatsNew.DecodeError.imageNotFound(imageString)
        }
        
        self.init(image: image, title: title, subtitle: subtitle)
    }
}
