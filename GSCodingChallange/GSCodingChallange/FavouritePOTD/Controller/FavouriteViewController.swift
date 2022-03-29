//
//  FavouriteViewController.swift
//  GSCodingChallange
//
//  Created by Jignesh Gajjar on 29/03/22.
//

import UIKit

class FavouriteViewController: UIViewController, FavouriteViewEntity {

    let viewModel: FavouriteViewModel
    
    var favouritesPOTD: [POTDFavorite]? {
        didSet {
            favouriteTableView.reloadData()
        }
    }
    
    init(viewModel: FavouriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let favouriteTableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
       return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(favouriteTableView)
        favouriteTableView.frame = view.bounds
        favouriteTableView.dataSource = self
        favouriteTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        loadFavouritePOTD()
    }
    
    private func loadFavouritePOTD() {
        viewModel.loadFavouritesPOTD()
    }
    
    func showFavouritesPOTD(favourites: [POTDFavorite]) {
        favouritesPOTD = favourites
    }
}

extension FavouriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favouritesPOTD?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MyCell")
        cell.textLabel?.text = favouritesPOTD?[indexPath.row].date
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = favouritesPOTD?[indexPath.row].title
        return cell
    }
}
