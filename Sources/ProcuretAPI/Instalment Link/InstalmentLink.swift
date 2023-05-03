//
//  InstalmentLink.swift
//  
//
//  Created by Kayla Hoyet on 7/29/21.
//

import Foundation

public struct InstalmentLink: Codable {
    
    internal static let path = "/instalment-link"
    internal static let listPath = InstalmentLink.path + "/list"
    
    let publicId: String
    let supplier: EntityHeadline
    let created: String
    let inviteeEmail: String
    let invoiceAmount: String
    let invoiceIdentifier: String
    let opens: Array<InstalmentLinkOpen>
    let disposition: Disposition?
    
    public enum OrderBy: String, Codable {
        case created = "created"
    }
    
    public enum CodingKeys: String, CodingKey {
        case publicId = "public_id"
        case supplier
        case created
        case inviteeEmail = "invitee_email"
        case invoiceAmount = "invoice_amount"
        case invoiceIdentifier = "invoice_identifier"
        case opens
        case disposition
    }
    
    public enum Nomenclature: Int, Codable, CaseIterable {
        
        case invoice = 1
        case order = 2
        case reference = 4

        public var name: String { get {
        
            switch self {
            case .invoice:
                return "Invoice"
            case .order:
                return "Order"
            case .reference:
                return "Reference"
            }

        } }
        
    }
    
    public static func create(
        authenticatedBy session: SessionRepresentative,
        supplier: Supplier,
        amount: Amount,
        identifier: String,
        inviteeEmail: String,
        communicate: Bool,
        inviteePhone: String? = nil,
        at endpoint: ApiEndpoint = ApiEndpoint.live,
        callback: @escaping (Error?, InstalmentLink?) -> Void
    ) {
        Request.make(
            path: self.path,
            payload: CreatePayload(
                supplier_id: supplier.entity.publicId,
                invoice_amount: amount.rawMagnitude,
                denomination: amount.denomination.indexid,
                invoice_identifier: identifier,
                invitee_email: inviteeEmail,
                communicate: communicate,
                nomenclature: nil,
                invitee_phone: inviteePhone
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
        publicId: String,
        session: SessionRepresentative?,
        endpoint: ApiEndpoint = ApiEndpoint.live,
        callback: @escaping (Error?, InstalmentLink?) -> Void
    ) {
        Request.make(
            path: self.path,
            data: nil,
            session: session,
            query: QueryString([UrlParameter(publicId, key: "public_id")]),
            method: .GET,
            endpoint: endpoint
        ) { error, data in
            Request.decodeResponse(error, data, Self.self, callback)
        }
    }
    
    public static func retrieveMany(
        authenticatedBy session: SessionRepresentative,
        limit: Int = 20,
        offset: Int = 0,
        order: Order = Order.descending,
        orderBy: Self.OrderBy = .created,
        opened: Bool? = nil,
        supplier: Supplier? = nil,
        publicId: String? = nil,
        accessibleTo: Agent? = nil,
        createdBy: Agent? = nil,
        at endpoint: ApiEndpoint = .live,
        then callback: @escaping (Error?, Array<Self>?) -> Void
    ) {
       
        typealias UP = UrlParameter
        
        Request.make(
            path: Self.listPath,
            data: nil,
            session: session,
            query: QueryString([
                UP(limit, key: "limit"),
                UP(offset, key: "offset"),
                UP(order.rawValue, key: "order"),
                UP(orderBy.rawValue, key: "order_by"),
                UP.optionally(opened, key: "opened"),
                UP.optionally(supplier?.entity.publicId, key: "supplier_id"),
                UP.optionally(publicId, key: "public_id"),
                UP.optionally(accessibleTo?.agentId, key: "accessible_to"),
                UP.optionally(createdBy?.agentId, key: "created_by")
            ].compactMap { $0 }),
            method: .GET,
            endpoint: endpoint
        ) { error, data in
            Request.decodeResponse(error, data, Array<Self>.self, callback)
            return
        }

        return

    }
    
    private struct CreatePayload: Codable {
    
        let supplier_id: Int
        let invoice_amount: String
        let denomination: Int
        let invoice_identifier: String
        let invitee_email: String
        let communicate: Bool
        let nomenclature: Int?
        let invitee_phone: String?
        
    }

}
