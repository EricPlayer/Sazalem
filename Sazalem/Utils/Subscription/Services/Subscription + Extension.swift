//
//  Subscription + Extension.swift
//  Sazalem
//
//  Created by Esset Murat on 2/10/18.
//  Copyright © 2018 Esset Murat. All rights reserved.
//

import Foundation
import StoreKit

extension SubscriptionService : SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for i in response.products {
            print(i.localizedTitle)
        }
        self.products = response.products
    }
}

extension SubscriptionService : SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            //print("Check purchase state")

            switch transaction.transactionState {
            case .purchasing : break
            case .failed :
                delegate?.showAlert()
                UserDefaults.standard.set(false, forKey: "isUserSubbed")
            case .purchased:
                UserDefaults.standard.set(true, forKey: "isUserSubbed")
                queue.finishTransaction(transaction)
            case .restored:
                UserDefaults.standard.set(true, forKey: "isUserSubbed")
                queue.finishTransaction(transaction)
                delegate?.showRestoredAlert()
                print("Restored")
            default: queue.finishTransaction(transaction)
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError: Error) {
        print(restoreCompletedTransactionsFailedWithError)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("restored #2")
    }
}

extension SKPaymentTransactionState {
    func status() -> String {
        switch self {
            case .deferred: return "deferred"
            case .failed: return "failed"
            case .purchased: return "purchased"
            case .purchasing: return "purchasing"
            case .restored: return "restored"
        }
    }
}
