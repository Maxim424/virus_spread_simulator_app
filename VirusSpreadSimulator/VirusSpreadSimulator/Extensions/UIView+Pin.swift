//
//  UIView+Pin.swift
//  VirusSpreadSimulator
//

import UIKit

extension UIView {
    
    /// Describes existing sides of user interface object.
    public enum PinSide: Int {
        case top, bottom, left, right
    }
    
    /// Executes the process of pining user interface object to diverse sides.
    /// - Parameters:
    ///   - superview: User interface object which is pinned to pointed sides.
    ///   - sides: Array of sides on user interface object to point superview to.
    func pin(to superview: UIView, _ sides: [PinSide]) {
        for side in sides {
            switch side {
            case .top:
                pinTop(to: superview)
            case .bottom:
                pinBottom(to: superview)
            case .left:
                pinLeft(to: superview)
            case .right:
                pinRight(to: superview)
            }
        }
    }
    
    /// Executes the process of pining user interface object to diverse sides with constant value for each side.
    /// - Parameters:
    ///   - superview: User interface object which is pinned to pointed sides.
    ///   - sides: Array of sides on user interface object to point superview to.
    func pin(to superview: UIView, _ sides: [PinSide: Int]) {
            for side in sides {
                switch side.key {
                case .top:
                    pinTop(to: superview, side.value)
                case .bottom:
                    pinBottom(to: superview, side.value)
                case .left:
                    pinLeft(to: superview, side.value)
                case .right:
                    pinRight(to: superview, side.value)
                }
            }
        }
    
    /// Executes the process of pining user interface object to diverse sides with a fixed constant value for all sides.
    /// - Parameters:
    ///   - superview: User interface object which is pinned to pointed sides.
    ///   - sides: Array of sides on user interface object to point superview to.
    ///   - const: Fixed constant value for each view pinning.
    func pin(to superview: UIView, _ sides: [PinSide], _ const: Int = 0) {
        for side in sides {
            switch side {
            case .top:
                pinTop(to: superview, const)
            case .bottom:
                pinBottom(to: superview, const)
            case .left:
                pinLeft(to: superview, const)
            case .right:
                pinRight(to: superview, const)
            }
        }
    }
    
    /// Executes the process of pining user interface object to diverse sides.
    /// - Parameters:
    ///   - superview: User interface object which is pinned to pointed sides.
    ///   - sides: Array of sides on user interface object to point superview to.
    func pin(to superview: UIView, _ sides: PinSide...) {
        translatesAutoresizingMaskIntoConstraints = false
        for side in sides {
            switch side {
            case .top:
                pinTop(to: superview)
            case .left:
                pinLeft(to: superview)
            case .right:
                pinRight(to: superview)
            case .bottom:
                pinBottom(to: superview)
            }
        }
    }
    
    /// Executes the process of pining user interface object to all sides of view.
    /// - Parameter superview: User interface object which is pinned to pointed sides.
    func pin(to superview: UIView) {
        pinTop(to: superview)
        pinLeft(to: superview)
        pinRight(to: superview)
        pinBottom(to: superview)
    }
    
    /// Executes the process of pinning to the top of the user interface object with constant indent.
    /// - Parameters:
    ///   - superview: User interface object which is pinned to the top.
    ///   - const: Constant value of indent from top.
    /// - Returns: The relationship between two user interface objects that must be satisfied by the constraint-based layout system.
    @discardableResult
    func pinTop(to superview: UIView, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(
            equalTo: superview.topAnchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        
        return constraint
    }
    
    /// Executes the process of pinning to the side of the top of user interface object with constant indent.
    /// - Parameters:
    ///   - side: Side which is to pinned to the top of the user interface object.
    ///   - const: Constant value of indent from top.
    /// - Returns: The relationship between two user interface objects that must be satisfied by the constraint-based layout system.
    @discardableResult
    func pinTop(to side: NSLayoutYAxisAnchor, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        
        return constraint
    }
    
    /// Executes the process of pinning to the bottom of the user interface object with constant indent.
    /// - Parameters:
    ///   - superview: User interface object which is pinned to the bottom.
    ///   - const: Constant value of indent from bottom.
    /// - Returns: The relationship between two user interface objects that must be satisfied by the constraint-based layout system.
    @discardableResult
    func pinBottom(to superview: UIView, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(
            equalTo: superview.bottomAnchor,
            constant: CGFloat(const * -1)
        )
        constraint.isActive = true
        
        return constraint
    }

    /// Executes the process of pinning to the side of the bottom user interface object with constant indent.
    /// - Parameters:
    ///   - side: Side which is to pinned to the bottom of the user interface object.
    ///   - const: Constant value of indent from bottom.
    /// - Returns: The relationship between two user interface objects that must be satisfied by the constraint-based layout system.
    @discardableResult
    func pinBottom(to side: NSLayoutYAxisAnchor, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const * -1)
        )
        constraint.isActive = true
        
        return constraint
    }
    
    /// Executes the process of pinning to the left (leading anchor) of the user interface object with constant indent.
    /// - Parameters:
    ///   - superview: User interface object which is pinned to the left (leading anchor).
    ///   - const: Constant value of indent from left.
    /// - Returns: The relationship between two user interface objects that must be satisfied by the constraint-based layout system.
    @discardableResult
    func pinLeft(to superview: UIView, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = leadingAnchor.constraint(
            equalTo: superview.leadingAnchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        
        return constraint
    }
    
    /// Executes the process of pinning to the side of the left user interface object with constant indent.
    /// - Parameters:
    ///   - side: Side which is to pinned to the left of the user interface object.
    ///   - const: Constant value of indent from left.
    /// - Returns: The relationship between two user interface objects that must be satisfied by the constraint-based layout system.
    @discardableResult
    func pinLeft(to side: NSLayoutXAxisAnchor, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = leadingAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        
        return constraint
    }
    
    /// Executes the process of pinning to the right (trailing anchor) of the user interface object with constant indent.
    /// - Parameters:
    ///   - superview: User interface object which is pinned to the right (trailing anchor).
    ///   - const: Constant value of indent from right.
    /// - Returns: The relationship between two user interface objects that must be satisfied by the constraint-based layout system.
    @discardableResult
    func pinRight(to superview: UIView, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = trailingAnchor.constraint(
            equalTo: superview.trailingAnchor,
            constant: CGFloat(const * -1)
        )
        constraint.isActive = true
        
        return constraint
    }
    
    /// Executes the process of pinning to the side of the right user interface object with constant indent.
    /// - Parameters:
    ///   - side: Side which is to pinned to the right of the user interface object.
    ///   - const: Constant value of indent from right.
    /// - Returns: The relationship between two user interface objects that must be satisfied by the constraint-based layout system.
    @discardableResult
    func pinRight(to side: NSLayoutXAxisAnchor, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = trailingAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const * -1)
        )
        constraint.isActive = true
        
        return constraint
    }
    
    /// Sets height to user interface object by constant integer value.
    /// - Parameter const: Constant integer value describing height of user interface object.
    /// - Returns: The relationship between two user interface objects that must be satisfied by the constraint-based layout system.
    @discardableResult
    func setHeight(to const: Int) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalToConstant: CGFloat(const))
        constraint.isActive = true
        
        return constraint
    }
    
    /// Sets height to user interface object by constant integer value.
    /// - Parameter const: Constant integer value describing height of user interface object.
    /// - Returns: The relationship between two user interface objects that must be satisfied by the constraint-based layout system.
    @discardableResult
    func setHeight(to const: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalToConstant: CGFloat(const))
        constraint.isActive = true
        
        return constraint
    }
    
    /// Sets width to user interface object by constant integer value.
    /// - Parameter const: Constant integer value describing width of user interface object.
    /// - Returns: The relationship between two user interface objects that must be satisfied by the constraint-based layout system.
    @discardableResult
    func setWidth(to const: Int) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalToConstant: CGFloat(const))
        constraint.isActive = true
        
        return constraint
    }
    
    /// Sets width to user interface object by constant integer value.
    /// - Parameter const: Constant integer value describing width of user interface object.
    /// - Returns: The relationship between two user interface objects that must be satisfied by the constraint-based layout system.
    @discardableResult
    func setWidth(to const: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalToConstant: CGFloat(const))
        constraint.isActive = true
        
        return constraint
    }
    
    /// Executes the process of pinning to the center anchor of X coordinate of the user interface object with constant indent.
    /// - Parameters:
    ///   - superview: User interface object which is pinned to the center anchor of X coordinate.
    ///   - const: Constant value of indent from center anchor of X coordinate.
    /// - Returns: The relationship between two user interface objects that must be satisfied by the constraint-based layout system.
    @discardableResult
    func pinCenterX(to superview: UIView, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerXAnchor.constraint(
            equalTo: superview.centerXAnchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        
        return constraint
    }
    
    /// Executes the process of pinning to the center point of the X coordinate of user interface object with constant indent.
    /// - Parameters:
    ///   - center: Center point of the X coordinate.
    ///   - const: Constant value of indent from center anchor of X coordinate.
    /// - Returns: The relationship between two user interface objects that must be satisfied by the constraint-based layout system.
    @discardableResult
    func pinCenterX(to center: NSLayoutXAxisAnchor, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerXAnchor.constraint(
            equalTo: center,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        
        return constraint
    }
    
    /// Executes the process of pinning to the center anchor of Y coordinate of the user interface object with constant indent.
    /// - Parameters:
    ///   - superview: User interface object which is pinned to the center anchor of Y coordinate.
    ///   - const: Constant value of indent from center anchor of Y coordinate.
    /// - Returns: The relationship between two user interface objects that must be satisfied by the constraint-based layout system.
    @discardableResult
    func pinCenterY(to superview: UIView, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerYAnchor.constraint(
            equalTo: superview.centerYAnchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        
        return constraint
    }
    
    /// Executes the process of pinning to the center point of the Y coordinate of user interface object with constant indent.
    /// - Parameters:
    ///   - center: Center point of the Y coordinate.
    ///   - const: Constant value of indent from center anchor of Y coordinate.
    /// - Returns: The relationship between two user interface objects that must be satisfied by the constraint-based layout system.
    @discardableResult
    func pinCenterY(to center: NSLayoutYAxisAnchor, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerYAnchor.constraint(
            equalTo: center,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        
        return constraint
    }
    
    /// Pins superview to the center anchor of X and Y coordinates.
    /// - Parameter superview: User interface object which is pinned to the center anchor by X and Y coordinates.
    func pinCenter(to superview: UIView) {
        pinCenterX(to: superview)
        pinCenterY(to: superview)
    }
    
}
