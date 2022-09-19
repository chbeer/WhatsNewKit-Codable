# WhatsNewKit-Codable

Add-on for [WhatsNewKit](https://github.com/SvenTiigi/WhatsNewKit.git) that adds Codable support for the data models.

NOTE: Currently only decoding is implemented. 

## But Why?

Creating the WhatsNew information in code is nice and type safe, but makes internationalization (i18n) harder.

Instead of putting each text in a `.strings` file and referencing it, you can put the whole structure into a JSON file for each language:

```
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
```

One downside of this: actions and images are referenced with a string, instead of a safe assignment. 

Images and Actions need to be registered beforehand. You can see this in action in the Tests.

## Registration of Image, PrimaryAction and SecondaryAction

### Image

```
WhatsNew.register(
    image: .init(systemName: "star.fill"),
    as: "star.fill"
)
```

### Primary Action

```
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
```

### SecondaryAction

```
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
```
