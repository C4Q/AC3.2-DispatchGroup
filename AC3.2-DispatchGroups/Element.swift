//
//  Element.swift
//  AC3.2-DispatchGroups
//
//  Created by Jason Gresh on 4/26/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class Element {
    let number: Int
    let weight: Double
    let name: String
    let symbol: String
    let melting_c: Double?
    let boiling_c: Double?
    let density: Double?
    let crust_percent: Double?
    let discovery_year: String
    let group: Int
    let electrons: String?
    let ion_energy: Double?
    
    init?(from dictionary:[String:Any]) {
        guard let number = dictionary["number"] as? Int,
            let weight = dictionary["weight"] as? Double,
            let name = dictionary["name"] as? String,
            let symbol = dictionary["symbol"] as? String,
            let discovery_year = (dictionary["discovery_year"] ?? "") as? String,
            let group = dictionary["group"] as? Int
            else { return nil }
        
        self.number = number
        self.weight = weight
        self.name = name
        self.symbol = symbol
        self.discovery_year = discovery_year
        self.group = group
        
        if let crust_percent = dictionary["crust_percent"] as? Double {
            self.crust_percent = crust_percent
        }
        else {
            self.crust_percent = nil
        }
        
        if let melting_c = dictionary["melting_c"] as? Double {
            self.melting_c = melting_c
        }
        else {
            self.melting_c = nil
        }
        
        if let boiling_c = dictionary["boiling_c"] as? Double {
            self.boiling_c = boiling_c
        }
        else {
            self.boiling_c = nil
        }
        
        if let density = dictionary["density"] as? Double {
            self.density = density
        }
        else {
            self.density = nil
        }
        
        if let electrons = dictionary["electrons"] as? String {
            self.electrons = electrons
        }
        else {
            self.electrons = nil
        }
        
        if let ion_energy = dictionary["ion_energy"] as? Double {
            self.ion_energy = ion_energy
        }
        else {
            self.ion_energy = nil
        }
    }
    
    static func getElements(from arr:[[String:Any]]) -> [Element] {
        var elements = [Element]()
        for elementDict in arr {
            if let element = Element (from: elementDict) {
                elements.append(element)
            }
        }
        return elements
    }
    
    var urlString : String {
        return "https://s3.amazonaws.com/ac3.2-elements/\(symbol).png"
    }
}

