//
//  MapView.swift
//  CATPrototypeDemo
//
//  Created by Arthur Kazemi on 8/8/20.
//  Copyright © 2020 Ericsson. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @ObservedObject var vm: MainViewModel

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        
        let center = env.center
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004))

        //set region on the map
        mapView.setRegion(region, animated: true)
        mapView.mapType = .satellite
        mapView.isRotateEnabled = false
        
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        if self.vm.locations.count != view.annotations.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(self.vm.locations)
        }

        if self.vm.routeCoordinates.count > 0 {
            view.overlays
                .filter{ $0.isKind(of: MKPolyline.self)}
                .forEach { view.removeOverlay($0)}
            let polyline = MKPolyline(coordinates: self.vm.routeCoordinates, count: self.vm.routeCoordinates.count)
            view.addOverlay(polyline)
        } else {
            view.overlays
                .filter{ $0.isKind(of: MKPolyline.self)}
                .forEach { view.removeOverlay($0)}
        }

        if self.vm.lastPosition != nil {
            view.overlays
                .filter{ $0.isKind(of: MKCircle.self)}
                .forEach { view.removeOverlay($0)}
            let c = MKCircle(center: self.vm.lastPosition!, radius: 10.0)
            view.addOverlay(c)
        } else {
            view.overlays
                .filter{ $0.isKind(of: MKCircle.self)}
                .forEach { view.removeOverlay($0)}
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.vm.centerCoordinate = mapView.centerCoordinate
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay.isKind(of: MKPolyline.self) {
                let r = MKPolylineRenderer(overlay: overlay)
                r.strokeColor = .orange
                r.lineWidth = 5

                return r
            }

            let cr = MKCircleRenderer(overlay: overlay)
            cr.fillColor = UIColor(red: (64/255.0), green: (54/255.0), blue: (105/255.0), alpha: 0.5)
            cr.strokeColor = .black
            cr.lineWidth = 1

            return cr
        }
    }
}

extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to the 2012 Summer Olympics."
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        return annotation
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(vm: MainViewModel())
    }
}
