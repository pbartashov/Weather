//
//  Address.swift
//  WeatherKit
//
//  Created by Павел Барташов on 16.10.2022.
//

import Foundation



public struct LocationAddress: Hashable {
    public let city: String
    public let country: String
    public let latitude: Double
    public let longitude: Double

    public init(city: String,
                country: String,
                latitude: Double,
                longitude : Double
    ) {
        self.city = city
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }
}



#warning("//enem Geocoder namespace {}")

public enum Geocoder {

    // MARK: - GeocoderAPIResponse
    public struct GeocoderAPIResponse: Codable {
        let response: GeocoderResponse
        enum CodingKeys: String, CodingKey {
            case response
        }
    }

    //extension GeocoderResponse: Decodable {
    //    public init(from decoder: Decoder) throws {
    //        let container = try decoder.container(keyedBy: CodingKeys.self)
    //
    //        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0.0
    //        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0.0
    //
    //        timezone = try container.decodeIfPresent(String.self, forKey: .timezone) ?? ""
    //    }
    //}


    // MARK: - Response
    struct GeocoderResponse: Codable {
        let geoObjectCollection: GeoObjectCollection

        enum CodingKeys: String, CodingKey {
            case geoObjectCollection = "GeoObjectCollection"
        }
    }

    // MARK: - GeoObjectCollection
    struct GeoObjectCollection: Codable {
        //    let metaDataProperty: GeoObjectCollectionMetaDataProperty
        let featureMember: [FeatureMember]
    }

    // MARK: - FeatureMember
    struct FeatureMember: Codable {
        let geoObject: GeoObject

        enum CodingKeys: String, CodingKey {
            case geoObject = "GeoObject"
        }
    }

    // MARK: - GeoObject
    struct GeoObject: Codable {
        let metaDataProperty: GeoObjectMetaDataProperty
        //    let name: String
        //    let geoObjectDescription: Description
        let point: Point

        enum CodingKeys: String, CodingKey {
            case metaDataProperty//, name
            //        case geoObjectDescription = "description"
            case point = "Point"
        }
    }

    // MARK: - Point
    struct Point: Codable {
//        let pos: String
        let latitude: Double
        let longitude: Double

        enum CodingKeys: String, CodingKey {
            case pos
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            let pos = try container.decodeIfPresent(String.self, forKey: .pos) ?? ""
            let values = pos.split(separator: " ")

            longitude = Double(values.first ?? "0") ?? 0.0
            latitude = Double(values.last ?? "0") ?? 0.0
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            let pos = "\(longitude)\(latitude)"
            try container.encode(pos, forKey: .pos)
        }
    }

    // MARK: - GeoObjectMetaDataProperty
    struct GeoObjectMetaDataProperty: Codable {
        let geocoderMetaData: GeocoderMetaData

        enum CodingKeys: String, CodingKey {
            case geocoderMetaData = "GeocoderMetaData"
        }
    }

    // MARK: - GeocoderMetaData
    struct GeocoderMetaData: Codable {
        //    let text: String
        //    let kind: Kind
        let address: Address

        enum CodingKeys: String, CodingKey {
            //        case text, kind
            case address = "Address"
        }
    }

    // MARK: - Address
    struct Address: Codable {
        //    let countryCode: CountryCode
        //    let formatted: String
        let components: [Component]

        enum CodingKeys: String, CodingKey {
            //        case countryCode = "country_code"
            //        case formatted
            case components = "Components"
        }
    }

    // MARK: - Component
    struct Component: Codable {
        let kind: Kind
        let name: String
    }

    enum Kind: String, Codable, Equatable {
        case unknown
//        case area = "area"
        case country = "country"
        case locality = "locality"
        case province = "province"

        init?(rawValue: String) {
            switch rawValue {
                case Kind.country.rawValue:
                    self = .country

                case Kind.locality.rawValue:
                    self = .locality

                case Kind.province.rawValue:
                    self = .province

                default:
                    self = .unknown

            }
        }
    }
}
