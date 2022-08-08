//
//  MapView.swift
//  LocationApp
//
//  Created by MacBook on 2022-08-08.
//

import SwiftUI
import MapKit
struct MapView: UIViewRepresentable {
    var postDetail :PostDetails
    var userLists : UserDetails
    @State private  var locations = [
        ["subtitle": "0","title": "Chicago, IL",    "latitude": 40.713054, "longitude": -74.007228],
        ["subtitle": "1","title": "Los Angeles, CA", "latitude": 34.052238, "longitude": -118.243344],
        ["subtitle": "2","title": "Chicago, IL",     "latitude": 41.883229, "longitude": -87.632398],
        ["subtitle": "3","title": "Chicago, IL",     "latitude": 34.773613918510264, "longitude": -87.632345],
        ["subtitle": "4","title": "Chicago, IL",     "latitude": 62.157864977009496, "longitude": -109.51964805133827]
    ]
    
    func makeCoordinator() -> MapView.Coordinator {
        return MapView.Coordinator(parent: self, locations: locations, userLists: userLists, postDetail: postDetail)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = location["title"] as? String
            annotation.subtitle = location["subtitle"] as? String
            annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! Double, longitude: location["longitude"] as! Double)
            mapView.region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 10000000, longitudinalMeters: 10000000)
            mapView.delegate = context.coordinator
            
            mapView.addAnnotation(annotation)
        }
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        print("updateUIView")
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var locations : [[String : Any]]
        var userLists : UserDetails
        var postDetail :PostDetails
        
        init(parent: MapView,locations: [[String : Any]],userLists: UserDetails,postDetail: PostDetails) {
            self.parent = parent
            self.locations = locations
            self.userLists = userLists
            self.postDetail = postDetail
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            for location in locations {
                
                let centre = (view.annotation?.coordinate) as CLLocationCoordinate2D?
                let getLat: CLLocationDegrees = centre!.latitude
                let getLon: CLLocationDegrees = centre!.longitude
                let coordinate1 = CLLocation(latitude: location["latitude"] as! Double, longitude: location["longitude"] as! Double)
                let coordinate2 = CLLocation(latitude: getLat, longitude: getLon)
                let distanceInMeters = coordinate1.distance(from: coordinate2)
                // add 100000 meters for easy to testing perpose 
                if distanceInMeters < 100000  && distanceInMeters > 0 {
                    NotificationCenter.default.post(name: NSNotification.QrClick,object: nil, userInfo: ["info": ""])
                }
            }
            
            let overlays = mapView.overlays
            mapView.removeOverlays(overlays)
            
            let circle = MKCircle(center: view.annotation!.coordinate, radius:  10000 as CLLocationDistance)
            mapView.addOverlay(circle)
            
        }
        
        
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKCircle {
                let circle = MKCircleRenderer(overlay: overlay)
                circle.strokeColor = UIColor.red
                circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.3)
                circle.lineWidth = 1
                return circle
            } else {
                return MKPolylineRenderer()
            }
        }
        
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pin.isDraggable = true
            pin.pinTintColor = .blue
            pin.animatesDrop = true
            pin.canShowCallout = true
            
            for i in 0..<locations.count {
                if annotation.subtitle == "\(i)" {
                    configureDetailView(annotationView: pin, userLists: userLists,index:i, postDetail: postDetail)
                }
            }
            return pin
        }
        
        func configureDetailView(annotationView: MKAnnotationView,userLists : UserDetails ,index:Int,postDetail :PostDetails) {
            
            let calloutView = UIView()
            calloutView.translatesAutoresizingMaskIntoConstraints = false
            
            let views = ["calloutView": calloutView]
            
            calloutView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[calloutView(300)]", options: [], metrics: nil, views: views))
            calloutView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[calloutView(200)]", options: [], metrics: nil, views: views))
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width:50, height: 50))
            
            let url = URL(string: "https://3c5.com/eymWl")
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            imageView.image = UIImage(data: data!)
            imageView.layer.borderWidth = 1.0
            imageView.layer.masksToBounds = false
            imageView.layer.borderColor = UIColor.blue.cgColor
            imageView.layer.cornerRadius =  imageView.frame.size.height/2
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            
            let nameLabel = UILabel(frame: CGRect(x: 60, y: 5, width: UIScreen.main.bounds.width, height: 20))
            nameLabel.textColor = UIColor.black
            nameLabel.text = "Name : " + userLists[index].name
            nameLabel.font = .systemFont(ofSize: 11)
            
            let emailLabel = UILabel(frame: CGRect(x: 60, y: 25, width: UIScreen.main.bounds.width, height: 20))
            emailLabel.textColor = UIColor.black
            emailLabel.text = "Email : " + userLists[index].email
            emailLabel.font = .systemFont(ofSize: 11)
            
            let topLabel = UILabel(frame: CGRect(x: 115, y: 120, width: UIScreen.main.bounds.width, height: 20))
            topLabel.textColor = UIColor.white
            topLabel.text = "See more"
            topLabel.font = .systemFont(ofSize: 17)
            
            let thumbnailUrl = URL(string: "https://3c5.com/liKe9")
            let thumbnailData = try? Data(contentsOf:thumbnailUrl!)
            let postimageView = UIImageView(frame: CGRect(x: 60, y: 70, width: 180, height: 120))
            postimageView.image = UIImage(data: thumbnailData!)
            postimageView.clipsToBounds = true
            postimageView.contentMode = .scaleAspectFill
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            postimageView.isUserInteractionEnabled = true
            postimageView.addGestureRecognizer(tapGestureRecognizer)
            
            calloutView.addSubview(postimageView)
            calloutView.addSubview(emailLabel)
            calloutView.addSubview(nameLabel)
            calloutView.addSubview(imageView)
            calloutView.addSubview(topLabel)
            
            annotationView.detailCalloutAccessoryView = calloutView
        }
        @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
        {
            NotificationCenter.default.post(name: NSNotification.QrClick,object: nil, userInfo: ["info": "https://3c5.com/liKe9"])
        }
    }
}
