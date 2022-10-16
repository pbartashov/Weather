//
//  LocationManager.swift
//  WeatherKit
//
//

//https://github.com/raywenderlich/rwi-materials/blob/editions/1.0/03-data-layer-networking/projects/final/PetSave/Core/utils/LocationManager.swift
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
        cllLocationManager.startUpdatingLocation()
    }

    // MARK: - Metods

    public func updateAuthorizationStatus() {
        authorizationStatus = cllLocationManager.authorizationStatus
    }

    public func requestWhenInUseAuthorization() {
        cllLocationManager.requestWhenInUseAuthorization()
    }

    public func startUpdatingLocation() {
        cllLocationManager.startUpdatingLocation()
    }
}

// MARK: - Location status
extension LocationManager {
    public var locationIsEnabled: Bool {
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

    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else { return }
        lastSeenLocation = location
    }

    public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        errorMessagesSubject.send(error)
    }
}

// MARK: - Geocder methods
extension LocationManager {
    func getAddressesForCurrentLocation() async throws -> [LocationAddress] {
        guard let coordinate = lastSeenLocation?.coordinate else {
            return []
        }

        return try await getAddressFor(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }

    func getAddressFor(latitude: Double, longitude: Double) async throws -> [LocationAddress] {
        let response: Geocoder.GeocoderAPIResponse = try await requestManager.perform(
            GeocoderRequest.getAddressFor(latitude: latitude, longitude: longitude)
        )
    
        return []
    }

    func getCoordinatesFor(locality: String) async throws -> [LocationAddress] {
        let response: Geocoder.GeocoderAPIResponse = try await requestManager.perform(
            GeocoderRequest.getCoordinatesFor(locality: locality)
        )

        return []
    }
}
