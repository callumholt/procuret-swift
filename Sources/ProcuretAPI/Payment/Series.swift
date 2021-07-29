//
//  Series.swift
//  
//
//  Created by Kayla Hoyet on 7/29/21.
//

import Foundation

public struct PaymentSeries: Codable {
    
    let publicId: String
    let created: ProcuretTime
    let creatingAgent: String
    let paymentMethod: PaymentMethodHeadline
    let customer: EntityHeadline
    let supplier: EntityHeadline
    let exchangeId: String
    let amount: Amount
    let sumPayments: String
    let identifier: String
    let disposition: Disposition
    
    public enum CodingKeys: String, CodingKey {
        case publicId = "public_id"
        case created
        case creatingAgent = "creating_agent"
        case paymentMethod = "payment_method"
        case customer
        case supplier
        case exchangeId = "exchange_id"
        case amount
        case sumPayments = "sum_payments"
        case identifier
        case disposition
    }
    
    public static func create (
        paymentMethod: PaymentMethod,
        setupId: String,
        months: Int,
        session: Session?,
        callback: @escaping (Error?) -> Void
    ) {
        fatalError("Not implemented")
    }
    
    public static func createWithCommitment (
        commitmentId: String,
        session: Session?,
        callback: @escaping (Error?, Self?) -> Void
    ) {
        fatalError("Not implemented")
    }
    
    public static func retrieve (
        publicId: String,
        session: Session?,
        callback: @escaping (Error?, Self?) -> Void
    ) {
        fatalError("Not implemented")
    }
    
    public static func retrieveByCommitment (
        publicId: String,
        session: Session?,
        callback: @escaping (Error?, Self?) -> Void
    ) {
        fatalError("Not implemented")
    }
}