//
//  SideMenuViewController.swift
//  SideMenu
//

import UIKit

protocol SideMenuVCDelegate:AnyObject {
    func didTapAtMenuItems(index:Int)
}
class SideMenuViewController: UIViewController {

    weak var delegate:SideMenuVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func menuItemsTapped(_ sender:UIButton){
        delegate?.didTapAtMenuItems(index: sender.tag)
    }
}
