import Vapor
import Foundation

func routes(_ app: Application) throws {
    
    struct Password: Content {
        let password: String
    }

    app.get("validate") { req -> Int in
        
        do {
            let email = try req.query.get(String.self, at: "email")
            if !isValidEmail(email) { return 400 }
            req.logger.info("Parsed param `email`: \(email)")
            
//            let data = try req.content.decode(Password.self)
//            data.encodeResponse(status: .ok, headers: ["":"url-encoded"], for: req)
            
            
            var password = try req.query.get(String.self, at: "password")
            if !isValidPassword(&password) { return 400 }
            req.logger.info("Parsed param `password`: \(password)")
        } catch {
            return 400
        }
        
        return 200
    }
}

//mutating func beforeEncode() {
//
//}

func isValidEmail(_ email: String) -> Bool {
    
    let emailParts = email.components(separatedBy:"@")
    
    if emailParts.count != 2 { return false } /// no @ or two and more
    
    if !emailParts[0].isAlphanumeric() { return false } /// name is not alphanumeric
    
    let domens = emailParts[1].components(separatedBy: ".")
    if domens.count != 2 { return false } /// no dot or 2 and more
    
    if !domens[0].isAlpahabetic() { return false } /// first domen is not alphabetic
    if !domens[1].isAlpahabetic() { return false } /// second domen is not alphabetic
    
    return true
}

func isValidPassword(_ password: inout String) -> Bool {
    
    if (password.count < 8) { return false } /// password is shorther than 8 digits
    
    /// check for only english letters
    if !(password.canBeConverted(to: .isoLatin1)) { return false } /// non latin letters
    
    /// check for at least one lower letter, upper letter, digit and symbol; no whitespaces
    let uppercaseLetters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ") // or .uppercaseLetters
    let lowecaseLetters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz") // or .lowecaseLetters
    let digits = CharacterSet(charactersIn: "0123456789") //or .decimalDigits
    let specialChars = CharacterSet(charactersIn: "-+_$#")
    let whitespaces = CharacterSet.whitespaces
    
    if password.rangeOfCharacter(from: uppercaseLetters) == nil { return false }
    if password.rangeOfCharacter(from: lowecaseLetters) == nil { return false }
    if password.rangeOfCharacter(from: digits) == nil { return false }
    if password.rangeOfCharacter(from: specialChars) == nil { return false }
    if password.rangeOfCharacter(from: whitespaces) != nil { return false }
    
    return true
}

extension String {
    
    func consistsOf(set acceptableChars: String) -> Bool {
        if self.isEmpty { return false }
        
        let nonAcceptableChars = CharacterSet(charactersIn: acceptableChars).inverted
        let filteredText = self.components(separatedBy: nonAcceptableChars).joined(separator: "") /// remove nonAcceptableChars
        
        if self != filteredText { /// compare passed in text with filteredText
            return false
        }
        return true
    }
    
    /// validate name
    func isAlphanumeric() -> Bool {
        let alphanumerics = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        return self.consistsOf(set: alphanumerics) ? true : false
    }
    
    /// validate domen
    func isAlpahabetic() -> Bool {
        let alphabetics = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        return self.consistsOf(set: alphabetics) ? true : false
    }
}
