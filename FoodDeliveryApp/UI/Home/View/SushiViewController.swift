//
//  SushiViewController.swift
//  FoodDeliveryApp
//
//  Created by Imran Sayeed on 9/5/21.
//

import UIKit

class SushiViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
