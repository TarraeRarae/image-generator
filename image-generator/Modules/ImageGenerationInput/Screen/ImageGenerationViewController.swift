//
//  ImageGenerationViewController.swift
//  image-generator
//
//  Created by Alexey Zubkov on 29.05.2023.
//

import UIKit

protocol IImageGenerationView: AnyObject {
    func configure(with cellModels: [TableCellModel])
    func insertData(models: [IndexPath: TableCellModel])
    func showCommonErrorAlert(title: String, message: String?)
    func updateCellModel(with model: TableCellModel)
}

class ImageGenerationViewController: UIViewController {

    typealias CustomView = ImageGenerationView

    // MARK: Dependencies

    private let presenter: IImageGenerationPresenter

    // MARK: UI

    private lazy var customView = CustomView()

    // MARK: State

    private lazy var cellModels: [TableCellModel] = [TableCellModel]()

    // MARK: Lifecycle

    init(presenter: IImageGenerationPresenter) {
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
        setupTableView()
        setupNavigationBar()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.updateData(cellModels: cellModels)
    }
}

// MARK: - IImageGenerationView

extension ImageGenerationViewController: IImageGenerationView {

    func configure(with cellModels: [TableCellModel]) {
        self.cellModels = cellModels
        customView.tableView.reloadData()
    }

    func insertData(models: [IndexPath: TableCellModel]) {
        var indexPathes = [IndexPath]()
        for (indexPath, model) in models {
            if indexPath.row > cellModels.count {
                continue
            }
            cellModels.insert(model, at: indexPath.row)
            indexPathes.append(indexPath)
        }
        customView.tableView.insertRows(at: indexPathes, with: .fade)
    }

    func updateCellModel(with model: TableCellModel) {
        for index in 0..<cellModels.count {
            if cellModels[index].uuid == model.uuid {
                cellModels[index] = model
                return
            }
        }
    }

    func showCommonErrorAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.okTitle, style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - Setup UI

private extension ImageGenerationViewController {

    func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }

    func setupTableView() {
        customView.tableView.register(
            MainButtonTableViewCell.self,
            forCellReuseIdentifier: MainButtonTableViewCell.reuseId
        )
        customView.tableView.register(
            TextFieldTableViewCell.self,
            forCellReuseIdentifier: TextFieldTableViewCell.reuseId
        )
        customView.tableView.register(
            ImageTableViewCell.self,
            forCellReuseIdentifier: ImageTableViewCell.reuseId
        )
        customView.tableView.dataSource = self
        customView.tableView.delegate = self
        customView.tableView.keyboardDismissMode = .onDrag
    }
}

// MARK: - UITableViewDataSource

extension ImageGenerationViewController: UITableViewDataSource {

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

// MARK: - UITableViewDelegate

extension ImageGenerationViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - Constants

private extension ImageGenerationViewController {

    enum Constants {
        static let okTitle = "OK"
    }
}
