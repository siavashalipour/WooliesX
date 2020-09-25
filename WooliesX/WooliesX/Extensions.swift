//
//  Extensions.swift
//  WooliesX
//
//  Created by Siavash on 24/9/20.
//  Copyright © 2020 Siavash. All rights reserved.
//

import UIKit

extension UITableView {

    func dequeueCell<T: UITableViewCell>(ofType type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else { return T() }
        return cell
    }
}
extension String {
    
    var maxLifeSpan: Int {
        // split string into substrings that only contain numbers
        let substrings = self.components(separatedBy: CharacterSet.decimalDigits.inverted)

        let numbers = substrings.compactMap {
          // convert each substring into an Int?
          return Int($0)
        }
        
        return numbers.last ?? 0
    }
}

