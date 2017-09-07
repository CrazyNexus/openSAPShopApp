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
import SAPOData

class ProductListViewController: UIViewController {
   
   @IBOutlet weak var tableView: UITableView!
   
   let logger = Logger.shared(named: "ProductListViewController")
   let objectCellId = "ProductCellID"
   
   fileprivate var products = [Product]()

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
   
   // MARK: Public Methods
   
   public func loadProducts() {
      // select the properties to load
      var query = DataQuery().select(Product.id,
                                     Product.name,
                                     Product.description,
                                     Product.price,
                                     Product.currencyCode,
                                     Product.stockQuantity,
                                     Product.mainCategoryName,
                                     Product.ratingCount,
                                     Product.averageRating)
      
      // expand the primary image
      query = query.expand(Product.primaryImage)
      
      // load the whole product list with all required properties
      let loadingIndicator = FUIModalLoadingIndicator.show(inView: tableView)
      Shop.shared.oDataService?.product(query: query, completionHandler: {
         products, error in
         
         loadingIndicator.dismiss()
         self.tableView.separatorStyle = .singleLine
         self.loadingProductsCompleted(loadedProducts: products, error: error)
      })
   }
   
   // MARK: Private Methods
   
   /// Assign the loaded products, update the counter, reload the table and check if any errors occured
   func loadingProductsCompleted(loadedProducts: [Product]?, error: Error?) {
      var products = [Product]()
      
      if let loadedProducts = loadedProducts {
         products = loadedProducts
      }
      else if let error = error {
         logger.error("Error loading Product.", error: error)
         
         let optionMenu = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
         optionMenu.addAction(UIAlertAction(title: "OK", style: .cancel))
         present(optionMenu, animated: true)
      }
      
      self.products = products
      tableView.reloadData()
   }
   
   // MARK: - Navigation
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let identifier = segue.identifier {
         switch identifier {
         case "showProductDetailSegue":
            let detailController = segue.destination as! DetailViewController
            let selectedRow = sender as! FUIObjectTableViewCell
            let selectedIndexPath = tableView.indexPath(for: selectedRow)!
            let selectedProduct = products[selectedIndexPath.row]
            detailController.productID = selectedProduct.id
            
         default:
            break
         }
      }
   }
   
}

extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {
   
   // Table view data source
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return products.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let objectCell = tableView.dequeueReusableCell(withIdentifier: objectCellId,
                                                     for: indexPath as IndexPath) as! FUIObjectTableViewCell
      
      let product = products[indexPath.row]
      
      objectCell.headlineText = product.name
      objectCell.subheadlineText = product.id
      objectCell.footnoteText = product.mainCategoryName
      objectCell.descriptionText = product.description
      objectCell.detailImage = #imageLiteral(resourceName: "Placeholder")
      objectCell.detailImage?.accessibilityIdentifier = product.name
      objectCell.statusText = product.formattedPrice
      objectCell.substatusText = product.stockAvailability.itemText
      objectCell.substatusLabel.textColor = product.stockAvailability.color
      
      objectCell.accessoryType = .disclosureIndicator
      objectCell.splitPercent = CGFloat(0.4)
      
      product.loadPrimaryImage {
         image, error in
         
         guard error == nil else {
            self.logger.warn("Error while loading image", error: error)
            return
         }
         
         if let image = image {
            let delayedUpdateCell = tableView.cellForRow(at: indexPath) as? FUIObjectTableViewCell
            delayedUpdateCell?.detailImage = image
         }
      }
      
      return objectCell
   }
   
}
