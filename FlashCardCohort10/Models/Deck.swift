//
//  Deck.swift
//  FlashCardCohort10
//
//  Created by Robert Vinson on 8/11/26.
//

// MARK: DATA MODELING
import Foundation

struct Deck:Identifiable,Codable,Equatable{
    
    let id:UUID
    var name:String
    var card:[Flashcard]
    init(id:UUID = UUID() , name:String,card:[Flashcard]){
        self.id = id
        self.name = name
        self.card = card
        
    }
    
}
