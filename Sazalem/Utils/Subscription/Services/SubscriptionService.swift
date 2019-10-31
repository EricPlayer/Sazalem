//
//  SubscriptionService.swift
//  Sazalem
//
//  Created by Esset Murat on 2/10/18.
//  Copyright © 2018 Esset Murat. All rights reserved.
//

import Foundation
import StoreKit

class SubscriptionService : NSObject {
    private override init() {}
    static let shared = SubscriptionService()
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    var delegate : SubscriptionViewControllerDelegate?
    
    func getSubscription() {
        let sub : Set = [Subscription.monthly.rawValue, Subscription.yearly.rawValue]
        let request = SKProductsRequest(productIdentifiers: sub)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    func purchase(product : Subscription) {
        guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue }).first else { return }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restorePurchases() {
        if (SKPaymentQueue.canMakePayments()) {
            paymentQueue.restoreCompletedTransactions()
            paymentQueue.add(self)
            print("Restore begin")
        }
    }
    
}
