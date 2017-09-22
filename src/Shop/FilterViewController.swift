//
//  FilterViewController.swift
//  Shop
//
//  Created by Dubiel, Thomas on 22.09.17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit
import SAPFiori
import SAPOData

class FilterViewController: FUIFormTableViewController {

   @IBOutlet weak var cancelFilter: UIBarButtonItem!
   @IBOutlet weak var applyFilter: UIBarButtonItem!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
   
   // MARK: Public Methods
   
   @IBAction func applyFilter(_ sender: Any) {
   }
   
   @IBAction func cancelFilter(_ sender: Any) {
      dismiss(animated: true)
   }

   // MARK: Private Methods
   
   

}
