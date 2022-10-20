//
//  LocationManager.swift
//  WeatherKit
//
//

//https://github.com/raywenderlich/rwi-materials/blob/editions/1.0/03-data-layer-networking/projects/final/PetSave/Core/utils/LocationManager.swift
//https://www.hackingwithswift.com/quick-start/concurrency/how-to-store-continuations-to-be-resumed-later
import CoreLocation
import Combine

public final class LocationManager: NSObject {
    // MARK: - Properties

    public var errorMessages: AnyPublisher<Error, Never> {
        errorMessagesSubject.eraseToAnyPublisher()
    }

    private let errorMessagesSubject = PassthroughSubject<Error, Never>()

    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var lastSeenLocation: CLLocation?

    private let cllLocationManager: CLLocationManager
    private let requestManager: RequestManagerProtocol
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D?, Error>?

    // MARK: - LifeCicle

    public init(
        authorizationStatus: CLAuthorizationStatus = .notDetermined,
        requestManager: RequestManagerProtocol = RequestManager()
    ) {
        self.authorizationStatus = authorizationStatus
        self.cllLocationManager = CLLocationManager()
        self.requestManager = requestManager
        super.init()
        cllLocationManager.delegate = self
        cllLocationManager.desiredAccuracy = kCLLocationAccuracyReduced
        self.authorizationStatus = cllLocationManager.authorizationStatus
    }

    // MARK: - Metods

    public func updateAuthorizationStatus() {
        authorizationStatus = cllLocationManager.authorizationStatus
    }

    public func requestWhenInUseAuthorization() {
        cllLocationManager.requestWhenInUseAuthorization()
    }

    public func checkAuthorization(
        onSuccess: (() -> Void)? = nil,
        onDenied: (() -> Void)? = nil,
        onRestricted: (() -> Void)? = nil
    ) {
        switch authorizationStatus {
            case .notDetermined:
                cllLocationManager.requestWhenInUseAuthorization()

            case .authorizedAlways, .authorizedWhenInUse:
                onSuccess?()

            case .denied:
                onDenied?()

            case .restricted:
                onRestricted?()

            @unknown default:
                break
        }
    }

    @discardableResult
    public func requestLocation() async throws -> CLLocationCoordinate2D? {
        try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation
            cllLocationManager.requestLocation()
        }
    }

    public func startUpdatingLocation() {
        cllLocationManager.startUpdatingLocation()
    }
}

// MARK: - Location status
extension LocationManager {
    public var isLocationEnabled: Bool {
        authorizationStatus != .denied &&
        authorizationStatus != .notDetermined &&
        authorizationStatus != .restricted
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        updateAuthorizationStatus()
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastSeenLocation = locations.first
        locationContinuation?.resume(returning: locations.first?.coordinate)
        locationContinuation = nil
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if locationContinuation != nil {
            locationContinuation?.resume(throwing: error)
        } else {
            errorMessagesSubject.send(error)
        }
    }
}

// MARK: - Geocder methods
extension LocationManager {
    func getAddressesForCurrentLocality() async throws -> [LocationAddress] {
        guard let coordinate = lastSeenLocation?.coordinate else {
            return []
        }

        return try await getAddressesFor(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }

    func getCurrentAddress() async throws -> LocationAddress? {
        try await requestLocation()
        let addresses = try await getAddressesForCurrentLocality()

        return addresses.first
    }

    func getAddressesFor(latitude: Double, longitude: Double) async throws -> [LocationAddress] {
        let response: Geocoder.GeocoderAPIResponse = try await requestManager.perform(
            GeocoderRequest.getAddressFor(latitude: latitude, longitude: longitude)
        )

        return response.response
            .geoObjectCollection
            .featureMember
            .compactMap { $0.localityAddress }
    }

    func getAddressesFor(locality: String) async throws -> [LocationAddress] {
        let response: Geocoder.GeocoderAPIResponse = try await requestManager.perform(
            GeocoderRequest.getCoordinatesFor(locality: locality)
        )

        return response.response
            .geoObjectCollection
            .featureMember
            .compactMap { $0.localityAddress }
    }

    func getTimeZoneFor(latitude: Double, longitude: Double) async throws -> String {
        let response: WeatherPack = try await requestManager.perform(
            WeatherRequest.getCurrentWeatherFor(latitude: latitude,
                                                longitude: longitude)
        )
        return response.timezone
    }
}

fileprivate extension Geocoder.FeatureMember {
    var localityAddress: LocationAddress? {
        let components = geoObject.metaDataProperty.geocoderMetaData.address.components
        let point = geoObject.point

        guard
            let country = components.first(where: { $0.kind == .country})
        else {
            return nil
        }

        let city: Geocoder.Component

        if let locality = components.last(where: { $0.kind == .locality }) {
            city = locality
        } else if let locality = components.last {
            city = locality
        } else {
            return nil
        }

        return LocationAddress(city: city.name,
                               country: country.name,
                               latitude: point.latitude,
                               longitude: point.longitude)
    }
}
