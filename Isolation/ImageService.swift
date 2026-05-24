//
//  ImageService.swift
//  Isolation
//
//  Created by Kasra Babaei on 2026-05-13.
//

import Foundation
import UIKit

typealias ImageCompletion = (ImageResponse) -> Void
enum ImageResponse: @unchecked Sendable {

    case cached(image: UIImage)
    case fetched(image: UIImage)
    case error(Error)
}

protocol ImageService: Sendable {
    func image(completion: @escaping ImageCompletion)
}

struct ServiceLocator: Sendable {
    static let shared = ServiceLocator()
    let imageService: ImageService = ProductionImageService()
}

final class ProductionImageService: ImageService, @unchecked Sendable {
    var cache: [String: UIImage] = [:]

    func image(completion: @escaping ImageCompletion) {
        nonisolated(unsafe) let completion = completion

        if let image = cache["star.fill"] {
            completion(.cached(image: image))
        }
        let image = UIImage(systemName: "star.fill")!
        DispatchQueue.main.async { completion(.fetched(image: image)) }
    }

    func foo() {

    }
}
private final class ImageServiceViewController: UIViewController {
    private let imageView = UIImageView()

    func loadImage() {
        ServiceLocator.shared.imageService.image { [weak self] response in
            DispatchQueue.main.async {
                switch response {
                case .cached(let image): self?.imageView.image = image
                case .fetched(let image): self?.imageView.image = image
                case .error: break
                }
            }
        }
    }
}
