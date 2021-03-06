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
    
    struct PageControlConstraintConstant {
        static let initialCenterXInset = 100
        static let initialCenterYOffset = -10
        static let height = 200
        static let width = 200
        static let updatedCenterYOffset = HomeViewController().view.frame.height/4+90
    }
    
    private struct ScrollViewConstaraintConstant {
        static let initialBottomInset = 250
        static let updatedBottomInset = 100
    }
    
    private var timer: Timer?
    private var fpc = FloatingPanelController()
    
    private let pageControl: UIPageControl = UIPageControl()
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.isPagingEnabled = true
        scroll.isHidden = true
        
        return scroll
    }()
    
    private let foodItemViewController = FoodItemContainerViewController()
    
    deinit {
        timer?.invalidate()
        fpc.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPink
        configureScrollView()
        fetchAllData()
    }
   
    private func fetchAllData() {
        presenter?.fetchData()
    }
    
    @objc private func animateScrollView() {
        let scrollWidth = scrollView.bounds.width
        let currentXOffset = scrollView.contentOffset.x
        
        let lastXPos = currentXOffset + scrollWidth
        
        UIView.animate(
            withDuration: 1,
            delay: 0, options: UIView.AnimationOptions.curveLinear,
            animations: {
                [weak self] in
                self?.scrollView.contentOffset.x = lastXPos != self?.scrollView.contentSize.width ? lastXPos : 0
            }
        )
        
        changePageNumber()
    }
    
    private func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.animateScrollView), userInfo: nil, repeats: true)
    }
}

// MARK:-  Views Item Configuration implementation

extension HomeViewController {
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.delegate = self
        
        scrollView.snp.makeConstraints{
            make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(ScrollViewConstaraintConstant.initialBottomInset)
        }
    }
    
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
        self.pageControl.numberOfPages = imageResourceNames.count
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = .black
        self.pageControl.currentPageIndicatorTintColor = .white
        self.view.addSubview(pageControl)
        pageControl.snp.makeConstraints{
            make in
            make.centerX.equalToSuperview().inset(PageControlConstraintConstant.initialCenterXInset)
            make.centerY.equalToSuperview()
            make.height.equalTo(PageControlConstraintConstant.height)
            make.width.equalTo(PageControlConstraintConstant.width)
        }
    }
}

// MARK:- HomeViewController delegate protocol implementation

extension HomeViewController: PresenterToHomeView {
    func update(with discountImageName: DiscountImageResourceResponse?) {
        timer?.invalidate()
        DispatchQueue.main.async {[weak self] in
            guard let imageNames = discountImageName?.img else { return }
            self?.imageResourceNames = imageNames
            self?.configureUIScorllViewWithImageView(false)
            self?.configurePageControl()
            self?.scheduledTimerWithTimeInterval()
        }
    }
    
    func update(with foodItems: FoodItemsResponse?){
        guard let items = foodItems?.items else { return }
        foodItemViewController.updateView(with: items)
        presenter?.showFloatingPanelView(from: self, withFloatingPanel: fpc, withFoodItemsData: foodItems)
    }
    
    func update(with error: String) {
        DispatchQueue.main.async {
            addComponent.showSnackBar(withMessage: error, withType: .Error)
        }
    }
    
    func isLoading(isLoading: Bool) {
        DispatchQueue.main.async {
            addComponent.loadingActivityIndicator(isLoading: isLoading)
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
    func floatingPanelDidChangePosition(_ fpc: FloatingPanelController) {
        let pageControllCenterYOffset = fpc.state == .tip ? Int(PageControlConstraintConstant.updatedCenterYOffset) : PageControlConstraintConstant.initialCenterYOffset
        
        let scrollviewBottomInset = fpc.state == .tip ? ScrollViewConstaraintConstant.updatedBottomInset : ScrollViewConstaraintConstant.initialBottomInset
        UIView.animate(withDuration: 0.5 ,animations: {[weak self] in
            self?.pageControl.snp.updateConstraints{
                update in
                update.centerY.equalToSuperview().offset(pageControllCenterYOffset)
            }
            self?.scrollView.snp.updateConstraints{
                update in
                update.bottom.equalToSuperview().inset(scrollviewBottomInset)
            }
            
            self?.pageControl.layoutIfNeeded()
            self?.scrollView.setNeedsLayout()
            self?.scrollView.layoutIfNeeded()
        })
    }
}
