// This source file is part of the vakoc.com open source project(s)
//
// Copyright © 2016 Mark Vakoc. All rights reserved.
// Licensed under Apache License v2.0
//
// See http://www.vakoc.com/LICENSE.txt for license information


import Foundation


extension Date {
    
    /// Returns self as an ISO8601 formatted string
    public var ISO8601String: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.string(from: self as Date)
    }
    
    /// Return the date as the yyyyMMdd format, e.g. 20161225 for Christmas Day 2016
    public var yearMonthDayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: self as Date)
    }
}

extension UUID {
    /// Simple UUID with all zero values
    public static let allZeros = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
}

extension String {
    
    /// The string parsed as a date using the ISO8601 string format
    var dateWithISO8601String: Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: self)
    }
    
    /// The string parsed as a date using the yyyyMMdd format, for example 20161225 for Christmas Day, 2016
    var dateWithYearMonthDay: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.date(from: self)
    }
    
    /// The last path component of a string
    ///
    /// basically anything after the last forward
    /// slash or self if it does not contain a forward slash
    var lastPathComponent: String {
        
        guard let lastRange = self.range(of: "/", options: [.backwards]) else {
            return self
        }
        return self.substring(with: lastRange.upperBound..<self.endIndex)
    }
}

extension Dictionary where Key: ExpressibleByStringLiteral, Value: ExpressibleByStringLiteral {
    
    /// The dictionary as a properly encoded url query
    var URLEncodedParameters: String? {
        
        var comps = URLComponents(string: "http://www.vakoc.com/")
        
        comps?.queryItems = self.map( { (key, value) -> URLQueryItem  in return URLQueryItem(name: "\(key)", value: "\(value)") })
        return comps?.percentEncodedQuery
    }
}




extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    
    /// Return the boolean value for a given key
    ///
    /// The method returns a boolean if the value or the given key is
    ///    - an instance of Bool
    ///    - a string.  Returns true if the case insensitive value is true or 1
    ///    - an Int.  Return true if the value is non-zero
    /// Otherwise nil is returned
    /// 
    /// - return: the boolean value for the key, or nil
    func bool(for key: Key) -> Bool? {
        
        switch (self[key]) {
        case .none:
            return nil
        case let val as Bool:
            return val
        case let val as String:
            return val.uppercased() == "TRUE" || val == "1"
        case let val as Int:
            return val > 0
        default:
            return nil
        }
    }
    
    /// The dictionary as a JSON object, or nil if the object cannot be converted to JSON
    var jsonString: String?  {
        if let dict = (self as AnyObject) as? Dictionary<String, AnyObject> {
            do {
                let data = try JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
                if let string = String(data: data, encoding: String.Encoding.utf8) {
                    return string
                }
            } catch {
                warn("Failed to convert \(self) to JSON with error \(error)")
            }
        }
        return nil
    }
}

extension Array where Element: AnyObject {
    
    /// The array as a JSON object, or nil if the object cannot be converted to JSON
    var jsonString: String?  {

        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            if let string = String(data: data, encoding: String.Encoding.utf8) {
                return string
            }
        } catch {
            warn("Failed to convert \(self) to JSON with error \(error)")
        }
        return nil
    }
}
