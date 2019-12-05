//
//  File Name: ToDo.swift
//  App name: TODOFireBase
//  Student ID: 301090880
//  Author's name: Dipal Patel on 2019-11-27.
//  File Description: Main ViewController which list all todo's
//  Copyright © 2019 Dipal Patel. All rights reserved.
//
//

import Foundation
import UIKit

class Todo: NSObject {
    // id which is set from firebase to uniquely identify it
    var uniqueId:String?
    var name :String?
    var message: String?
    var reminderDate: String?
    var completed:String? = "false"
}
