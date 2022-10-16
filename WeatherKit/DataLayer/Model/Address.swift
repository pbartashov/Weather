//
//  Address.swift
//  WeatherKit
//
//  Created by Павел Барташов on 16.10.2022.
//

import Foundation



public struct LocationAddress {
    let city: String
    let country: String

    public init(city: String, country: String) {
        self.city = city
        self.country = country
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
        //    let point: Point

        enum CodingKeys: String, CodingKey {
            case metaDataProperty//, name
            //        case geoObjectDescription = "description"
            //        case point = "Point"
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

    enum Kind: String, Codable {
        case area = "area"
        case country = "country"
        case locality = "locality"
        case province = "province"
    }
}
