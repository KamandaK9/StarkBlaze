//
//  CharactersViewController.swift
//  StarkBlaze
//
//  Created by Daniel Senga on 2023/06/18.
//

import UIKit
import Combine

class CharactersViewController: UIViewController {
    @IBOutlet weak var characterTableView: UITableView!
    let charVM = CharacterTabViewModel()
    var charList: [CharactersModel] = []
    private var cancellable: Set<AnyCancellable> = []
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    private var isLoadingNextPage = false
    
    private var currentPage = 1
    private let pageSize = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        bindChar()
        setupSearchBar()
        self.title = "Characters 🦸🏻‍♀️"
        navigationController?.navigationBar.prefersLargeTitles = true
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        characterTableView.refreshControl = refreshControl

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindChar()
    }
    
    
    // Binding viewModel data to the view table. the refresh control is also added here for when the user pulls to refresh
    private func bindChar() {
        self.charVM.fetchAllCharacters(page: currentPage, pageSize: pageSize)
        
        charVM.$characters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] char in
                let filteredAndSortedChar = char.filter { !$0.name.isEmpty && !$0.culture.isEmpty && !$0.born.isEmpty && !$0.gender.isEmpty }.sorted { $0.name < $1.name }
                self?.charList.append(contentsOf: filteredAndSortedChar)
                self?.characterTableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
            .store(in: &cancellable)
    }


    
    // Refresh the table, pull down
    @objc private func refreshData() {
        currentPage = 1
        charVM.fetchAllCharacters(page: currentPage, pageSize: pageSize)
    }
    
    private func fetchNextPage() {
        currentPage += 1
        charVM.fetchAllCharacters(page: currentPage, pageSize: pageSize)
    }
    
    

}

extension CharactersViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        charList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "charCell") as! CharViewCell
        cell.configureCell(with: charList[indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = Helper.shared.generateRandomColor()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    private func setUpTable() {
        characterTableView.delegate = self
        characterTableView.dataSource = self
        characterTableView.separatorStyle = .none
        characterTableView.register(UINib(nibName: "CharViewCell", bundle: .main), forCellReuseIdentifier: "charCell")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let offsetY = scrollView.contentOffset.y
           let contentHeight = scrollView.contentSize.height
           let visibleHeight = scrollView.bounds.height
           
           if offsetY > contentHeight - visibleHeight, !isLoadingNextPage {
               isLoadingNextPage = true
               DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                   self?.fetchNextPage()
                   self?.isLoadingNextPage = false
               }
           }
       }
    
    
    
    // MARK: Searchbar
    
    private func searchCharacter(with searchText: String) {
        // Fetch character names only when search button is pressed
        if searchController.searchBar.isFirstResponder {
            charList.removeAll()
            charVM.fetchCharacterName(searchText)
        }
    }

  
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Characters"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        
        searchCharacter(with: searchText)
        
        characterTableView.reloadData()
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
