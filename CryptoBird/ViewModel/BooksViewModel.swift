//
//  BooksViewModel.swift
//  CryptoBird
//
//  Created by ikjot on 5/30/19.
//  Copyright © 2019 Event_Boosters. All rights reserved.
//

import UIKit

class BooksListViewModel : NSObject {
    
    let cryptoClient = CryptoClient.sharedInstance
    
    var booksViewModels : [BooksViewModel] = [BooksViewModel]()
    var booksView : ViewController
    
    init(view : ViewController){
        self.booksView = view
        view.startLoading()
    }
    
    func loadAllAvailableBooks() {
        cryptoClient.getAllAvailableBooksData { (availableBooksList, error) in
            var booksList = [BooksViewModel]()
            if let avBook = availableBooksList {
                if(avBook.count>0){
                    avBook.forEach({ (book) in
                        booksList.append(BooksViewModel(availableBooksModel: book))
                        
                    })
                    booksList.sort(by: { (first, second) -> Bool in
                        if let str1 = first.bookName?.suffix(3), let str2 = second.bookName?.suffix(3){
                            return str1 > str2
                        }
                        return true
                    })
                    self.booksViewModels = booksList
                    self.booksView.reloadTableViewForPresentData()
                    self.booksView.stopLoading()
                    
                    
                }else{
                    self.booksView.reloadTableViewForPresentData()
                    self.booksView.stopLoading()
                }
                
            }
        }
    }
    
    func loadBookDetailViewFor(bookName : String, bookDetailView : BookDetailViewController) {
        bookDetailView.startLoading()
        cryptoClient.getBookDetailForBookName(bookName: bookName) { (bookDetailModel, error) in
            bookDetailView.stopLoading()
            if let BDM = bookDetailModel {
                let populatedDetailBook = BookDetailViewModel(tickerBookModel: BDM)
                bookDetailView.reloadTableViewForPresentData(bookDetailVM: populatedDetailBook)
                
                // load view with detail model
            }else{
                // error no detail data found
            }
        }
    }
}

class BooksViewModel: NSObject {
    var bookName : String?
    var lastPrice : String?
    var bookID : String?
    
    init (availableBooksModel:BooksAvailableDataModel){
        self.bookID = availableBooksModel.bookName
        if let lastThree = availableBooksModel.bookName?.suffix(3){
            if lastThree == "btc"{
                self.lastPrice = (availableBooksModel.lastPrice ?? "0.00") + " BTC"
            }else{
                self.lastPrice = "$"+(availableBooksModel.lastPrice ?? "0.00") + " MXN"
            }
        }else{
            //self.bookName = availableBooksModel.bookName
            self.lastPrice = availableBooksModel.lastPrice
        }
        
        self.bookName = availableBooksModel.bookName?.replacingOccurrences(of: "_", with: "/")
    }
}


class BookDetailViewModel: NSObject {
    var name : String?
    var last : String?
    var bid : String?
    var ask : String?
    var low : String?
    var high : String?
    var volume : String?
    var spread : String
    var detailTVArray : [[String : String?]]? = []
    
    init (tickerBookModel:BooksTickerDataModel){
        self.name = tickerBookModel.bookName
        self.last = tickerBookModel.lastPrice
        self.bid = tickerBookModel.bidValue
        self.ask = tickerBookModel.AskValue
        self.high = tickerBookModel.highPrice
        self.low = tickerBookModel.lowPrice
        self.volume = tickerBookModel.volume
        self.spread = "0.00"
        
        var str : String = "%.2f"
        if let suff = self.name?.suffix(3) {
            str =  suff == "btc" ?  "%.8f" : "%.2f"
        }
        if self.bid != "",self.ask != ""
        {
            self.spread = String(format: str, fabs((self.bid! as NSString).doubleValue - (self.ask! as NSString).doubleValue))
        }
        detailTVArray?.append(["Bid" : self.bid])
        detailTVArray?.append(["ask" : self.ask])
        detailTVArray?.append(["high" : self.high])
        detailTVArray?.append(["low" : self.low])
        detailTVArray?.append(["volume" : self.volume])
        detailTVArray?.append(["spread" : String(self.spread)])
    }
}






