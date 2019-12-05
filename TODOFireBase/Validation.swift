//
//  File Name: Validation.swift
//  App name: TODOFireBase
//  Student ID: 301090880
//  Author's name: Dipal Patel on 2019-11-27.
//  File Description: Main ViewController which list all todo's
//  Copyright © 2019 Dipal Patel. All rights reserved.
//
//


import Foundation

//validation methods for title and message
class Validation {
    //if name is empty then return true
    public func validateStringEmpty(name: String) ->Bool {
        let nameRegex = "^$"
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        return isValidateName
    }
    //if name is more than 25 character then return false
    public func validateTitle(name: String) ->Bool {
        // Length be 18 characters max and 1 characters minimum
        let nameRegex = "^\\w{1,25}$"
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        return isValidateName
    }
    //if name is more than 200 character then return false
    public func validateMessage(name: String) ->Bool {
        // Length be 18 characters max and 1 characters minimum
        let nameRegex = "^\\w{1,200}$"
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        return isValidateName
    }
  
}
