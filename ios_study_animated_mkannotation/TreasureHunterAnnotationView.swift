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
