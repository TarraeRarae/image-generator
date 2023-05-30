//
//  MainButtonTableViewCell.swift
//  image-generator
//
//  Created by Alexey Zubkov on 29.05.2023.
//

import UIKit

final class MainButtonTableViewCell: TableViewCell {

    // MARK: UI

    private lazy var button = makeButton()

    // MARK: State

    private var buttonAction: (() -> Void)?

    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
        setupActions()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ConfigurableItem

    override func configure(_ params: Any) {
        guard let model = params as? Model else {
            return
        }
        button.setTitle(model.buttonTitle, for: .normal)
        buttonAction = model.buttonAction
    }
}

// MARK: - UI methods

private extension MainButtonTableViewCell {

    func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    func setupLayout() {
        contentView.addSubview(button)

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.horizontalOffset
            ),
            button.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.horizontalOffset
            ),
            button.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.verticalOffset
            ),
            button.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Constants.verticalOffset
            ),
            button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
}

// MARK: - Factory methods

private extension MainButtonTableViewCell {

    func makeButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(.buttonTextColor, for: .normal)
        button.backgroundColor = .buttonBackgroundColor
        button.layer.cornerRadius = Constants.cornerRadius
        return button.makeForLayout()
    }
}

// MARK: - Actions

private extension MainButtonTableViewCell {

    func setupActions() {
        button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }

    @objc
    func buttonDidTap() {
        buttonAction?()
    }
}

// MARK: - Model

extension MainButtonTableViewCell {

    struct Model: TableCellModel {
        let uuid: UUID = UUID()
        let reuseId = String(describing: MainButtonTableViewCell.self)
        let buttonTitle: String
        let buttonAction: () -> Void
    }
}

// MARK: - Constants

private extension MainButtonTableViewCell {

    enum Constants {
        static let cornerRadius: CGFloat = 16
        static let horizontalOffset: CGFloat = 16
        static let verticalOffset: CGFloat = 5
        static let buttonHeight: CGFloat = 44
    }
}
