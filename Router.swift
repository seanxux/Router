//
//  Router.swift
//  seanxux
//
//  Created by seanxux on 18/12/2017.
//  Copyright © 2017 seanxux. All rights reserved.
//

import Foundation

// URLScheme
public enum RouterType: String {
    // Web
    case web = "/web"
    // tab home
    case tabHome = "/tab_home"
    // tab workbench
    case tabWorkbench = "/tab_workbench"
    // tab mine
    case tabMine = "/tab_mine"
}

extension RouterType {
    // Full URL
    var url: String {
        return "scheme://seanxux.com" + self.rawValue
    }
}

// Router parameter Key
public struct RouterKey {
    static let url = "url"
    static let tabIndex = "tabIndex"
}

// Router
public struct Router {
    static let scheme = "scheme"
    var type: RouterType
    var parameters: [String: Any]
    var tabIndex: Int? {
        didSet {
            parameters[RouterKey.tabIndex] = tabIndex
        }
    }
    
    // App URL Scheme init
    init?(_ urlScheme: String, tabIndex: Int? = nil) {
        guard let url = URL(string: urlScheme) else {
            return nil
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.query = nil
        guard let path = urlComponents?.path else {
            return nil
        }
        guard let type = RouterType(rawValue: path) else {
            return nil
        }
        self.type = type
        self.parameters = urlScheme.queryParameters
        self.tabIndex = tabIndex
    }
    
    // Router init
    init(_ type: RouterType, parameters: [String: String] = [:], tabIndex: Int? = nil) {
        self.type = type
        self.parameters = parameters
        self.tabIndex = tabIndex
    }
    
    // Web URL init
    init(urlString: String) {
        self.type = .web
        self.parameters = [RouterKey.url: urlString]
    }
}
