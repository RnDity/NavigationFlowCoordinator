//
//  Extensions.swift
//  NavigationFlowCoordinatorExample
//
//  Created by Rafał Urbaniak on 04/08/2017.
//  Copyright © 2017 Rndity. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showLoader() {
        let backgroundView = UIView()
        backgroundView.tag = 1000

        backgroundView.backgroundColor = UIColor.white
        backgroundView.alpha = 0.7
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = UIColor.black
        backgroundView.addSubview(activityIndicator)
        activityIndicator.applySizeAttribute(attribute: .width, ofValue: 100)
        activityIndicator.applySizeAttribute(attribute: .height, ofValue: 100)
        activityIndicator.alignSame(attribute: .centerX, of: backgroundView)
        activityIndicator.alignSame(attribute: .centerY, of: backgroundView)
        
        activityIndicator.startAnimating()

        view.addSubview(backgroundView)
        
        backgroundView.alignAllEdgesTo(item: view)
    }
    
    func hideLoader() {
        if let loaderBackgroundViewIndex = view.subviews.index(where: {$0.tag == 1000}) {
            view.subviews[loaderBackgroundViewIndex].removeFromSuperview()
        }
    }
}

extension UIView {
    
    //MARK: ARBITRARY attributes
    @discardableResult
    public func align(attribute: NSLayoutAttribute,
                      to otherAttribute: NSLayoutAttribute,
                      of otherItem: AnyObject,
                      constant: CGFloat) -> NSLayoutConstraint {
        return align(attribute: attribute, to: otherAttribute, of: otherItem, constant: constant, relatedBy: .equal, priority: 1000)
    }
    
    @discardableResult
    public func align(attribute: NSLayoutAttribute,
                      to otherAttribute: NSLayoutAttribute,
                      of otherItem: AnyObject,
                      constant: CGFloat = 0,
                      relatedBy: NSLayoutRelation = .equal,
                      priority: UILayoutPriority = 1000) -> NSLayoutConstraint {
        return align(attribute: attribute, to: otherAttribute, of: otherItem, constant: constant, relatedBy: relatedBy, priority: priority, multiplier: 1.0)
    }
    
    @discardableResult
    public func align(attribute: NSLayoutAttribute,
                      to otherAttribute: NSLayoutAttribute,
                      of otherItem: AnyObject,
                      constant: CGFloat = 0,
                      relatedBy: NSLayoutRelation = .equal,
                      priority: UILayoutPriority = 1000,
                      multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relatedBy, toItem: otherItem, attribute: otherAttribute, multiplier: multiplier, constant: constant)
        constraint.priority = priority
        constraint.isActive = true
        
        return constraint
    }
    
    public func alignHorizontallyWithParent(constant: CGFloat = 0) {
        alignHorizontally(with: superview!, constant: constant)
    }
    
    public func alignVerticallyWithParent(constant: CGFloat = 0) {
        alignVertically(with: superview!, constant: constant)
    }
    
    public func alignHorizontally(with otherItem: AnyObject, constant: CGFloat = 0) {
        alignSame(attribute: .left, of: otherItem, constant: constant)
        alignSame(attribute: .right, of: otherItem, constant: -constant)
    }
    
    public func alignVertically(with otherItem: AnyObject, constant: CGFloat = 0) {
        alignSame(attribute: .top, of: otherItem, constant: constant)
        alignSame(attribute: .bottom, of: otherItem, constant: -constant)
    }
    
    //MARK: SAME attribute
    @discardableResult
    public func alignSame(attribute: NSLayoutAttribute,
                          of otherItem: AnyObject,
                          constant: CGFloat) -> NSLayoutConstraint {
        return alignSame(attribute: attribute, of: otherItem, constant: constant, relatedBy: .equal, priority: 1000)
    }
    
    @discardableResult
    public func alignSame(attribute: NSLayoutAttribute,
                          of otherItem: AnyObject,
                          constant: CGFloat = 0,
                          relatedBy: NSLayoutRelation = .equal,
                          priority: UILayoutPriority = 1000) -> NSLayoutConstraint {
        return align(attribute: attribute, to: attribute, of: otherItem, constant: constant, relatedBy: relatedBy, priority: priority, multiplier: 1.0)
        
    }
    
    //MARK: SIZE attributes
    @discardableResult
    public func applySizeAttribute(attribute: NSLayoutAttribute,
                                   ofValue value: CGFloat,
                                   relatedBy: NSLayoutRelation = .equal,
                                   priority: UILayoutPriority = 1000) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relatedBy, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: value)
        constraint.priority = priority
        constraint.isActive = true
        
        return constraint
    }
    
    //MARK: Convenience methods
    @discardableResult
    public func alignSuperviewAttribute(attribute: NSLayoutAttribute,
                                        to otherAttribute: NSLayoutAttribute,
                                        of otherItem: AnyObject,
                                        constant: CGFloat = 0,
                                        relatedBy: NSLayoutRelation = .equal,
                                        priority: UILayoutPriority = 1000) -> NSLayoutConstraint {
        return align(attribute: attribute, to: otherAttribute, of: otherItem, constant: constant, relatedBy: .equal, priority: 1000, multiplier: 1.0)
    }
    
    public func alignAllEdgesTo(item: AnyObject, padding: CGFloat = 0) {
        alignSame(attribute: .top, of: item, constant: padding)
        alignSame(attribute: .leading, of: item, constant: padding)
        alignSame(attribute: .trailing, of: item, constant: -padding)
        alignSame(attribute: .bottom, of: item, constant: -padding)
    }
    
    public func stickToBottomOf(item: AnyObject, spacing: CGFloat = 0, alignVerticalEdges: Bool = false) {
        align(attribute: .top, to: .bottom, of: item, constant: spacing)
        
        if alignVerticalEdges {
            alignSame(attribute: .leading, of: item)
            alignSame(attribute: .trailing, of: item)
        }
    }
    
    public func stickToRightOf(item: AnyObject, spacing: CGFloat = 0, alignHorizontalEdges: Bool = false) {
        align(attribute: .leading, to: .trailing, of: item, constant: spacing)
        
        alignHorizontalEdgesIfNecessary(align: alignHorizontalEdges, item: item)
    }
    
    public func stickToLeftOf(item: AnyObject, spacing: CGFloat = 0, alignHorizontalEdges: Bool = false) {
        align(attribute: .trailing, to: .leading, of: item, constant: -spacing)
        
        alignHorizontalEdgesIfNecessary(align: alignHorizontalEdges, item: item)
    }
    
    private func alignHorizontalEdgesIfNecessary(align: Bool, item: AnyObject) {
        if align {
            alignSame(attribute: .top, of: item)
            alignSame(attribute: .bottom, of: item)
        }
    }
}
