//
//  SushiViewController.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 9/5/21.
//

import UIKit
import TTGSnackbar
import RxCocoa
import RxSwift

class FoodItemContainerViewController: UIViewController {
    var presenter: FoodItemViewToPresenter?
    
    private struct TablviewConstraintConstant{
        static let topOffset = 140
        static let leadingOffset = 20
        static let traillingInset = 20
    }
    
    private struct FilterOptionHolderStackviewConstraintConstant {
        static let topOffset = 100
        static let leadingOffset = 20
        static let height = 30
    }
    
    private struct FabButtonConstraintConstant {
        static let bottomInset = 150
        static let rightInset = 30
        static let height = 70
        static let width = 70
    }
    
    private struct StringConstant {
        static let filter = "FILTERS"
        static let buttonImageName = "add-to-cart"
        static let onProgressMessage = "Sorry!Implementation is on progress."
        static let finisherYetMessage = "Woops!This feature has not finished yet."
    }
    
    private var fabButtonBadgeCounter = 0
    private var rxFoodItems = BehaviorRelay(value: [FoodItem]())
    private let bag = DisposeBag()
    private let leftSwipe = UISwipeGestureRecognizer()
    private let rightSwipe = UISwipeGestureRecognizer()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(FoodItemContainerTableViewCell.self, forCellReuseIdentifier: FoodItemContainerTableViewCell.identifier)
        
        return table
    }()
    
    private let fabButton: BadgeButton = {
        let button = BadgeButton()
        button.clipsToBounds = true
        button.setImage(UIImage(named: StringConstant.buttonImageName), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 5, bottom: 15, right: 15)
        button.roundedView(cornerRadius: 35, bgColor: .white, isShadow: true)
        
        return button
    }()
    
    
    
    private let filterLabelHolderStackview: UIStackView = {
        let fontSize: CGFloat = 14
        let cornerRadius: CGFloat = 15
        let borderWidth: CGFloat = 1
        let spacing: CGFloat = 5
        
        let filterNameLabel = addComponent.label(id: "", type: BaseFonts.roboto_medium, text: StringConstant.filter, size: fontSize, addColor: BaseColor.textGray, align: .center)
        
        let labelOne = addComponent.label(id: "", type: BaseFonts.roboto_medium, text: FoodFilterLevel.Spicy.rawValue, size: fontSize, addColor: BaseColor.textGray, align: .center)
        labelOne.roundedView(cornerRadius: cornerRadius, bgColor: .clear, isShadow: true)
        labelOne.layer.borderWidth = borderWidth
        labelOne.layer.borderColor = BaseColor.textGray.color.cgColor
        
        let labelTwo = addComponent.label(id: "", type: BaseFonts.roboto_medium, text: FoodFilterLevel.VerySpicy.rawValue, size: fontSize, addColor: BaseColor.textGray, align: .center)
        labelTwo.roundedView(cornerRadius: cornerRadius, bgColor: .clear, isShadow: true)
        labelTwo.layer.borderWidth = borderWidth
        labelTwo.layer.borderColor = BaseColor.textGray.color.cgColor
        
        let spacerView = addComponent.horizontalSpacerView()
        let stack = addComponent.stackView(views: [filterNameLabel,labelOne,labelTwo,spacerView], axis: .horizontal, distribution: .fill, spacing: spacing)
        
        return stack
    }()
    
    private let segmentControll: UISegmentedControl = {
        let segment = UISegmentedControl(items: [FoodTypes.Pizza.rawValue, FoodTypes.Sushi.rawValue, FoodTypes.Drinks.rawValue])
        segment.selectedSegmentIndex = 0
        
        return segment
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureTablviewInitialization()
        
        configureSegmentControlItems()
        configureBottomFloatingFabButton()
        configureFilterOptionHolderStackview()
        /*
         At viewDidLoad, viewController.view.frame == .zero, if you call bind(to) datasource for tableView, will cause layoutIfNeeds to be called.
         At this time the auto layout constraint will not work correctly (due to frame = .zero).
         To avoid this, you can use DispatchQueue.main.async for delaying the bind(to:) call will suppress the warning.
         */
        DispatchQueue.main.async {[weak self] in
            self?.bindTableViewWithRxDataSource()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func bindTableViewWithRxDataSource() {
        rxFoodItems
            .bind(
                to: tableView
                    .rx
                    .items(
                        cellIdentifier: FoodItemContainerTableViewCell.identifier,
                        cellType: FoodItemContainerTableViewCell.self
                    )
            ) { (row,item,cell) in
                cell.configure(with: item.info, withImageUrl: item.imgUrl, withItemId: item.id)
                cell.contentView.backgroundColor = .white
                cell.delegate = self
                cell.selectionStyle = .none
            }.disposed(by: bag)
        
        tableView
            .rx
            .modelSelected(FoodItem.self)
            .subscribe(onNext: { _ in
                addComponent.showSnackBar(withMessage: StringConstant.onProgressMessage, withType: .Ongoing)
            }).disposed(by: bag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    @objc func segmentedValueChanged(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 1:
            presenter?.fetchFoodItemsData(for: .Sushi)
            break
        case 2:
            presenter?.fetchFoodItemsData(for: .Drinks)
            
        default:
            presenter?.fetchFoodItemsData(for: .Pizza)
        }
    }
}

// MARK:- Data showing delegate method implementation

extension FoodItemContainerViewController: PresenterToFoodItemView {
    func updateSegmenteViewAndTableView(with filteredFoodItems: [FoodItem]) {
        rxFoodItems.accept(filteredFoodItems)
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


// MARK:- View configuration related method implementation

extension FoodItemContainerViewController {
    
    private func configureTablviewInitialization(){
        view.addSubview(tableView)
        tableView.backgroundColor = nil
        tableView.separatorStyle = .none
        tableView.clipsToBounds = true
        tableView.tableFooterView = UIView()
        tableView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(TablviewConstraintConstant.topOffset)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        tableView.addGestureRecognizer(leftSwipe)
        tableView.addGestureRecognizer(rightSwipe)
        leftSwipe.addTarget(self, action: #selector(moveToNextItem(_:)))
        rightSwipe.addTarget(self, action: #selector(moveToNextItem(_:)))
    }
    
    private struct SegmentControlConstraintConstant {
        static let topOffset = 50
        static let height = 50
    }
    
    private func configureSegmentControlItems() {
        view.addSubview(segmentControll)
        
        segmentControll.backgroundColor = .white
        let font = UIFont.init(name: BaseFonts.roboto_bold.customFont, size: 24)
        
        segmentControll.setTitleTextAttributes([.font: font as Any,.foregroundColor: UIColor.lightGray], for: .normal)
        segmentControll.setTitleTextAttributes([.font: font as Any,.foregroundColor: UIColor.black], for: .selected)
        
        segmentControll.removeBorders()
        segmentControll.isHighlighted = false
        
        segmentControll.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        segmentControll.snp.makeConstraints{
            make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(SegmentControlConstraintConstant.topOffset)
            make.height.equalTo(SegmentControlConstraintConstant.height)
        }
    }
    
    private func configureBottomFloatingFabButton() {
        view.addSubview(fabButton)
        fabButton.snp.makeConstraints{ make in
            make.bottom.equalToSuperview().inset(FabButtonConstraintConstant.bottomInset)
            make.right.equalToSuperview().inset(FabButtonConstraintConstant.rightInset)
            make.height.equalTo(FabButtonConstraintConstant.height)
            make.width.equalTo(FabButtonConstraintConstant.width)
        }
        fabButton.addTarget(self, action: #selector(fabbuttonClicked(_:)), for: .touchUpInside)
    }
    
    private func configureFilterOptionHolderStackview() {
        view.addSubview(filterLabelHolderStackview)
        filterLabelHolderStackview.snp.makeConstraints{
            make in
            make.top.equalToSuperview().offset(FilterOptionHolderStackviewConstraintConstant.topOffset)
            make.leading.equalToSuperview().offset(FilterOptionHolderStackviewConstraintConstant.leadingOffset)
            make.trailing.equalToSuperview()
            make.height.equalTo(FilterOptionHolderStackviewConstraintConstant.height)
        }
    }
}


// MARK:- Update View methods implementation

extension FoodItemContainerViewController {
    func updateView(with data: [FoodItem]) {
        presenter?.fetchFoodItemsData(for: .Pizza, withOriginalFoodItems: data)
    }
}


// MARK:- Tableview cell button click action implementation

extension FoodItemContainerViewController: FoodItemContainerTableViewCellDelegate {
    func priceButtonClicked(withItemId itemId: Int, withPrice price: String) {
        if !price.isEmpty{
            fabButtonBadgeCounter += 1
            fabButton.badgeValue = "\(fabButtonBadgeCounter)"
        }
    }
}


// MARK:- FabButton click action implementation

extension FoodItemContainerViewController {
    @objc private func fabbuttonClicked(_ sender: UIButton) {
        fabButtonBadgeCounter = 0
        fabButton.badgeValue = ""
        addComponent.showSnackBar(withMessage: StringConstant.finisherYetMessage, withType: .Ongoing)
    }
}

// MARK:- Swipe action related implementation

extension FoodItemContainerViewController {
    @objc func moveToNextItem(_ sender:UISwipeGestureRecognizer) {
        
        switch sender.direction{
        case .left:
            if segmentControll.selectedSegmentIndex == 1 {
                changeSegmentControlIndexToViewSwipeAction(to: 0)
            } else if segmentControll.selectedSegmentIndex == 2 {
                changeSegmentControlIndexToViewSwipeAction(to: 1)
            }
        case .right:
            if segmentControll.selectedSegmentIndex == 0 {
                changeSegmentControlIndexToViewSwipeAction(to: 1)
            } else if segmentControll.selectedSegmentIndex == 1 {
                changeSegmentControlIndexToViewSwipeAction(to: 2)
            }
        default: //default
            break
        }
    }
    
    private func changeSegmentControlIndexToViewSwipeAction(to index: Int){
        segmentControll.selectedSegmentIndex = index
        segmentedValueChanged(segmentControll)
    }
}
