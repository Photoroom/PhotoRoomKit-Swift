//
//  SegmentationService.swift
//  api-demo
//
//  Created by Eliot Andres on 22/03/2021.
//

import Foundation
import UIKit

/// Service to remove background from any image
public final class SegmentationService {

    /// Handler containing the possible segmented image
    public typealias SegmentationCallback = (UIImage?, Error?) -> Void

    private let apiKey: String
    private enum K {
        static let hostURL = URL(string: "https://sdk.photoroom.com/v1/segment")!
    }

    /// - Parameters:
    ///     - apiKey: PhotoRoom API key
    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    /// Segment the image to a white background
    /// - Parameters:
    ///     - image: The image you want to remove background
    ///     - onCompletion: Called once the segmentation is over. See `SegmentationCallback` for more detail
    public func segment(image: UIImage,
                        onCompletion: @escaping SegmentationCallback) {

        guard apiKey.isEmpty == false else {
            onCompletion(nil, SegmentationError.noAPIKey)
            return
        }

        var request = URLRequest(url: K.hostURL)
        request.httpMethod = "POST"
        request.timeoutInterval = 30.0
        
        let scale = image.scaled(maxDimensions: CGSize(width: 1000, height: 1000))
        //TODO improve image orientation management
        let scaledImage = image.scaled(by: scale)

        guard let media = Media(withImage: scaledImage, forKey: "image_file") else {
            onCompletion(nil, SegmentationError.invalidData)
            return
        }

        let boundary = Self.generateBoundary()
        let body = Self.createDataBody(with: media, boundary: boundary)

        request.httpBody = body

        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request, completionHandler: { responseData, response, error in
            guard let responseData = responseData,
                  let response = response as? HTTPURLResponse, error == nil else {
                onCompletion(nil, SegmentationError.serverError)
                return
            }

            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                onCompletion(nil, SegmentationError.serverError)
                return
            }

            guard let imageData = UIImage(data: responseData) else {
                print("Error decoding server response")
                onCompletion(nil, SegmentationError.serverError)
                return
            }
            onCompletion(imageData, nil)
        })
        task.resume()
        
    }

    private static func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

    private static func createDataBody(with media: Media, boundary: String) -> Data {

        let lineBreak = "\r\n"
        var body = Data()

        body.appendString("--\(boundary + lineBreak)")
        body.appendString("Content-Disposition: form-data; name=\"\(media.key)\"; filename=\"\(media.fileName)\"\(lineBreak)")
        body.appendString("Content-Type: \(media.mimeType + lineBreak + lineBreak)")
        body.append(media.data)
        body.appendString(lineBreak)
        body.appendString("--\(boundary)--\(lineBreak)")

        return body
    }
}

struct Media {
    let key: String
    let fileName: String
    let data: Data
    let mimeType: String

    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpg"
        self.fileName = "\(arc4random()).jpeg"

        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}

extension Data {
    mutating func appendString(_ string: String) {
        let data = string.data(using: .utf8)
        append(data!)
    }
}

enum SegmentationError: Error {
    case invalidData
    case serverError
    case noAPIKey
}

extension SegmentationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidData:
            return NSLocalizedString("Data of image is not valid.", comment: "")
        case .serverError:
            return NSLocalizedString("There was a server error.", comment: "")
        case .noAPIKey:
            return NSLocalizedString("There is no key for the PhotoRoom API.", comment: "")
        }
    }
}


