//
//  AboutAppViewController.swift
//  NavigationFlowCoordinatorExample
//
//  Created by Rafał Urbaniak on 07/08/2017.
//  Copyright © 2017 Rndity. All rights reserved.
//

import Foundation
import UIKit


protocol AboutAppFlowDelegate: class {
    func DismissVC()
}

class AboutAppViewController: UIViewController {

    weak var flowDelegate: AboutAppFlowDelegate?


    public convenience init() {
        self.init(nibName: "AboutAppViewController", bundle: Bundle.main)
    }

    override func viewDidLoad() {
        edgesForExtendedLayout = []

        navigationItem.title = "About app"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(goBack))
    }

    deinit {
        print("deinit: \(#file.components(separatedBy: "/").last ?? "")")
    }

    @objc func goBack() {
        flowDelegate?.DismissVC()
    }

}
