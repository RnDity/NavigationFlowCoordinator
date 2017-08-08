//
//  AboutAppViewController.swift
//  NavigationFlowCoordinatorExample
//
//  Created by Rafał Urbaniak on 07/08/2017.
//  Copyright © 2017 Rndity. All rights reserved.
//

import Foundation

import UIKit


class AboutAppViewController: UIViewController {
    
    public convenience init(){
        self.init(nibName: "AboutAppViewController", bundle: Bundle.main)
    }
    
    override func viewDidLoad() {
        edgesForExtendedLayout = []
        
        navigationItem.title = "About app"
    }
}
