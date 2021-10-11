//
//  SecondFactorCode.swift
//  
//
//  Created by Kayla Hoyet on 10/11/21.
//

import Foundation

public struct SecondFactorCode: Codable {
    
    private static let path = "/second-factor-code"
    
    public static func create(
        email: String?,
        agentId: String?,
        secret: String,
        perspective: Perspective?,
        callback: @escaping (Error?) -> Void
    ) {
        Request.make(
            path: self.path,
            payload: CreatePayload(
                email: email,
                agentId: agentId,
                secret: secret,
                perspective: perspective
            ),
            session: nil,
            query: nil,
            method: .POST
        ) { error, data in
            fatalError("Not implemented")
        }
    }
    
    private struct CreatePayload: Codable {
        let email: String?
        let agentId: String?
        let secret: String
        let perspective: Perspective?
        
        private enum CodingKeys: String, CodingKey {
            case email
            case agentId = "agent_id"
            case secret = "plaintext_secret"
            case perspective
        }
    }
}
