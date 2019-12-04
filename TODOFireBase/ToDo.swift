//
//  ToDo.swift
//  TODOFireBase
//
//  Created by Dipal Patel on 2019-11-27.
//  Copyright © 2019 Dipal Patel. All rights reserved.
//

import Foundation
import UIKit

class Todo: NSObject {
    // id which is set from firebase to uniquely identify it
    var uniqueId:String?
    var name :String?
    var message: String?
    var reminderDate: String?
    var completed:Bool?
}
