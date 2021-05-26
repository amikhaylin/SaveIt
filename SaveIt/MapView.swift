//
//  MapView.swift
//  BucketList
//
//  Created by Andrey Mikhaylin on 29.04.2021.
//

import SwiftUI
import MapKit

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Placemark"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let placemark = view.annotation as? MKPointAnnotation else { return }
        
        //parent.selectedPlace = placemark
        parent.showingPlaceDetails = true
    }
}

struct MapView: UIViewRepresentable {
    var latitude: Double?
    var longitude: Double?
    var title: String?
    var showingPlaceDetails: Bool
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //TODO: Here we make annotation
        if let latitude = self.latitude, let longitude = self.longitude, let title = self.title {
        let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.title = title
            uiView.addAnnotation(annotation)
            uiView.centerCoordinate = annotation.coordinate
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(centerCoordinate: .constant(MKPointAnnotation.example.coordinate), annotations: [MKPointAnnotation.example], selectedPlace: .constant(MKPointAnnotation.example), showingPlaceDetails: .constant(false))
//    }
//}

