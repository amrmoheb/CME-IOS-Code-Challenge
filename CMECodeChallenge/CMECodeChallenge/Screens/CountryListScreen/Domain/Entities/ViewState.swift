//
//  ViewState.swift
//  CMECodeChallenge
//
//  Created by Amr Moheb on 17/01/2025.
//

import Foundation
import SwiftUI

enum ViewState {
    case success(message: String)
    case failure(message: String)
    
    var message: String {
        switch self {
        case .success(let message), .failure(let message):
            return message
        }
    }
    
    var color: Color {
        switch self {
        case .success:
            return .green
        case .failure:
            return .red
        }
    }
}
