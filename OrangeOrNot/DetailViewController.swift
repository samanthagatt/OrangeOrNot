//
//  DetailViewController.swift
//  OrangeOrNot
//
//  Created by Samantha Gatt on 8/6/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var orangeOrNotView: UIView!
    @IBOutlet weak var orangeOrNotLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - IBActions
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true)
    }
}
