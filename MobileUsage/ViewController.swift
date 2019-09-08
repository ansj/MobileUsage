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
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!

    fileprivate var numberOfRow = 0
    fileprivate let viewModel = ViewModel()
    var busyLoading=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeader.text = "Mobile Data Usage\nPetabites"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModelFetchData(true)
    }
    
    private func viewModelFetchData(_ isFirst:Bool) {
        busyLoading=true
        self.activity.startAnimating()
        viewModel.fetchData(isFirst) { (numberOfRow:Int?, err:FechError?) in
            if err != nil {
                DispatchQueue.main.async {
                    self.activity.stopAnimating()
                }
                return;
            }
            self.numberOfRow = numberOfRow!
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
                // make sure all screen is displayed full
                if self.tableView.contentSize.height < self.tableView.frame.size.height {
                    self.viewModelFetchData(false)
                }
                self.activity.stopAnimating()
            }
            self.busyLoading=false
        }
    }
    
    private func displayInfo(info:String) {
        let alert = UIAlertController.init(title: "Info", message: info, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}

extension ViewController:UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMobileDataID", for: indexPath)  as! CellMobileData
        cell.lblDown.isHidden = true
        let mobileData = self.viewModel.getItemAt(indexPath.row)
        cell.lblYear.text = mobileData.data?.year
        cell.lblData.text = "\(mobileData.data?.total_volume ?? 0)"
        cell.lblDown.isHidden = !mobileData.haveDecrease
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mobileData = self.viewModel.getItemAt(indexPath.row)
        if mobileData.haveDecrease {
            self.displayInfo(info: "Declined Quarter Data")
        }
    }

    // make sure to download rest of the content when
    // table view is scolled
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        let reload_distance:CGFloat = 10.0
        if y > (h + reload_distance) {
            //print("load more rows")
            if busyLoading {
                return
            }
            viewModelFetchData(false)
        }
    }
}
