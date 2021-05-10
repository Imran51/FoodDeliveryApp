//
//  ViewController.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 9/5/21.
//

import UIKit
import SnapKit
import FloatingPanel
import TTGSnackbar

class HomeViewController: UIViewController {
    
    var presenter: HomeViewToPresenter?
    var imageResourceNames = [String]()
    
    private var timer: Timer?
    private var fpc = FloatingPanelController()
    
    private let pageControl: UIPageControl = UIPageControl()
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.isPagingEnabled = true
        scroll.isHidden = true
        
        
        return scroll
    }()
    
    private let foodItemViewController = FoodItemContainerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPink
        view.addSubview(scrollView)
        scrollView.delegate = self
        
        fetchAllData()
    }
    
    private func fetchAllData() {
        presenter?.fetchData()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.snp.makeConstraints{
            make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(250)
        }
    }
}

// MARK:-  Views Item Configuration implementation

extension HomeViewController {
    
    private func configureUIScorllViewWithImageView(_ isHidden: Bool = true) {
        scrollView.isHidden = isHidden
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
    
    private func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = imageResourceNames.count
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = .darkGray
        self.pageControl.currentPageIndicatorTintColor = .black
        self.view.addSubview(pageControl)
        pageControl.frame = CGRect(x: view.frame.width/2-100, y: view.frame.height/2, width: 200, height: 200)
    }
}

// MARK:- HomeViewController delegate protocol implementation

extension HomeViewController: PresenterToHomeView {
    func update(with discountImageName: DiscountImageResourceResponse?) {
        DispatchQueue.main.async {[weak self] in
            guard let imageNames = discountImageName?.img else { return }
            self?.imageResourceNames = imageNames
            self?.configureUIScorllViewWithImageView(false)
            self?.configurePageControl()
            
            //self?.scheduledTimerWithTimeInterval()
        }
    }
    
    func update(with foodItems: FoodItemsResponse?){
        guard let items = foodItems?.items else { return }
        foodItemViewController.updateView(with: items)
        presenter?.showFloatingPanelView(from: self, withFloatingPanel: fpc, withFoodItemsData: foodItems)
    }
    
    func update(with error: String) {
        DispatchQueue.main.async {
            addComponent.showErrorSnackBar(with: error)
        }
    }
    
    func isLoading(isLoading: Bool) {
        DispatchQueue.main.async {
            isLoading ? CustomLoadingIndicatorView.sharedInstance.showBlurView(withTitle: "Please Wait...") : CustomLoadingIndicatorView.sharedInstance.hide()
        }
    }
}


// MARK:- UIScrollView delegate and UIPageControll related implementation

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        changePageNumber()
    }
    
    func changePageNumber() {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = Int(pageNumber)
    }
}

// MARK:- Floating Bottom Panel Delegate implementation

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
}
