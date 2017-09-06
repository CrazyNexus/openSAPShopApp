//
//  ViewController.swift
//  Shop
//
//  Copyright © 2017 SAP SE or an SAP affiliate company. All rights reserved.
//  Use of this software subject to the End User License Agreement located in ../EULA.pdf
//

import UIKit
import SAPCommon
import SAPFiori

class ProductListViewController: UIViewController {
   
   @IBOutlet weak var tableView: UITableView!
   
   let logger = Logger.shared(named: "ProductListViewController")
   let objectCellId = "ProductCellID"

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      tableView.estimatedRowHeight = 80
      tableView.rowHeight = UITableViewAutomaticDimension
      tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: objectCellId)
   }
   
}

extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {
   
   // Table view data source
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // return the number of rows
      return 1
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let objectCell = tableView.dequeueReusableCell(withIdentifier: objectCellId,
                                                     for: indexPath as IndexPath) as! FUIObjectTableViewCell
      
      objectCell.headlineText = "Speed Mouse"
      objectCell.subheadlineText = "HT-1061"
      objectCell.footnoteText = "Computer Components"
      objectCell.descriptionText = "Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)"
      objectCell.detailImage = UIImage() // TODO: Replace with your image
      objectCell.detailImage?.accessibilityIdentifier = "Speed Mouse"
      objectCell.statusText = "7.00 USD"
      objectCell.substatusText = "In Stock"
      objectCell.substatusLabel.textColor = .preferredFioriColor(forStyle: .positive)
      objectCell.accessoryType = .disclosureIndicator
      objectCell.splitPercent = CGFloat(0.4)
      
      return objectCell
   }
   
}
