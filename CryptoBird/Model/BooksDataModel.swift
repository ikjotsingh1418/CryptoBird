//
//  BooksDataModel.swift
//  CryptoBird
//
//  Created by ikjot on 5/30/19.
//  Copyright © 2019 Event_Boosters. All rights reserved.
//

import Foundation

class BooksAvailableDataModel : Codable {
    var bookName : String?
    var lastPrice : String?
    
    private enum CodingKeys: String, CodingKey {
        case bookName = "book"
        
    }
    init (bookName:String){
        self.bookName = bookName
    }
    
}

class BooksTickerDataModel : Codable {
    var bookName : String?
    var bidValue : String?
    var AskValue : String?
    var lastPrice : String?
    var lowPrice : String?
    var highPrice : String?
    var volume : String?
    
    private enum CodingKeys: String, CodingKey {
        case bookName = "book"
        case bidValue = "bid"
        case AskValue = "ask"
        case lastPrice = "last"
        case lowPrice = "low"
        case highPrice = "high"
        case volume

        
    }
    
    init (bookName : String, bidValue : String,AskValue : String,lastPrice : String,lowPrice : String,highPrice : String,volume : String){
        self.bookName = bookName
        self.bidValue = bidValue
        self.AskValue = AskValue
        self.lastPrice = lastPrice
        self.lowPrice = lowPrice
        self.highPrice = highPrice
        self.volume = volume
        
    }
}

class ResultsModel : Codable {
    var availableBooks = [BooksAvailableDataModel]()
 
    private enum CodingKeys: String, CodingKey {
        case availableBooks = "payload"
   
    }
    init (availableBooks: [BooksAvailableDataModel] ){
        self.availableBooks = availableBooks
    }
}

class TickerDataModel : Codable {
    var tickerBook : BooksTickerDataModel
    
    private enum CodingKeys: String, CodingKey {
        case tickerBook = "payload"
        
    }
    init (tickerBook: BooksTickerDataModel ){
        self.tickerBook = tickerBook
    }
}
