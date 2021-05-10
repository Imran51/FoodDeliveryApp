//
//  ViewController.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 9/5/21.
//

import UIKit
import SnapKit
import FloatingPanel

class HomeViewController: UIViewController, HomeView {
    var presenter: Presenter?
    var imageResourceNames = [String]()
    private var timer: Timer?
    private var fpc = FloatingPanelController()
    
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .red
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.isPagingEnabled = true
        scroll.isHidden = true
        
        
        return scroll
    }()
    
    let pageControl: UIPageControl = UIPageControl()
    
    func update(with discountImageName: DiscountImageResourceResponse?) {
        timer?.invalidate()
        DispatchQueue.main.async {[weak self] in
            guard let imageNames = discountImageName?.img else { return }
            self?.imageResourceNames = imageNames
            self?.configureUIScorllViewWithImageView()
            self?.configurePageControl()
            //self?.scheduledTimerWithTimeInterval()
        }
        
    }
    
    func update(with error: String) {
        print(error)
    }
    
    
    private let sushiViewController = SushiViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.delegate = self
        configureFloatingPanelView()
    }
    
    private func configureFloatingPanelView() {
        fpc.set(contentViewController: sushiViewController)
        fpc = FloatingPanelController(delegate: self)
        fpc.addPanel(toParent: self)
        fpc.contentMode = .fitToBounds
        
        // Create a new appearance.
        let appearance = SurfaceAppearance()
        
        // Define shadows
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = UIColor.black
        shadow.offset = CGSize(width: 0, height: 16)
        shadow.radius = 16
        shadow.spread = 8
        appearance.shadows = [shadow]
        
        // Define corner radius and background color
        appearance.cornerRadius = 20
        appearance.backgroundColor = .systemBackground
        
        // Set the new appearance
        fpc.surfaceView.appearance = appearance
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        timer?.invalidate()
    }
    
    private func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = imageResourceNames.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = .white
        self.pageControl.currentPageIndicatorTintColor = .black
        self.view.addSubview(pageControl)
        pageControl.frame = CGRect(x: view.frame.width/2-100, y: view.frame.height/2, width: 200, height: 200)
    }
    
    @objc private func animateScrollView() {
        let scrollWidth = scrollView.bounds.width
        let currentXOffset = scrollView.contentOffset.x
        
        let lastXPos = currentXOffset + scrollWidth
        if lastXPos != scrollView.contentSize.width {
            scrollView.setContentOffset(CGPoint(x: lastXPos, y: 0), animated: true)
        }
        else {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        changePageNumber()
    }
    
    private func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.animateScrollView), userInfo: nil, repeats: true)
    }
    
    private func configureUIScorllViewWithImageView() {
        scrollView.isHidden = false
        for index in 0..<imageResourceNames.count {
            let imageView = UIImageView()
            imageView.image = UIImage(named: imageResourceNames[index])
            imageView.contentMode = .scaleToFill
            let leftPosition = view.frame.width * CGFloat(index)
            imageView.frame = CGRect(x: leftPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            
            scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * CGFloat((imageResourceNames.count)),height: self.scrollView.frame.size.height)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height/2+150)
        
    }
}


extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        changePageNumber()
    }
    
    func changePageNumber() {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = Int(pageNumber)
    }
}


extension HomeViewController: FloatingPanelControllerDelegate {
    
    func floatingPanelWillBeginDragging(_ fpc: FloatingPanelController) {
        if fpc.state == .tip {
            pageControl.isHidden = false
        } else {
            pageControl.isHidden = true
        }
    }
    func floatingPanelDidChangePosition(_ fpc: FloatingPanelController) {
        if fpc.state == .tip {
            pageControl.isHidden = false
        } else {
            pageControl.isHidden = true
        }
    }
    
    func floatingPanelWillBeginAttracting(_ fpc: FloatingPanelController, to state: FloatingPanelState) {
        print(state.rawValue)
    }
}
