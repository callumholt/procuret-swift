//
//  TermRate.swift
//
//
//  Created by Kayla Hoyet on 8/12/21.
//

import Foundation

public struct TermRate: Codable {
    
    internal static let path = "/term-rate"
    
    let indexid: Int
    let created: ProcuretTime
    let annualRate: Decimal
    let periods: Int
    let periodsPerYear: Decimal
    
    private enum CodingKeys: String, CodingKey {
        case indexid
        case created
        case annualRate = "annual_rate"
        case periods
        case periodsPerYear = "periods_in_year"
    }
    
    public static func create(
        supplierId: Int,
        annualRate: Decimal,
        periods: Int,
        periodsPerYear: Int,
        callback: @escaping (Error?, TermRate?) -> Void
    ) {
        Request.make(
            path: self.path,
            payload: CreatePayload(supplierId: supplierId,
                annualRate: annualRate, periods: periods,
                periodsPerYear: periodsPerYear),
            session: nil,
            query: nil,
            method: .POST
        ) { error, data in
                fatalError("Not implemented")
        }
    }
            
    private struct CreatePayload: Codable {
        let supplierId: Int
        let annualRate: Decimal
        let periods: Int
        let periodsPerYear: Int
                
        private enum CodingKeys: String, CodingKey {
            case supplierId = "supplier_id"
            case annualRate = "annual_rate"
            case periods
            case periodsPerYear = "periods_in_year"
        }
    }
}