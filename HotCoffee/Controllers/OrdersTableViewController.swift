//
//  OrderTableViewController.swift
//  HotCoffee
//
//  Created by Avisa Poshtkouhi on 3/5/21.
//

import Foundation
import UIKit

protocol AddOrderCoffeeDelegate {
    func didSaveAddOrderCoffee(_ order: Order, with viewController: UIViewController)
    func didCloseAddOrderCoffee(_ vc: UIViewController)
}

class OrdersTableViewController: UITableViewController, AddOrderCoffeeDelegate {
   
    var orderListViewModel = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateOrders()
    }
    
    private func populateOrders() {
                
        Webservice().load(resource: Order.all) { [weak self] result in
            
            switch result {
                case .success(let orders):
                   self?.orderListViewModel.ordersViewModel = orders.map(OrderViewModel.init)
                   self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
            }
            
        }
        
    }
    
    // MARK: Prepare For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nav = segue.destination as? UINavigationController,
           let addCoffeOrderVC = nav.viewControllers.first as? AddOrderViewController else {
            fatalError("Error performing segue!")
        }
        addCoffeOrderVC.delegate = self
    }
    
    func didSaveAddOrderCoffee(_ order: Order, with viewController: UIViewController) {
        
        viewController.dismiss(animated: true, completion: nil)
        
        let order = OrderViewModel(order: order)
        self.orderListViewModel.ordersViewModel.append(order)
        self.tableView.insertRows(at: [IndexPath(row: self.orderListViewModel.ordersViewModel.count - 1, section: 0)], with: .automatic)
    }
    
    func didCloseAddOrderCoffee(_ vc: UIViewController) {
        vc.dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListViewModel.ordersViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vm = self.orderListViewModel.orderViewModel(at: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        
        cell.textLabel?.text = vm.type
        cell.detailTextLabel?.text = vm.size
        
        return cell
        
    }
    
}
