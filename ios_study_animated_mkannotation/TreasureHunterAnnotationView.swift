//
//  TreasureHunterAnnotationView.swift
//  ios_study_animated_mkannotation
//
//  Created by Yasuhiro Usutani on 2020/02/16.
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
        isOpaque = false
        setFrameSize()
        setWalker()
        startAnimation()
    }
    
    func setFrameSize() {
        // フレームサイズを適切な値に設定する
        frame.size.width = 48
        frame.size.height = 48
    }
    
    func setWalker() {
        walker = CALayer()
        // contentsScale = [UIScreen mainScreen].scale は特に必要ない
        // contentsGravity = kCAGravityResizeなので
        walker.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        walker.contents = UIImage(named: "Patorash")?.cgImage
        walker.contentsRect = CGRect(x: 0, y: 0, width: 0.25, height: 0.25)
        
        layer.cornerRadius = frame.size.width / 2
        layer.addSublayer(walker)
    }
    
    func startAnimation() {
        // アニメーションの設定
        let walkAnimation = CAKeyframeAnimation(keyPath: "contentsRect")
        walkAnimation.values = aroundAnimationRectValues()
        walkAnimation.calculationMode = .discrete
        walkAnimation.duration = 1
        walkAnimation.repeatCount = Float.infinity
        walkAnimation.isRemovedOnCompletion = false
        walker.add(walkAnimation, forKey: "walk")
    }
    
    func aroundAnimationRectValues() -> [NSValue] {
        let quarter = 0.25
        return [
            NSValue(cgRect: CGRect(x: 0, y: 0.00, width: quarter, height: quarter)),
            NSValue(cgRect: CGRect(x: 0, y: 0.25, width: quarter, height: quarter)),
            NSValue(cgRect: CGRect(x: 0, y: 0.50, width: quarter, height: quarter)),
            NSValue(cgRect: CGRect(x: 0, y: 0.75, width: quarter, height: quarter)),
        ]
    }
}
