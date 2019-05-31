//
//  ViewController.swift
//  CryptoBird
//
//  Created by ikjot on 5/30/19.
//  Copyright © 2019 Event_Boosters. All rights reserved.
//

import UIKit

protocol BooksViewDelegate {
    func reloadTableViewForPresentData()
    func startLoading()
    func stopLoading()
    func reloadViewForNoDataPresent()
}


class ViewController: UIViewController {
    
    var loadedOnce : Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loadingView: UIStackView!
    
    //var booksViewModel = BooksListViewModel()
    var viewModel : BooksListViewModel?
    var mytimer : Timer!
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isHidden = true
        viewModel = BooksListViewModel(view: self)
        viewModel?.loadAllAvailableBooks()
        loadedOnce = true
        mytimer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(refreshEvery30Secs), userInfo: nil, repeats: true)
        self.navigationItem.title = "COINS"
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        if loadedOnce {viewModel?.loadAllAvailableBooks()}
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailView", segue.destination is BookDetailViewController {
            let bookDetailVC : BookDetailViewController = segue.destination as! BookDetailViewController
            bookDetailVC.viewModel = self.viewModel
            if let cell = sender as? UITableViewCell{
                let book = viewModel?.booksViewModels[cell.tag]
                bookDetailVC.bookName = book?.bookID
            }
        }
    }
    
    @objc func refreshEvery30Secs(){
        if loadedOnce {viewModel?.loadAllAvailableBooks()}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if loadedOnce {viewModel?.loadAllAvailableBooks()}
    }
}


extension ViewController : BooksViewDelegate {
    func reloadTableViewForPresentData() {
        self.tableView .reloadData()
        refreshControl.endRefreshing()
    }
    
    func startLoading() {
        if !loadedOnce {
            self.tableView.isHidden = true
            self.loadingView.isHidden = false
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.loadingView.isHidden = true
        }
    }
    
    func reloadViewForNoDataPresent() {
        self.tableView.isHidden = true
        self.loadingView.isHidden = true
    }
    
    
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = viewModel?.booksViewModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = book?.bookName?.uppercased()
        cell.detailTextLabel?.text = book?.lastPrice
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.booksViewModels.count ?? 0
    }
}






