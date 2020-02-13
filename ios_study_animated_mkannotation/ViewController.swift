//
//  ViewController.swift
//  ios_study_animated_mkannotation
//
//  Created by Yasuhiro Usutani on 2020/02/13.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit
import MapKit

class TreasureHunterAnnotationView: MKAnnotationView {
    var walker: CALayer!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        // フレームサイズを適切な値に設定する
        var myFrame = frame
        myFrame.size.width = 48
        myFrame.size.height = 48
        frame = myFrame
        // 不透過プロパティをNOに設定することで、地図コンテンツが、
        // レンダリング対象外のビューの領域を透かして見えるようになる。
        isOpaque = false
        
        walker = CALayer()
        // contentsScale = [UIScreen mainScreen].scale は特に必要ない
        // contentsGravity = kCAGravityResizeなので
        walker.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        walker.contents = UIImage(named: "Patorash")?.cgImage
        walker.contentsRect = CGRect(x: 0, y: 0, width: 0.25, height: 0.25)
        
        layer.cornerRadius = myFrame.size.width / 2
        layer.addSublayer(walker)
        
        // アニメーションの設定
        let walkAnimation = CAKeyframeAnimation(keyPath: "contentsRect")
        walkAnimation.values = [
            NSValue(cgRect: CGRect(x: 0, y: 0, width: 0.25, height: 0.25)),
            NSValue(cgRect: CGRect(x: 0, y: 0.25, width: 0.25, height: 0.25)),
            NSValue(cgRect: CGRect(x: 0, y: 0.5, width: 0.25, height: 0.25)),
            NSValue(cgRect: CGRect(x: 0, y: 0.75, width: 0.25, height: 0.25)),
        ]
        walkAnimation.calculationMode = .discrete
        walkAnimation.duration = 1
        walkAnimation.repeatCount = Float.infinity
        walkAnimation.isRemovedOnCompletion = false
        walker.add(walkAnimation, forKey: "walk")
    }
}

class ViewController: UIViewController, MKMapViewDelegate {
    
    class TreasureHunterAnnotation : MKPointAnnotation {}
    
    //MARK: Constants
    let LOC_COORD_KOBE_CITY_HALL = CLLocationCoordinate2D(latitude: 34.689486, longitude: 135.195739)
    let COORD_SPAN = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    //MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    var patorash: TreasureHunterAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // アノテーションの座標を神戸市役所に設定する
        patorash = TreasureHunterAnnotation()
        patorash.coordinate = LOC_COORD_KOBE_CITY_HALL
        mapView.addAnnotation(patorash)
        
        // 神戸市役所を中心に地図を表示する
        mapView.region = MKCoordinateRegion(center: LOC_COORD_KOBE_CITY_HALL, span: COORD_SPAN)
    }
    
    //MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        patorash.coordinate = mapView.centerCoordinate
//
        // How to animate an coordinate change of an MKPointAnnotation correctly
        // https://stackoverflow.com/questions/44819389/how-to-animate-an-coordinate-change-of-an-mkpointannotation-correctly
        //
        let destinationLocation = mapView.centerCoordinate
        UIView.animate(withDuration: 0.2, animations: {
            self.patorash.coordinate = destinationLocation
        }, completion: { success in
            if success {
                // handle a successfully ended animation
            } else {
                // handle a canceled animation, i.e move to destination immediately
                self.patorash.coordinate = destinationLocation
            }
        })
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "Patorash"
        var av = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if av == nil {
            av = TreasureHunterAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        av?.annotation = annotation
        return av
    }
}
