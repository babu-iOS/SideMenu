//
//  ViewController.swift
//  SideMenu

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var buttonBG: UIButton!
    
    // MARK: - Properties
    private let menuWidth: CGFloat = 260
    private var screenWidth: CGFloat = 0.0
    private var screenCenter: CGFloat = 0.0
    private let isOverTheView = false // Set to true to have the main view move with the menu
    private let isDragEnabled = true // Boolean to enable or disable dragging
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialValues()
        configurePanGesture()
    }
    
    // MARK: - Initial Setup
    private func setupInitialValues() {
        DispatchQueue.main.async {
            self.buttonBG.alpha = 0
            self.screenWidth = UIScreen.main.bounds.size.width
            self.screenCenter = self.screenWidth / 2.0
            self.scrollView.contentOffset = CGPoint(x: self.menuWidth, y: 0)
        }
    }
    
    // MARK: - Animate Menu
    private func toggleMenu(toOffset offset: CGFloat) {
        UIView.animate(withDuration: 1,delay: 0.0,
                       usingSpringWithDamping: offset == 0 ? 0.85 : 1.0,
                       initialSpringVelocity: offset == 0 ? 0.10 : 0.15,
                       options: .curveEaseInOut,
                       animations: {
            self.scrollView.contentOffset = CGPoint(x: offset, y: 0)
        }) { _ in }
    }
    
    // MARK: - Button Actions
    @IBAction func openSideMenu() { // connect as a first responder in child Vc
        toggleMenu(toOffset: 0)
    }
    @IBAction func transparentButtonAction() {
        toggleMenu(toOffset: menuWidth)
    }
}

// MARK: - UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        
        if isOverTheView {
            mainContainer.center.x = screenCenter - (menuWidth - offsetX)
        }
        let alpha = max(0.0, 0.5 - (0.5 * (offsetX / menuWidth)))
        buttonBG.alpha = alpha
    }
}

// MARK: - Pan Gesture Handling
extension ViewController {
    private func configurePanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard isDragEnabled else { return }
        
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view).x
        let currentOffsetX = scrollView.contentOffset.x
        
        switch gesture.state {
        case .changed:
            let newOffsetX = max(min(currentOffsetX - translation.x, menuWidth), 0)
            scrollView.contentOffset = CGPoint(x: newOffsetX, y: 0)
            gesture.setTranslation(.zero, in: view)
            
        case .ended:
            let finalOffsetX = scrollView.contentOffset.x
            let shouldClose = finalOffsetX > menuWidth / 2 || velocity < -100
            let targetOffset: CGFloat = shouldClose ? menuWidth : 0
            
            toggleMenu(toOffset: targetOffset)
            
        default:
            break
        }
    }
}

// MARK: - SideMenuVCDelegate
extension ViewController: SideMenuVCDelegate {
    func didTapAtMenuItems(index: Int) {
        toggleMenu(toOffset: menuWidth)
        switch index {
        case 0:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
                navigationController?.pushViewController(vc, animated: true)
            }
        case 1:
            // Handle navigation for index 1
            break
        default:
            break
        }
    }
}
