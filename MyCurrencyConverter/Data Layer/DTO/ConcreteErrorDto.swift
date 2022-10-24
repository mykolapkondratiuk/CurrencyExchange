//
//  ConcreteErrorDto.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 19.09.2022.
//

struct ConcreteErrorDto: Decodable {
    var info: String
    var code: Int
    var message: String
}
