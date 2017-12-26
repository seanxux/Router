//
//  URLNavigationMap.swift
//  seanxux
//
//  Created by seanxux on 16/12/2017.
//  Copyright © 2017 seanxux. All rights reserved.
//

import Foundation
import URLNavigator

// Global Router
let navigator = Navigator()

struct URLNavigationMap {
    // Register Router
    static func initialize(navigator: NavigatorType) {
        navigator.register(RouterType.web, self.webViewControllerFactory)
        navigator.register(RouterType.some, self.nibViewControllerFactory(SomeViewController.self))

        navigator.handle(RouterType.tabHome) { _, _, _ in
            self.switchToTabIndex(0)
            return true
        }
        navigator.handle(RouterType.tabWorkbench) { _, _, _ in
            self.switchToTabIndex(1)
            return true
        }
        navigator.handle(RouterType.tabMine) { _, _, _ in
            self.switchToTabIndex(2)
            return true
        }
    }
    
    // Class Controller Factory
    private static func classViewControllerFactory<T: UIViewController>(_: T.Type) -> URLNavigator.ViewControllerFactory {
        return { (url: URLConvertible, values: [String: Any], context: Any?) -> T? in
            guard url.urlValue != nil else { return nil }
            let viewController = T()
            viewController.hidesBottomBarWhenPushed = true
            return viewController
        }
    }
    
    // Nib Controller Factory
    private static func nibViewControllerFactory<T: UIViewController>(_: T.Type) -> URLNavigator.ViewControllerFactory {
        return { (url: URLConvertible, values: [String: Any], context: Any?) -> T? in
            guard url.urlValue != nil else { return nil }
            let className = NSStringFromClass(T.self).components(separatedBy: ".").last!
            let viewController = T(nibName: className, bundle: nil)
            viewController.hidesBottomBarWhenPushed = true
            return viewController
        }
    }
    
    // Web Controller Factory
    private static func webViewControllerFactory(url: URLConvertible, values: [String: Any], context: Any?) -> UIViewController? {
        guard let context = context as? [String: Any],
              let url = context[RouterKey.url] as? String,
              let token = AppContextManager.shared.account?.user?.token else { return nil }

        let webViewController = CRMWebViewController(nibName: "CRMWebViewController", bundle: nil)
        webViewController.hidesBottomBarWhenPushed = true
        if let reportUrl = URL(string: url)?.added(["token": token]) {
            webViewController.loadRequest(url: reportUrl)
        }
        return webViewController
    }
    
    // Switch Tab
    private static func switchToTabIndex(_ index: Int) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if let mainViewController = appDelegate.mainRootVC {
                mainViewController.selectedIndex = index
            }
        }
    }
}
