//
//  ViewController.swift
//  MobileUsage
//
//  Created by Ananta Sjartuni on 5/9/19.
//  Copyright © 2019 Ananta Sjartuni. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var numberOfRow = 0
    fileprivate let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModelHandling()
    }
    
    private func viewModelHandling() {
        viewModel.fetchData { (numberOfRow:Int?, err:FechError?) in
            if err != nil {
                return;
            }
            self.numberOfRow = numberOfRow!
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController:UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMobileDataID", for: indexPath)  as! CellMobileData
        
        let mobileData = self.viewModel.getItemAt(indexPath.row)
        cell.lblYear.text = mobileData?.year
        cell.lblData.text = "\(mobileData?.total_volume ?? 0)"
        return cell
    }
    
    
}
