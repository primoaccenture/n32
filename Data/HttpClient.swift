//
//  HttpClient.swift
//  Data
//
//  Created by primozalho.d.filho on 13/12/24.
//

import Foundation

public protocol HttpClientPost {
    func post(to url: URL, with data: Data?)
    
}
