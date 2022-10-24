//
//  ServerConcreteErrorDto.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 19.09.2022.
//

struct ServerConcreteErrorDto: Decodable {
    let detail: String
    let status: Int
    let title: String
    let type: String
}
