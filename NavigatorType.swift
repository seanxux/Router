//
//  NavigatorType.swift
//  seanxux
//
//  Created by seanxux on 16/12/2017.
//  Copyright © 2017 seanxux. All rights reserved.
//

import Foundation
import URLNavigator

extension NavigatorType {
    func register(_ router: RouterType, _ factory: @escaping URLNavigator.ViewControllerFactory) {
        register(router.url, factory)
    }
    
    func handle(_ router: RouterType, _ factory: @escaping URLOpenHandlerFactory) {
        handle(router.url, factory)
    }
    
    @discardableResult
    public func push(_ router: Router) -> UIViewController? {
        // switch tab index
        if let tabIndex = router.tabIndex {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                if let mainViewController = appDelegate.mainRootVC {
                    if let navigationController = mainViewController.selectedViewController as? UINavigationController {
                        navigationController.popToRootViewController(animated: false)
                    }
                    mainViewController.selectedIndex = tabIndex
                }
            }
        }
        return self.push(router.type.url, context: router.parameters)
    }
    
    @discardableResult
    public func present(_ router: Router) -> UIViewController? {
        return self.present(router.type.url, context: router.parameters)
    }
    
    @discardableResult
    public func push(_ type: RouterType, context: Any? = nil, from: UINavigationControllerType? = nil, animated: Bool = true) -> UIViewController? {
        return self.pushURL(type.url, context: context, from: from, animated: animated)
    }
    
    @discardableResult
    public func present(_ type: RouterType, context: Any? = nil, wrap: UINavigationController.Type? = nil, from: UIViewControllerType? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        return self.presentURL(type.url,
                               context: context,
                               wrap: wrap,
                               from: from,
                               animated: animated,
                               completion: completion)
    }
    
    @discardableResult
    public func open(_ router: RouterType, context: Any? = nil) -> Bool {
        return self.openURL(router.url, context: context)
    }
}
