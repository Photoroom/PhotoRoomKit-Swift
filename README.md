# PhotoRoomKit

[![Version](https://img.shields.io/cocoapods/v/PhotoRoomKit.svg?style=flat)](http://cocoadocs.org/docsets/PhotoRoomKit)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/PhotoRoomKit.svg?style=flat)](http://cocoadocs.org/docsets/PhotoRoomKit)
[![Platform](https://img.shields.io/cocoapods/p/PhotoRoomKit.svg?style=flat)](http://cocoadocs.org/docsets/PhotoRoomKit)
![Swift](https://img.shields.io/badge/%20in-swift%205.0-orange.svg)

## Description

**PhotoRoomKit** is a fast background removal API. Power your app with the background removal technology used by millions of sellers every month.

## Installation

**PhotoRoomKit** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PhotoRoomKit'
```

**PhotoRoomKit** is also available through [Carthage](https://github.com/Carthage/Carthage).
To install just write into your Cartfile:

```ruby
github "PhotoRoom/PhotoRoomKit"
```

**PhotoRoomKit** can also be installed manually. Just download and drop `Sources` folders in your project.

## Usage

First you will need an API Key, go to [our API website](https://photoroom.com/api) to get your own PhotoRoom key.

Then, you can either use the provided `PhotoRoomViewController`, or use the API wrapper

#### PhotoRoomViewController

Just present `PhotoRoomViewController` and handle the callback
```swift
func removeBackground(_ originalImage: UIImage) {
    let controller = PhotoRoomViewController(image: originalImage,
                                                       apiKey: 'YOUR_API_KEY') { [weak self] image in
        self?.onImageEdited(image)

    }
    present(controller, animated: true)
}

func onImageEdited(_ editedImage: UIImage) {
    // Handle your segmented image
}
```
When using the built-in view controller, Photoroom attribution is done for you, no need for extra work.

#### API wrapper

You can also use the API wrapper directly.
```swift
let segmentationService = SegmentationService(apiKey: apiKey)
segmentationService.segment(image: originalImage) { (image, error) in
    DispatchQueue.main.async {
        if let error = error {
            // An error occured
        }
        guard let image = image else {
            // No image returned
            return
        }
        // All good
    }
}
```

⚠️ If you use the API wrapper, you'll need to provide correct attribution according to [our API guideline](https://www.notion.so/photoroom/API-Documentation-public-4eb3e45d9c814f92b6392b7fd0f1d51f#7ac1c3bd30fd426ea092e126f4b59c77).

## Author

PhotoRoom, hello@photoroom.com

## Contributing

We would love you to contribute to **PhotoRoomKit**, check the [CONTRIBUTING](https://github.com/PhotoRoom/PhotoRoomKit/blob/master/CONTRIBUTING.md) file for more info.

## License

**PhotoRoomKit** is available under the MIT license. See the [LICENSE](https://github.com/PhotoRoom/PhotoRoomKit/blob/master/LICENSE) file for more info.
