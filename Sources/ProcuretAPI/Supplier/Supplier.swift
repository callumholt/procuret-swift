//
//  Supplier.swift
//  
//
//  Created by Kayla Hoyet on 8/2/21.
//

import Foundation

public struct Supplier: Codable, Identifiable, Equatable, Hashable {
    
    internal static let path = "/supplier"
    internal static let listPath = Supplier.path + "/list"
    
    let entity: Entity
    let authorised: Bool
    let brand: Brand?
    let disposition: Disposition
    let partnershipManager: HumanHeadline?
    
    public var id: Int { return self.entity.publicId }

    public var friendlyName: String {
        return self.brand?.name ?? self.entity.legalEntityName
    }

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
    
    public enum OrderBy: String {
        
        case created = "created"
        case modified = "modified"
        case legalName = "legal_name"
        case brandName = "brand_name"
        case transactionCount = "transaction_count"
        case lastTransactiontime = "last_transaction_time"
        
    }
    
    public func retrieveMany(
        authenticatedBy session: SessionRepresentative,
        limit: Int = 20,
        offset: Int = 0,
        order: Order = .descending,
        orderBy: Self.OrderBy = .legalName,
        withAnyNameIncludingCharacters anyNameFragment: String? = nil,
        accessibleToAgentWithId: Int? = nil,
        withLegalNameIncludingCharacters legalNameFragment: String? = nil,
        withBrandNameIncludingCharacters brandNameFragment: String? = nil,
        authorisedToTransact authorised: Bool? = nil,
        havingBrand withBrand: Bool? = nil,
        havingTransacted hasTransacted: Bool? = nil,
        withDefaultDenomination defaultDenomination: Currency? = nil,
        active: Bool? = nil,
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
                UP.optionally(anyNameFragment, key: "any_name"),
                UP.optionally(accessibleToAgentWithId, key: "accessible_to"),
                UP.optionally(legalNameFragment, key: "legal_name"),
                UP.optionally(brandNameFragment, key: "brand_name"),
                UP.optionally(authorised, key: "authorised_to_transact"),
                UP.optionally(withBrand, key: "has_brand"),
                UP.optionally(hasTransacted, key: "has_transacted"),
                UP.optionally(
                    defaultDenomination?.indexid,
                    key: "default_denomination"
                ),
                UP.optionally(active, key: "active")
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
    
    public static func == (lhs: Supplier, rhs: Supplier) -> Bool {
        return lhs.entity.publicId == rhs.entity.publicId
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.entity.publicId)
        return
    }

}
