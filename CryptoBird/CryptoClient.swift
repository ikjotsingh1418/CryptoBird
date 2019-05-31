//
//  CryptoClient.swift
//  CryptoBird
//
//  Created by Cubastion on 5/30/19.
//  Copyright © 2019 Event_Boosters. All rights reserved.
//

import UIKit

class CryptoClient: NSObject {
    
    static let sharedInstance = CryptoClient()
    
    func getAllAvailableBooksData(completion: @escaping([BooksAvailableDataModel]?,Error?) -> ()) {
        
        let urlAvailableBooks = "https://api.bitso.com/v3/available_books/"
        let urlTicker = "https://api.bitso.com/v3/ticker/"
        
        guard  let url = URL(string: urlAvailableBooks) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error{
                completion(nil,err)
                print("Error in loading Data : \(err.localizedDescription)")
            }else{
                guard let data =  data else {
                    return
                }
                do{
                    let results = try JSONDecoder().decode(ResultsModel.self, from: data)
                    print(results)
                    let myGroup = DispatchGroup()
                    for book in results.availableBooks{
                        myGroup.enter()
                        let urlComp = NSURLComponents(string: urlTicker)!
                        var items = [URLQueryItem]()
                        items.append(URLQueryItem(name: "book", value: book.bookName))
                        
                        items = items.filter{!$0.name.isEmpty}
                        
                        if !items.isEmpty {
                            urlComp.queryItems = items
                        }
                        
                        var urlRequest = URLRequest(url: urlComp.url!)
                        urlRequest.httpMethod = "GET"
                        let config = URLSessionConfiguration.default
                        let session = URLSession(configuration: config)
                        
                        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                            if(data) != nil{
                                do{
                                    let lastValue = try JSONDecoder().decode(TickerDataModel.self, from:data!)
                                    
                                    book.lastPrice =   lastValue.tickerBook.lastPrice
                                    print("Finished request \(String(describing: book.bookName))")
                                }catch let tJSONError{
                                    completion(nil,tJSONError)
                                    print ("ticker json error for \(String(describing: book.bookName)) : \(tJSONError.localizedDescription)")
                                }
                            }else{ completion(nil,error)
                                print ("Server is not responding with error : \(String(describing: error))")
                            }
                            myGroup.leave()
                        })
                        task.resume()
                    }
                    myGroup.notify(queue: .main) {
                        print("Finished all requests.")
                        completion(results.availableBooks, error)
                    }
                    
                }catch let jsonErr{
                    completion(nil,jsonErr)
                    print ("Available Books json error : \(jsonErr.localizedDescription)")
                }
            }
            }.resume()
    }
    
    
    func getBookDetailForBookName(bookName : String, completion:@escaping(BooksTickerDataModel?,Error?) -> ()){
        let urlTicker = "https://api.bitso.com/v3/ticker/"
        
        let urlComp = NSURLComponents(string: urlTicker)!
        var items = [URLQueryItem]()
        items.append(URLQueryItem(name: "book", value:bookName))
        
        items = items.filter{!$0.name.isEmpty}
        
        if !items.isEmpty {
            urlComp.queryItems = items
        }
        
        var urlRequest = URLRequest(url: urlComp.url!)
        urlRequest.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if(data) != nil{
                do{
                    let lastValue = try JSONDecoder().decode(TickerDataModel.self, from: data!)
                    
                    completion(lastValue.tickerBook,error)
                    print("Fetched detail of book \(String(describing: lastValue.tickerBook.bookName))")
                }catch let tJSONError{
                    completion(nil,tJSONError)
                    print ("ticker json error for : \(tJSONError.localizedDescription)")
                }
            }else{ completion(nil,error)
                print ("Server is not responding with error : \(String(describing: error))")
            }
        })
        task.resume()
    }
}
