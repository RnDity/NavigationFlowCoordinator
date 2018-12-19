//
//  AboutAppViewController.swift
//  NavigationFlowCoordinatorExample
//
//  Created and developed by RnDity sp. z o.o. in 2018.
//  Copyright © 2018 RnDity sp. z o.o. All rights reserved.
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
