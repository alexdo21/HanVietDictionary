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

struct UnihanEntry {
    let hanChar: String?
    let vietReading: String?
    let definition: String?
}

class UnihanResultCell: CustomTableViewCell {
    static let identifier = "UnihanResultCell"
    let hanLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    let vietReadingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    let definitionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    var unihanEntry: UnihanEntry? {
        didSet {
            hanLabel.text = unihanEntry?.hanChar
            vietReadingLabel.text = unihanEntry?.vietReading
            definitionLabel.text = unihanEntry?.definition
        }
    }

    override func setupViews() {
        super.setupViews()
        contentView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 230)
        contentView.addSubview(hanLabel)
        contentView.addSubview(vietReadingLabel)
        contentView.addSubview(definitionLabel)
        addConstraintsWithFormat(format: "H:|-5-[v0(25)]-5-[v1(350)]-5-|", views: hanLabel, vietReadingLabel)
        addConstraintsWithFormat(format: "H:|-5-[v0(380)]-5-|", views: definitionLabel)
        addConstraintsWithFormat(format: "V:|-5-[v0(25)]-[v1(25)]-5-|", views: hanLabel, definitionLabel)
        addConstraintsWithFormat(format: "V:|-5-[v0(25)]-[v1(25)]-5-|", views: vietReadingLabel, definitionLabel)
    }
}

class HanVietEntry: UIViewController {
    let hanLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 48)
        return label
    }()
    let vietReadingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 48)
        return label
    }()
    let definitionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()

    init(_ unihanEntry: UnihanEntry) {
        hanLabel.text = unihanEntry.hanChar
        vietReadingLabel.text = unihanEntry.vietReading
        definitionLabel.text = unihanEntry.definition
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 230)
        view.addSubview(hanLabel)
        view.addSubview(vietReadingLabel)
        view.addSubview(definitionLabel)
        hanLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 5))
        vietReadingLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: hanLabel.rightAnchor, bottom: nil, right: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 10))
        definitionLabel.anchor(top: hanLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, padding: .init(top: 0, left: 10, bottom: 10, right: 10))
    }
}

class SearchController: ContentViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    var unihanResult: UnihanResult?

    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 230)
        tv.dataSource = self
        tv.delegate = self
        tv.frame = view.bounds
        return tv
    }()

    private var unihanService: UnihanService?

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            let initializedUnihanService = await UnihanService()
            await MainActor.run {
                self.unihanService = initializedUnihanService
            }
        }
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
        searchController.hidesNavigationBarDuringPresentation = false

        // table view
        tableView.register(UnihanResultCell.self, forCellReuseIdentifier: UnihanResultCell.identifier)
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let unihanResult else { return 0 }
        let resultLength = max(unihanResult.hanCharList.count, unihanResult.vietReadings.count, unihanResult.definitions.count)
        return resultLength
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resultCell = tableView.dequeueReusableCell(withIdentifier: UnihanResultCell.identifier, for: indexPath) as! UnihanResultCell
        resultCell.unihanEntry = UnihanEntry(hanChar: unihanResult?.hanCharList[indexPath.row], vietReading: unihanResult?.vietReadings[indexPath.row], definition: unihanResult?.definitions[indexPath.row])
        return resultCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let unihanEntry = UnihanEntry(hanChar: unihanResult?.hanCharList[indexPath.row], vietReading: unihanResult?.vietReadings[indexPath.row], definition: unihanResult?.definitions[indexPath.row])
        self.navigationController?.pushViewController(HanVietEntry(unihanEntry), animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.unihanResult = nil
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let queryText = searchBar.text, !queryText.isEmpty else { return }
        self.unihanResult = unihanService?.getReadingsAndDefinitions(byInput: queryText)
        self.tableView.reloadData()
    }
}
