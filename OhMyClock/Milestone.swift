//
//  Milestone.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-22.
//

import Foundation
import RealmSwift

class Milestone : Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title = ""
    @Persisted var completed = false
}
