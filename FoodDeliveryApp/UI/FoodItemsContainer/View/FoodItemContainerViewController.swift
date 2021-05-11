//
//  SushiViewController.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 9/5/21.
//

import UIKit
import TTGSnackbar

class FoodItemContainerViewController: UIViewController {
    var presenter: FoodItemViewToPresenter?
    private var fabButtonBadgeCounter = 0
    private var foodItems = [FoodItem]()
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(FoodItemContainerTableViewCell.self, forCellReuseIdentifier: FoodItemContainerTableViewCell.identifier)
        
        return table
    }()
    
    private let fabButton: BadgeButton = {
        let button = BadgeButton()
        button.clipsToBounds = true
        button.setImage(UIImage(named: "add-to-cart"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 5, bottom: 15, right: 15)
        button.roundedView(cornerRadius: 35, bgColor: .white, isShadow: true)
        
        return button
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 50, right: 0)
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
        DispatchQueue.main.async {[weak self] in
            self?.foodItems = filteredFoodItems
            self?.tableView.reloadData()
        }
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


// MARK:- View configuration related method implementation

extension FoodItemContainerViewController {
    private func configureTablviewInitialization(){
        view.addSubview(tableView)
        tableView.backgroundColor = nil
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        
        tableView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(100)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
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
            make.top.equalToSuperview().offset(50)
            make.height.equalTo(50)
        }
    }
    
    private func configureBottomFloatingFabButton() {
        view.addSubview(fabButton)
        fabButton.snp.makeConstraints{ make in
            make.bottom.equalToSuperview().inset(100)
            make.right.equalToSuperview().inset(30)
            make.height.equalTo(70)
            make.width.equalTo(70)
        }
    }
}

// MARK:- Update View methods implementation

extension FoodItemContainerViewController {
    func updateView(with data: [FoodItem]) {
        foodItems = data
        presenter?.fetchFoodItemsData(for: .Pizza, withOriginalFoodItems: data)
    }
}

// MARK:- Tableview delegate implementation

extension FoodItemContainerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FoodItemContainerTableViewCell.identifier, for: indexPath) as? FoodItemContainerTableViewCell else { return UITableViewCell() }
        let item = foodItems[indexPath.row]
        cell.configure(with: item.info, withImageUrl: item.imgUrl)
        cell.contentView.backgroundColor = .white
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK:- Tableview cell button click action implementation

extension FoodItemContainerViewController: FoodItemContainerTableViewCellDelegate {
    func priceButtonClicked(with price: String) {
        if !price.isEmpty{
            fabButtonBadgeCounter += 1
            fabButton.badgeValue = "\(fabButtonBadgeCounter)"
        }
    }
}
