//
//  PrologueViewController.swift
//  ios_study_animated_mkannotation
//
//  Created by Yasuhiro Usutani on 2020/02/19.
//  Copyright © 2020 toolstudio. All rights reserved.
//

import UIKit

protocol PrologueViewControllerDelegate : NSObjectProtocol {
    func prologueViewControllerDone()
}

class PrologueViewController: UIViewController {
    
    weak var delegate: PrologueViewControllerDelegate?
    
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.prologueViewControllerDone()
    }
    
}
