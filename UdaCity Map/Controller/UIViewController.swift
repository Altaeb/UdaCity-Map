//
//  UIViewController.swift
//  UdaCity Map
//
//  Created by Abdalfattah Altaeb on 4/13/20.
//  Copyright © 2020 Abdalfattah Altaeb. All rights reserved.
//

import UIKit

extension UIViewController {

    func displayAlertMainQueue(_ error: Error) {
        DispatchQueue.main.async {
            let alertInfo = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .actionSheet)
            alertInfo.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertInfo, animated: true, completion: nil)
        }
    }

    func displayAlert(_ error: Error) {
        let alertInfo = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .actionSheet)
        alertInfo.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertInfo, animated: true, completion: nil)
    }

}
