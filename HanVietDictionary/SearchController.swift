//
//  SearchController.swift
//  HanVietDictionary
//
//  Created by Alex Do on 6/5/26.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setupViews() {}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ResultCell: CustomTableViewCell {
    static let identifier = "ResultCell"
    let label: UILabel = {
        let l = UILabel()
        l.text = "Hello"
        return l
    }()

    override func setupViews() {
        super.setupViews()

        contentView.addSubview(label)
        addConstraintsWithFormat(format: "H:|-10-[v0(370)]-10-|", views: label)
        addConstraintsWithFormat(format: "V:|-13-[v0(24)]-13-|", views: label)
    }
}

class SearchController: ContentViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    var characterResults: [String]?

    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemGray
        tv.dataSource = self
        tv.delegate = self
        tv.frame = view.bounds
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        navigationItem.preferredSearchBarPlacement = .stacked // place search bar at top
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a character (tìm kiếm Hán Tự)"
        searchController.searchBar.showsCancelButton = false
        searchController.obscuresBackgroundDuringPresentation = false

        // search bar appearance
        searchController.searchBar.setImage(UIImage(), for: .search, state: .normal) // remove the search icon
        searchController.searchBar.barStyle = .black
        
        // table view
        tableView.register(ResultCell.self, forCellReuseIdentifier: ResultCell.identifier)
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resultCell = tableView.dequeueReusableCell(withIdentifier: ResultCell.identifier, for: indexPath) as! ResultCell
        return resultCell
    }
}
