//
//  ViewController.swift
//  ios_study_animated_mkannotation
//
//  Created by Yasuhiro Usutani on 2020/02/13.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    //MARK: Constants
    let LOC_COORD_KOBE_CITY_HALL = CLLocationCoordinate2D(latitude: 34.689486, longitude: 135.195739)
    let COORD_SPAN = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    //MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 神戸市役所を中心に地図を表示する
        mapView.region = MKCoordinateRegion(center: LOC_COORD_KOBE_CITY_HALL, span: COORD_SPAN)
    }
}
