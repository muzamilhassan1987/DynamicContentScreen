//
//  UITableView+Common.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import UIKit

public protocol NibProvidable {
     static var nibName: String { get }
     static var nib: UINib { get }
}

public extension NibProvidable {
     static var nibName: String {
        return "\(self)"
    }
    static var nib: UINib {
        return UINib(nibName: self.nibName, bundle: nil)
    }
}

public protocol ReusableView {
     static var reuseIdentifier: String { get }
}

extension ReusableView {
    public static var reuseIdentifier: String {
        return "\(self)"
    }
}

// Cell
public extension UITableView {
    static func indetifier() -> String {
        return "\(self)"
    }
    static func nib() -> UINib {
        return UINib.init(nibName: "\(self)", bundle: nil)
    }
    func registerClass<T: UITableViewCell>(cellClass `class`: T.Type) where T: ReusableView {
        register(`class`, forCellReuseIdentifier: `class`.reuseIdentifier)
    }

    func registerNib<T: UITableViewCell>(cellClass `class`: T.Type) where T: NibProvidable & ReusableView {
        register(`class`.nib, forCellReuseIdentifier: `class`.reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(withClass `class`: T.Type) -> T? where T: ReusableView {
        return self.dequeueReusableCell(withIdentifier: `class`.reuseIdentifier) as? T
    }

    func dequeueReusableCell<T: UITableViewCell>(withClass `class`: T.Type, forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = self.dequeueReusableCell(withIdentifier: `class`.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Error: cell with identifier: \(`class`.reuseIdentifier) for index path: \(indexPath) is not \(T.self)")
        }
        return cell
    }
}
public extension UITableViewCell {
    static func identifier() -> String {
        return "\(self)"
    }
    static func nib() -> UINib {
        return UINib.init(nibName: "\(self)", bundle: nil)
    }
}
