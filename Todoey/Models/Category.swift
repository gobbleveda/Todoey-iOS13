//
//  Category.swift
//  Todoey
//
//  Created by Gobble Veda on 8/1/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
