import XCTest
import WhatsNewKit
@testable import WhatsNewKit_Codable
import SwiftUI

final class WhatsNewKit_DecodableTests: XCTestCase {
    func testExample() throws {
        
        let json = """
{
    "version": "1.0.0",
    "title": "What's New",
    "features": [
        {
            "image": "star.fill",
            "title": "Title",
            "subtitle": "Subtitle"
        }
    ],
    "primaryAction": "continue",
    "secondaryAction": "learnMore"
}
"""
        WhatsNew.register(
            image: .init(systemName: "star.fill"),
            as: "star.fill"
        )
        WhatsNew.register(
            primaryAction: .init(
                title: "Continue",
                backgroundColor: .accentColor,
                foregroundColor: .white,
                hapticFeedback: .notification(.success),
                onDismiss: {
                    print("WhatsNewView has been dismissed")
                }
            ),
            as: "continue"
        )
        WhatsNew.register(
            secondaryAction: .init(
                title: "Learn more",
                foregroundColor: .accentColor,
                hapticFeedback: .selection,
                action: .openURL(
                    .init(string: "https://github.com/SvenTiigi/WhatsNewKit")
                )
            ),
            as: "learnMore"
        )
        
        let decoder = JSONDecoder()
        let whatsNew = try decoder.decode(WhatsNew.self, from: json.data(using: .utf8)!)
        
        XCTAssertEqual(whatsNew.version, "1.0.0")
        XCTAssertEqual(whatsNew.title, "What's New")
        XCTAssertNotNil(whatsNew.features[0].image)
        XCTAssertEqual(whatsNew.features[0].title, "Title")
        XCTAssertEqual(whatsNew.features[0].subtitle, "Subtitle")
        XCTAssertEqual(whatsNew.primaryAction.title, "Continue")
        XCTAssertEqual(whatsNew.primaryAction.backgroundColor, .accentColor)
        XCTAssertEqual(whatsNew.primaryAction.foregroundColor, .white)
        XCTAssertEqual(whatsNew.primaryAction.hapticFeedback, .notification(.success))
        XCTAssertEqual(whatsNew.secondaryAction!.title, "Learn more")
        XCTAssertEqual(whatsNew.secondaryAction!.foregroundColor, .accentColor)
        XCTAssertEqual(whatsNew.secondaryAction!.hapticFeedback, .selection)
    }
}
