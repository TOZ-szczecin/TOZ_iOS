//
//  AnimalResponseMapper.swift
//  TOZ_iOS
//
//  Copyright © 2017 intive. All rights reserved.
//

import Foundation

/**
 Parses response from OrganizationInfo operation. Inherits from generic ResponseMapper class.
 */
final class AnimalResponseMapper: ResponseMapper<AnimalItem>, ResponseMapperProtocol {
    // swiftlint:disable cyclomatic_complexity function_body_length
    static func process(_ obj: AnyObject?) throws -> AnimalItem {
        return try process(obj, parse: { json in
            guard let animalID = json["id"] as? String else { return nil }
            guard let name = json["name"] as? String else { return nil }
            guard let type = json["type"] as? String else { return nil }
            let animalType: AnimalType
            switch type {
            case "DOG":
                animalType = .DOG
            case "CAT":
                animalType = .CAT
            default:
                return nil
            }
            guard let sex = json["sex"] as? String? else { return nil }
            var animalSex: AnimalSex
            if let sex = sex {
                switch sex {
                case "MALE":
                    animalSex = .MALE
                case "FEMALE":
                    animalSex = .FEMALE
                default:
                    return nil
                }
            } else {
                animalSex = .UNKNOWN
            }
            guard let description = json["description"] as? String? else { return nil }
            guard let address = json["address"] as? String? else { return nil }
            guard let createdInt = json["created"] as? Int? else { return nil }
            var createdDate: Date? = nil
            if let createdInt = createdInt {
                createdDate = Date(timeIntervalSince1970: TimeInterval(createdInt/1000))
            }
            guard let lastModified = json["lastModified"] as? Int? else { return nil }
            var lastModifiedDate: Date? = nil
            if let lastModified = lastModified {
                lastModifiedDate = Date(timeIntervalSince1970: TimeInterval(lastModified/1000))
            }
            guard let imageString = json["imageUrl"] as? String? else { return nil }
            var imageURL: URL? = nil
            if let imageString = imageString {
                imageURL = BackendConfiguration.shared.photosURL.appendingPathComponent(imageString)
            }
            guard let gallery = json["gallery"] as? [[String: Any]]? else { return nil }
            var galleryURLs: [URL] = []
            if let gallery = gallery {
                galleryURLs = gallery.map {
                    BackendConfiguration.shared.photosURL.appendingPathComponent(($0["fileUrl"] as? String) ?? "")
                }
            }
            return AnimalItem(animalID: animalID, name: name, type: animalType, sex: animalSex, description: description, address: address, created: createdDate, lastModified: lastModifiedDate, imageUrl: imageURL, galleryURLs: galleryURLs)
        })
    }
}
