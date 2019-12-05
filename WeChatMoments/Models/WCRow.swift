//
//  WCRow.swift
//  WeChatMoments
//
//  Created by rainedAllNight on 2019/11/23.
//  Copyright © 2019 luowei. All rights reserved.
//

import Foundation
import UIKit

public struct WCRow {
    
    var cellIdentifier: CellIDable
    
    var data: Any?
    
    var rowHeight: CGFloat = UITableView.automaticDimension
    
    var cachedRowHeight: CGFloat?
}

protocol CellIDable {
    var identifier: String { get }
}
extension CellIDable where Self: RawRepresentable, RawValue == String {
    
    var identifier: String {
        return self.rawValue
    }
}
