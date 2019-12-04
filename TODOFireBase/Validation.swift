//
//  Validation.swift
//  TODOFireBase
//
//  Created by Dipal Patel on 2019-12-04.
//  Copyright © 2019 Dipal Patel. All rights reserved.
//

import Foundation

class Validation {
    public func validateStringEmpty(name: String) ->Bool {
        let nameRegex = "^$"
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        return isValidateName
    }
    public func validateTitle(name: String) ->Bool {
        // Length be 18 characters max and 1 characters minimum
        let nameRegex = "^\\w{1,25}$"
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        return isValidateName
    }
    public func validateMessage(name: String) ->Bool {
        // Length be 18 characters max and 1 characters minimum
        let nameRegex = "^\\w{1,200}$"
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        return isValidateName
    }
  
}
