//
//  Supplier.swift
//  
//
//  Created by Kayla Hoyet on 8/2/21.
//

import Foundation

public struct Supplier: Codable {
    
    internal static let path = "/supplier"
    internal static let listPath = Supplier.path + "/list"
    
    let entity: Entity
    let authorised: Bool
    let brand: Brand?
    let disposition: Disposition
    let partnershipManager: HumanHeadline?
    
    private enum CodingKeys: String, CodingKey {
        case entity
        case authorised
        case brand
        case disposition
        case partnershipManager = "partnership_manager"
    }
    
    public static func create(
        legalName: String,
        tradingName: String?,
        phoneNumber: String,
        address: Address.CreationData,
        session: SessionRepresentative?,
        endpoint: ApiEndpoint = ApiEndpoint.live,
        callback: @escaping (Error?, Supplier?) -> Void
    ) {
        Request.make(
            path: "/supplier/raw",
            payload: CreatePayload(
                legalName: legalName,
                tradingName: tradingName,
                phoneNumber: phoneNumber,
                address: address
            ),
            session: session,
            query: nil,
            method: .POST,
            endpoint: endpoint
        ) { error, data in
            Request.decodeResponse(error, data, Self.self, callback)
        }
    }
    
    public static func retrieve(
        supplierId: Int,
        session: SessionRepresentative?,
        endpoint: ApiEndpoint = ApiEndpoint.live,
        callback: @escaping (Error?, Self?) -> Void
    ) {
        Request.make(
            path: self.path,
            data: nil,
            session: session,
            query: QueryString(
                targetsOnly: [UrlParameter(supplierId, key: "supplier_id")]
                ),
            method: .GET,
            endpoint: endpoint
        ) { error, data in
            Request.decodeResponse(error, data, Self.self, callback)
            return
        }
    }
    
    private struct CreatePayload: Codable {
        let legalName: String
        let tradingName: String?
        let phoneNumber: String
        let address: Address.CreationData
        
        private enum CodingKeys: String, CodingKey {
            case legalName = "legal_name"
            case tradingName = "trading_name"
            case phoneNumber = "phone_number"
            case address
        }
    }
}
