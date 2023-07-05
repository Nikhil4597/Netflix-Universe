//
//  Extensions.swift
//  Netflix-Universe
//
//  Created by ROHIT MISHRA on 06/07/23.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
