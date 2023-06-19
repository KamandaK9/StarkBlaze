//
//  BooksViewController.swift
//  StarkBlaze
//
//  Created by Daniel Senga on 2023/06/18.
//

import UIKit
import Combine


class BooksViewController: UIViewController {

    @IBOutlet weak var booksTableView: UITableView!
    let booksVM = BookTabViewModel()
    var bookList: [BookModel] = []
    private var cancellables: Set<AnyCancellable> = []
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var currentPage = 1
    private let pageSize = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        bindBooks()
        setupSearchBar()
        self.title = "Books 📔"
        navigationController?.navigationBar.prefersLargeTitles = true
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        booksTableView.refreshControl = refreshControl
    }
    
    // Books API Call as well as insertion of data into the tableView
    // Sorted in alphabetical order
    private func bindBooks() {
        self.booksVM.fetchAllBooks(page: currentPage, pageSize: pageSize)
        
        booksVM.$books
            .receive(on: DispatchQueue.main)
            .sink { [weak self] books in
                let sortedBooks = books.sorted { $0.name < $1.name }
                self?.bookList.append(contentsOf: sortedBooks)
                self?.booksTableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)
    }

    

    // Fetch the next page through viewModel. Currentpage is inscreased when called
    private func fetchNextPage() {
        currentPage += 1
        booksVM.fetchAllBooks(page: currentPage, pageSize: pageSize)
        
        
    }
    
    // Refresh the table, pull down
    @objc private func refreshData() {
        currentPage = 1
        booksVM.fetchAllBooks(page: currentPage, pageSize: pageSize)
    }
    
}


extension BooksViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    // TableView functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell") as! BookTableViewCell
        cell.configureCell(with: bookList[indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = Helper.shared.generateRandomColor()
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    
    // Setting up tableView options
    private func setUpTable() {
        booksTableView.delegate = self
        booksTableView.dataSource = self
        booksTableView.separatorStyle = .none
        booksTableView.register(UINib(nibName: "BookTableViewCell", bundle: .main), forCellReuseIdentifier: "bookCell")
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIdnex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIdnex {
            fetchNextPage()
        }
    }
    
    
    
    // MARK: Searchbar
    
    private func searchBook(with searchText: String) {
        if searchController.searchBar.isFirstResponder {
            bookList.removeAll() // Clear the existing book list
            booksVM.fetchBooksByName(searchText)
        }
    }

    
    // Searchbar iniliazation and setup
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Books"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        searchBook(with: searchText)
        
        booksTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Clear the search text and reload the table view with the original data
        searchController.searchBar.text = nil
        updateSearchResults(for: searchController)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = false
    }




}
