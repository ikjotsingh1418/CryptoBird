//
//  BookDetailViewController.swift
//  CryptoBird
//
//  Created by ikjot on 5/30/19.
//  Copyright © 2019 Event_Boosters. All rights reserved.
//

import UIKit

protocol BookDetailViewDelegate {
    func reloadTableViewForPresentData(bookDetailVM : BookDetailViewModel)
    func startLoading()
    func stopLoading()
    func reloadViewForNoDataPresent()
}

class BookDetailViewController: UIViewController {
    
    var mytimer : Timer!
    
    @IBOutlet weak var loadingView: UIStackView!
    @IBOutlet weak var headingStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    var viewModel : BooksListViewModel?
    var bookName : String?
    
    var bookDetailModel : BookDetailViewModel?
    
    var bookDetailTVArray : [[String : String?]]?
    
    @IBOutlet weak var lblBookLastPrice: UILabel!
    @IBOutlet weak var lblBookName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headingStackView.isHidden = true
        tableView.isHidden = true
        self.tableView.tableFooterView = UIView()
        
        if let str = bookName {
            viewModel?.loadBookDetailViewFor(bookName: str, bookDetailView: self)
            self.navigationItem.title = bookName?.uppercased()
        }else{
            print("BookDetailViewController : no book name entered")
        }
        mytimer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(refreshEvery30Secs), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    @objc func refreshEvery30Secs(){
        viewModel?.loadBookDetailViewFor(bookName: bookName ?? "", bookDetailView: self)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension BookDetailViewController : BookDetailViewDelegate {
    func reloadTableViewForPresentData(bookDetailVM: BookDetailViewModel) {
        DispatchQueue.main.async {
            self.lblBookName.text = bookDetailVM.name?.uppercased()
            self.lblBookLastPrice.text = bookDetailVM.last
            self.bookDetailTVArray = bookDetailVM.detailTVArray
            self.tableView.reloadData()
        }
        
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            self.tableView.isHidden = true
            self.headingStackView.isHidden = true
            self.loadingView.isHidden = false
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.headingStackView.isHidden = false
            self.loadingView.isHidden = true
        }
    }
    
    func reloadViewForNoDataPresent() {
        self.tableView.isHidden = true
        self.headingStackView.isHidden = true
        self.loadingView.isHidden = true
    }
    
    
}



extension BookDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookDetailTVArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        if let val = bookDetailTVArray?[indexPath.row]{
            cell.textLabel?.text =  val.first?.key.uppercased()
            cell.detailTextLabel?.text = val.first?.value
        }
        
        return cell
        
    }
}
