//
//  HousesViewController.swift
//  StarkBlaze
//
//  Created by Daniel Senga on 2023/06/18.
//

import UIKit
import Combine

class HousesViewController: UIViewController {
    @IBOutlet weak var housesTableView: UITableView!
    let houseVM = HousesTabViewModel()
    var houseList: [HousesModel] = []
    private var cancellable: Set<AnyCancellable> = []
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    private var isLoadingNextPage = false
    
    private var currentPage = 1
    private let pageSize = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        bindHouse()
        setupSearchBar()
        self.title = "Houses 🏘"
        navigationController?.navigationBar.prefersLargeTitles = true
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        housesTableView.refreshControl = refreshControl

    }
    
    
    // Network call to viewModel and usage of combine to bind data to the table view
    private func bindHouse() {
        self.houseVM.fetchAllHouses(page: currentPage, pageSize: pageSize)
        
        houseVM.$houses
            .receive(on: DispatchQueue.main)
            .sink { [weak self] house in
                let sortedHouses = house.sorted { $0.name < $1.name }
                self?.houseList.append(contentsOf: sortedHouses)
                self?.housesTableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
            .store(in: &cancellable)
    }
    
    // load next page, adds one to the Api call query to load next set of data. page size to grasp size
    private func fetchNextPage() {
        currentPage += 1
        self.houseVM.fetchAllHouses(page: currentPage, pageSize: pageSize)
    }
    
    // Refresh the table, pull down
    @objc private func refreshData() {
        currentPage = 1
        houseVM.fetchAllHouses(page: currentPage, pageSize: pageSize)
    }

}


// Extension is used to seperate setting up of tableview and searchbar
extension HousesViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    
    // MARK: TableView Functions - Height, Cell set up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        houseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "houseCell") as! HousesCell
        cell.configureCell(with: houseList[indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = Helper.shared.generateRandomColor()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    private func setUpTable() {
        housesTableView.delegate = self
        housesTableView.dataSource = self
        housesTableView.separatorStyle = .none
        housesTableView.register(UINib(nibName: "HousesCell", bundle: .main), forCellReuseIdentifier: "houseCell")
    }
    
    // When the scroll view reaches the bottom and the isLoading is not false, wait 1 second. Load next
    // This is because the tableview will load all the data quickly whilst it reaches the bottom. The delay
    // gives the API time to be called and load
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
    
    // When search bar is active. Remove houselist elements and call API search using text
    private func searchCharacter(with searchText: String) {
        // Fetch character names only when search button is pressed
        if searchController.searchBar.isFirstResponder {
            houseList.removeAll()
            houseVM.fetchByHouse(searchText)
            housesTableView.reloadData()
        }
    }

  
    // Searchbar set up
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Houses"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    
    //
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        
        searchCharacter(with: searchText)
        

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
