//
//  FavoriteImagesViewController.swift
//  image-generator
//
//  Created by Alexey Zubkov on 30.05.2023.
//

import UIKit

protocol IFavoriteImagesView: AnyObject {
    func configure(with cellModels: [TableCellModel])
    func showCommonErrorAlert(title: String, message: String?)
    func deleteData(with uuid: UUID)
}

class FavoriteImagesViewController: UIViewController {

    typealias CustomView = FavoriteImagesView

    // MARK: Dependencies

    private let presenter: IFavoriteImagesPresenter

    // MARK: UI

    private lazy var customView = CustomView()

    // MARK: State

    private lazy var cellModels: [TableCellModel] = [TableCellModel]()

    // MARK: Lifecycle

    init(presenter: IFavoriteImagesPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.updateContent()
    }
}

// MARK: - IFavoriteImagesView

extension FavoriteImagesViewController: IFavoriteImagesView {

    func configure(with cellModels: [TableCellModel]) {
        self.cellModels = cellModels
        customView.tableView.reloadData()
    }

    func deleteData(with uuid: UUID) {
        var indexPath = IndexPath(row: 0, section: 0)
        for index in 0..<cellModels.count {
            if cellModels[index].uuid == uuid {
                cellModels.remove(at: index)
                indexPath.row = index
                break
            }
        }
        customView.tableView.deleteRows(at: [indexPath], with: .fade)
    }

    func showCommonErrorAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.okTitle, style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - Setup UI

private extension FavoriteImagesViewController {

    func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }

    func setupTableView() {
        customView.tableView.register(
            ImageTableViewCell.self,
            forCellReuseIdentifier: ImageTableViewCell.reuseId
        )
        customView.tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource

extension FavoriteImagesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = cellModels[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: model.reuseId) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.configure(model)
        return cell
    }
}

// MARK: - Constants

private extension FavoriteImagesViewController {

    enum Constants {
        static let okTitle = "OK"
    }
}
