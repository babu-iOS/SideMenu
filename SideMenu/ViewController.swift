//
//  ViewController.swift
//  SideMenu

import UIKit

class ViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var mainContainer:UIView!
    @IBOutlet weak var sideMenuView:UIView!
    @IBOutlet weak var buttonBG:UIButton!
    
    
    let menuWidth:CGFloat = 260
    var screenWidth:CGFloat = 0.0
    var screenCenter:CGFloat = 0.0
    var screenHeight:CGFloat = 0.0
    var isOverTheView = true //make false to open along with main view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    func initialSetup(){
        DispatchQueue.main.async {
            self.buttonBG.alpha = 0
            self.screenWidth = UIScreen.main.bounds.size.width
            self.screenHeight = UIScreen.main.bounds.size.width
            self.screenCenter = self.screenWidth/2.0
            self.scrollView.contentOffset = CGPoint(x: self.menuWidth, y: 0)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SideMenuViewController{
            vc.delegate = self
        }
    }
    //MARK: button Actions
    @IBAction func openSideMenu(){ // Make this connection from First Responder
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.10, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }) { _ in
           
        }
    }
    
    @IBAction func transperentButtonAction(){
        closeMenu()
    }
    
    private func closeMenu(){
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.15, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.scrollView.contentOffset = CGPoint(x: self.menuWidth, y: 0)
        }) { _ in
            
        }
    }
}

//MARK: - ScrollViewDelegate
extension ViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollOffset = scrollView.contentOffset
        let offsetX = scrollOffset.x
        if isOverTheView{
            mainContainer.center = CGPoint(x: self.screenCenter-(menuWidth - offsetX), y: mainContainer.center.y)
        }
        
        let maxAlpha: CGFloat = 0.5
        let minAlpha: CGFloat = 0.0
        
        let alpha = maxAlpha - (maxAlpha - minAlpha) * (offsetX / menuWidth)
        buttonBG.alpha = alpha

    }
}
extension ViewController: SideMenuVCDelegate {
    func didTapAtMenuItems(index: Int) {
        closeMenu()
        switch index {
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            //Nav to specific vc
            break
        default:
            break
        }
    }
}
