//
//  RefundPaymentResponse.swift
//  FlyShop
//
//  Created by Karen Mirakyan on 6/4/20.
//  Copyright © 2020 Karen Mirakyan. All rights reserved.
//

import Foundation
struct RefundPaymentResponse: Codable {
    var Opaque: String
    var ResponseCode: String
    var ResponseMessage: String
}
