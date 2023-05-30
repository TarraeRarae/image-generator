//
//  ImageGenerationView.swift
//  image-generator
//
//  Created by Alexey Zubkov on 29.05.2023.
//

import UIKit

final class ImageGenerationView: UIView {

    // MARK: UI

    private(set) lazy var tableView = makeTableView()

    // MARK: Lifecycle

    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI methods

private extension ImageGenerationView {

    func setupUI() {
        backgroundColor = .defaultBackground
    }

    func setupLayout() {
        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - Factory methods

private extension ImageGenerationView {

    func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView.makeForLayout()
    }
}
