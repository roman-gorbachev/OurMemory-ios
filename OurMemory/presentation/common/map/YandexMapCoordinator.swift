import UIKit
import YandexMapsMobile

final class YandexMapCoordinator: NSObject, YMKClusterListener, YMKClusterTapListener, YMKMapObjectTapListener,
    YMKMapInputListener, YMKLocationDelegate, YMKUserLocationObjectListener {
    private static let clusterRadius = 60.0
    private static let clusterMinZoom: UInt = 19
    private static let clusterZoomStep: Float = 2
    private static let routeStrokeWidth: Float = 4
    private static let fitZoomMargin: Float = 0.5
    private static let stopZoom: Float = 19
    private static let myLocationZoom: Float = 18
    private static let cameraAnimationSeconds: Float = 0.4
    private static let accuracyStrokeWidth: Float = 1
    private static let accuracyFillAlpha = 0.15
    private static let accuracyStrokeAlpha = 0.4
    private static let noRotation: Float = 0

    var onMarkerTap: ((String) -> Void)?
    var onStopTap: ((Int) -> Void)?
    var onMapTap: ((Double, Double) -> Void)?

    private weak var mapView: YMKMapView?
    private var markersCollection: YMKClusterizedPlacemarkCollection?
    private var plainCollection: YMKMapObjectCollection?
    private var routeCollection: YMKMapObjectCollection?
    private var userLocationLayer: YMKUserLocationLayer?
    private var locationManager: YMKLocationManager?
    private var appliedContent: MapContent?
    private var appliedCamera: MapCamera?
    private var appliedLocationRequest = 0
    private var hasFittedRoute = false

    func attach(to mapView: YMKMapView) {
        self.mapView = mapView
        let objects = mapView.mapWindow.map.mapObjects
        markersCollection = objects.addClusterizedPlacemarkCollection(with: self)
        plainCollection = objects.add()
        routeCollection = objects.add()
        mapView.mapWindow.map.addInputListener(with: self)
    }

    func apply(content: MapContent, camera: MapCamera?, isNightMode: Bool, locationRequest: Int) {
        guard let map = mapView?.mapWindow.map else {
            return
        }
        map.isNightModeEnabled = isNightMode
        if content != appliedContent {
            applyContent(content, previous: appliedContent, map: map)
            appliedContent = content
        }
        if let camera, camera != appliedCamera {
            move(to: camera, map: map)
            appliedCamera = camera
        }
        if locationRequest != appliedLocationRequest {
            appliedLocationRequest = locationRequest
            showUserLocation()
        }
    }

    func showUserLocationLayerIfAllowed(_ isAllowed: Bool) {
        guard isAllowed, let mapView else {
            return
        }
        ensureUserLocationLayer(mapView: mapView)
    }

    private func applyContent(_ content: MapContent, previous: MapContent?, map: YMKMap) {
        map.mapType = content.isSatellite ? .hybrid : .map
        map.isScrollGesturesEnabled = content.isInteractive
        map.isZoomGesturesEnabled = content.isInteractive
        map.isRotateGesturesEnabled = content.isInteractive
        map.isTiltGesturesEnabled = content.isInteractive
        if content.markers != previous?.markers || content.clustersMarkers != previous?.clustersMarkers {
            applyMarkers(content)
        }
        if content.routeStops != previous?.routeStops {
            applyRoute(content.routeStops, map: map)
        }
    }

    private func applyMarkers(_ content: MapContent) {
        markersCollection?.clear()
        plainCollection?.clear()
        for marker in content.markers {
            let point = YMKPoint(latitude: marker.latitude, longitude: marker.longitude)
            let placemark = content.clustersMarkers ? markersCollection?.addPlacemark() : plainCollection?.addPlacemark()
            placemark?.geometry = point
            placemark?.setIconWith(MapImages.marker)
            placemark?.userData = marker.id
            placemark?.addTapListener(with: self)
        }
        if content.clustersMarkers {
            markersCollection?.clusterPlacemarks(withClusterRadius: Self.clusterRadius, minZoom: Self.clusterMinZoom)
        }
    }

    private func applyRoute(_ stops: [MapRouteStop], map: YMKMap) {
        routeCollection?.clear()
        let points = stops.map { return YMKPoint(latitude: $0.latitude, longitude: $0.longitude) }
        if points.count > 1 {
            let polyline = routeCollection?.addPolyline(with: YMKPolyline(points: points))
            polyline?.setStrokeColorWith(MapImages.accentColor)
            polyline?.strokeWidth = Self.routeStrokeWidth
        }
        for stop in stops {
            let placemark = routeCollection?.addPlacemark()
            placemark?.geometry = YMKPoint(latitude: stop.latitude, longitude: stop.longitude)
            placemark?.setIconWith(MapImages.number(stop.number))
            placemark?.userData = stop.index
            placemark?.addTapListener(with: self)
        }
        guard !hasFittedRoute, !points.isEmpty else {
            return
        }
        hasFittedRoute = true
        DispatchQueue.main.async { [weak self] in
            self?.fitRoute(points)
        }
    }

    private func fitRoute(_ points: [YMKPoint]) {
        guard let map = mapView?.mapWindow.map, let first = points.first else {
            return
        }
        if points.count == 1 {
            map.move(with: YMKCameraPosition(target: first, zoom: Self.stopZoom, azimuth: Self.noRotation, tilt: Self.noRotation))
            return
        }
        let fitted = map.cameraPosition(with: YMKGeometry(polyline: YMKPolyline(points: points)))
        map.move(with: YMKCameraPosition(target: fitted.target, zoom: fitted.zoom - Self.fitZoomMargin, azimuth: Self.noRotation, tilt: Self.noRotation))
    }

    private func move(to camera: MapCamera, map: YMKMap) {
        let position = YMKCameraPosition(
            target: YMKPoint(latitude: camera.latitude, longitude: camera.longitude),
            zoom: camera.zoom,
            azimuth: Self.noRotation,
            tilt: Self.noRotation
        )
        if camera.isAnimated {
            map.move(with: position, animation: YMKAnimation(type: .smooth, duration: Self.cameraAnimationSeconds), cameraCallback: nil)
        } else {
            map.move(with: position)
        }
    }

    private func ensureUserLocationLayer(mapView: YMKMapView) {
        guard userLocationLayer == nil else {
            return
        }
        let layer = YMKMapKit.sharedInstance().createUserLocationLayer(with: mapView.mapWindow)
        layer.setObjectListenerWith(self)
        layer.setVisibleWithOn(true)
        userLocationLayer = layer
    }

    private func showUserLocation() {
        guard let mapView else {
            return
        }
        ensureUserLocationLayer(mapView: mapView)
        let manager = locationManager ?? YMKMapKit.sharedInstance().createLocationManager()
        locationManager = manager
        manager.requestSingleUpdate(withLocationListener: self)
    }

    func onClusterAdded(with cluster: YMKCluster) {
        cluster.appearance.setIconWith(MapImages.number(Int(cluster.size)))
        cluster.addClusterTapListener(with: self)
    }

    func onClusterTap(with cluster: YMKCluster) -> Bool {
        guard let map = mapView?.mapWindow.map else {
            return false
        }
        let zoom = map.cameraPosition.zoom + Self.clusterZoomStep
        map.move(with: YMKCameraPosition(target: cluster.appearance.geometry, zoom: zoom, azimuth: Self.noRotation, tilt: Self.noRotation))
        return true
    }

    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        if let id = mapObject.userData as? String {
            onMarkerTap?(id)
            return true
        }
        if let index = mapObject.userData as? Int {
            onStopTap?(index)
            return true
        }
        return false
    }

    func onMapTap(with map: YMKMap, point: YMKPoint) {
        onMapTap?(point.latitude, point.longitude)
    }

    func onMapLongTap(with map: YMKMap, point: YMKPoint) {}

    func onLocationUpdated(with location: YMKLocation) {
        mapView?.mapWindow.map.move(with: YMKCameraPosition(target: location.position, zoom: Self.myLocationZoom, azimuth: Self.noRotation, tilt: Self.noRotation))
    }

    func onLocationStatusUpdated(with status: YMKLocationStatus) {}

    func onObjectAdded(with view: YMKUserLocationView) {
        let icon = MapImages.userLocation
        view.pin.setIconWith(icon)
        view.arrow.setIconWith(icon)
        view.accuracyCircle.fillColor = MapImages.accentColor.withAlphaComponent(Self.accuracyFillAlpha)
        view.accuracyCircle.strokeColor = MapImages.accentColor.withAlphaComponent(Self.accuracyStrokeAlpha)
        view.accuracyCircle.strokeWidth = Self.accuracyStrokeWidth
    }

    func onObjectRemoved(with view: YMKUserLocationView) {}

    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {}
}
