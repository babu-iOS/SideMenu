//
//  ProfileViewController.swift
//  SideMenu
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backTapped(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }

}
