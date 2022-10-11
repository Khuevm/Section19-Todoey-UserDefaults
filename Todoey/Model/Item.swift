//
//  Item.swift
//  Todoey
//
//  Created by Khue on 05/10/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct Item: Codable {
    let title: String
    var isDone: Bool = false
}
