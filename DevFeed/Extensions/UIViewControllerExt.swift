//
//  UIViewControllerExt.swift
//  DevFeed
//
//  Created by Jerry Lai on 2021-02-03.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentDetail(_ viewController: UIViewController){
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromRight
        
        self.view.window?.layer.add(transition, forKey: kCATransition)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: false, completion: nil)
    }
    
    func dismissDetail(){
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromLeft
        
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
}
