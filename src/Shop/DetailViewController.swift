//
//  DetailViewController.swift
//  Shop
//
//  Created by Dubiel, Thomas on 07.09.17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit
import SAPCommon
import SAPFiori
import SAPOData

class DetailViewController: UIViewController {
   
   @IBOutlet var productView: ProductDetailView!
   
   let logger = Logger.shared(named: "DetailViewController")
   var productID: String?
   
   fileprivate var product: Product? {
      didSet {
         productView.product = product
         navigationController?.title = product?.name
         productView.delegate = self
      }
   }

   override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
      loadProductDetails()
   }

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   // MARK: Private Methods:
   
   /// Load the Product details including reviews and images
   func loadProductDetails() {
      
      if let productID = productID {
         
         // create a query for product matching the given ID
         var query = DataQuery().withKey(Product.key(id: productID))
         
         // include all associated images
         query = query.expand(Product.images)
         
         // include the associated reviews in the result and sort them by the helpful count in decending order
         // limit the result to 3 entries (top 3 helpful reviews)
         query = query.expand(Product.reviews, withQuery: DataQuery().orderBy(Review.helpfulCount, .descending).top(3))
         
         let loadingIndicator = FUIModalLoadingIndicator.show(inView: view)
         Shop.shared.oDataService?.product(query: query, completionHandler: {
            products, error in
            
            loadingIndicator.dismiss()
            
            guard error == nil else {
               self.logger.warn("Error while loading product details", error: error)
               self.product = nil
               return
            }
            
            self.product = products?.first
         })
      }
      
      NotificationCenter.default.post(name: Shop.shoppingCartDidUpdateNotification, object: nil)
   }

}

extension DetailViewController: ProductDetailViewDelegate {
   
   func didSelectAddToCart(_ button: FUIButton) {
      guard let product = product else {
         return
      }
      
      button.isEnabled = false
      
      Shop.shared.oDataService?.addProductToShoppingCart(productID: product.id) { shoppingCartItem, error in
         
         button.isEnabled = true
         
         guard error == nil else {
            self.logger.warn("Error adding product \(product.name) (\(product.id)) to shopping cart.", error: error)
            return
         }
         
         FUIToastMessage.show(message: "\(product.name) added to cart.", maxNumberOfLines: 2)
         NotificationCenter.default.post(name: Shop.shoppingCartDidUpdateNotification, object: nil)
      }
   }
   
   func didSelectReview(_ review: Review) {
      
   }
   
   func didSelectShowAllReviews(_ button: FUIButton) {
      
   }
   
   func didSelectWriteReview(_ button: FUIButton) {
      
   }
}
