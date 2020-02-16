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
    var standbyNero = true {
        didSet {
            initWalker()
            startAnimation()
        }
    }
    var walker: CALayer!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        isOpaque = false
        initFrameSize()
    }
    
    func initFrameSize() {
        // フレームサイズを適切な値に設定する
        frame.size.width = 48
        frame.size.height = 48
    }
    
    func initWalker() {
        if walker != nil {
            walker.removeFromSuperlayer()
        }
        walker = CALayer()
        // contentsScale = [UIScreen mainScreen].scale は特に必要ない
        // contentsGravity = kCAGravityResizeなので
        walker.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        walker.contents = walkerImage()
        walker.contentsRect = aroundAnimationRects()[0]
        
        layer.cornerRadius = frame.size.width / 2
        layer.addSublayer(walker)
    }
    
    func walkerImage() -> CGImage? {
        let name = standbyNero ? "PatorashNero" : "Patorash"
        return UIImage(named: name)?.cgImage
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
        return aroundAnimationRects().map { NSValue(cgRect: $0) }
    }

    func aroundAnimationRects() -> [CGRect] {
        let quarter = 0.25
        if standbyNero {
            return [
                CGRect(x: 0, y: 0.00, width: 1, height: quarter),
                CGRect(x: 0, y: 0.25, width: 1, height: quarter),
                CGRect(x: 0, y: 0.50, width: 1, height: quarter),
                CGRect(x: 0, y: 0.75, width: 1, height: quarter),
            ]
        }
        else {
            return [
                CGRect(x: 0, y: 0.00, width: quarter, height: quarter),
                CGRect(x: 0, y: 0.25, width: quarter, height: quarter),
                CGRect(x: 0, y: 0.50, width: quarter, height: quarter),
                CGRect(x: 0, y: 0.75, width: quarter, height: quarter),
            ]
        }
    }
}
