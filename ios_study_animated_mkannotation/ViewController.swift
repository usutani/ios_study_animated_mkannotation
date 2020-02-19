//
//  ViewController.swift
//  ios_study_animated_mkannotation
//
//  Created by Yasuhiro Usutani on 2020/02/13.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, PrologueViewControllerDelegate {
    
    class TreasureHunterAnnotation : MKPointAnnotation {}
    
    //MARK: Constants
    let LOC_COORD_KOBE_CITY_HALL = CLLocationCoordinate2D(latitude: 34.689486, longitude: 135.195739)
    let COORD_SPAN = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    //MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    var treasureHunterAnnotation: TreasureHunterAnnotation!
    var prologueWasPresented = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // アノテーションの座標を神戸市役所に設定する
        treasureHunterAnnotation = TreasureHunterAnnotation()
        treasureHunterAnnotation.coordinate = LOC_COORD_KOBE_CITY_HALL
        mapView.addAnnotation(treasureHunterAnnotation)
        
        // 神戸市役所を中心に地図を表示する
        mapView.region = MKCoordinateRegion(center: LOC_COORD_KOBE_CITY_HALL, span: COORD_SPAN)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentPrologueIfNeeded()
    }
    
    private func presentPrologueIfNeeded() {
        if prologueWasPresented {
            return
        }
        presentPrologue()
    }
    
    //MARK: PrologueViewControllerDelegate
    
    func prologueViewControllerDone() {
        zoomInIfPrologue()
    }
    
    private func zoomInIfPrologue() {
        if prologueWasPresented {
            return
        }
        prologueWasPresented = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let rgn = MKCoordinateRegion(center: self.mapView.centerCoordinate, latitudinalMeters: 200, longitudinalMeters: 200)
            self.mapView.setRegion(rgn, animated: true)
        }
    }
    
    //MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // 地図の中心にアノテーションを移動する
        let destinationLocation = mapView.centerCoordinate
        UIView.animate(withDuration: 0.2, animations: {
            self.treasureHunterAnnotation.coordinate = destinationLocation
        }, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "TreasureHunter"
        var av = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if av == nil {
            av = TreasureHunterAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        av?.annotation = annotation
        
        if let av = av as? TreasureHunterAnnotationView {
            av.standbyNero = false
            av.showRadar = true
        }
        return av
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view is TreasureHunterAnnotationView {
            presentPrologue()
        }
        // 選択を解除
        for annotaion in mapView.selectedAnnotations {
            mapView.deselectAnnotation(annotaion, animated: false)
        }
    }
    
    //MARK: Actions
    
    @IBAction func showPatorash(_ sender: UIButton) {
        treasureHunterAnnotationView()?.standbyNero = false
    }
    
    @IBAction func showPatorashNero(_ sender: UIButton) {
        treasureHunterAnnotationView()?.standbyNero = true
    }
    
    @IBAction func turnOnRadar(_ sender: UIButton) {
        treasureHunterAnnotationView()?.showRadar = true
    }
    
    @IBAction func turnOffRadar(_ sender: UIButton) {
        treasureHunterAnnotationView()?.showRadar = false
    }
    
    //MARK: Private methods
    
    private func treasureHunterAnnotationView() -> TreasureHunterAnnotationView? {
        return mapView.view(for: treasureHunterAnnotation) as? TreasureHunterAnnotationView
    }
    
    private func presentPrologue() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Prologue") as? PrologueViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        }
    }
}
