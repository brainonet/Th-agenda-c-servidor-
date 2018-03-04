//
//  Cont.swift
//  agenda_CoreData
//
//  Created by Mauro Silva on 28/02/2018.
//  Copyright © 2018 Brains On Networks. All rights reserved.
//

import Foundation

struct Cont: Decodable, Encodable {
    let id: Int
    let nome: String
    let apelido: String
    let contacto: Int
}
