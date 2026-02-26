//
//  LogToFile.swift
//  Yew
//
//  Created by HimanshuChimanji  on 16/09/24.
//

import Foundation
import UIKit

public func logToFile(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    let output = items.map { "\($0)" }.joined(separator: separator) + terminator
#if !DISABLE_LOGGING
    Swift.print(output)
#endif
    
}
