//
//  ImageTableViewCell.swift
//  image-generator
//
//  Created by Alexey Zubkov on 29.05.2023.
//

import UIKit

final class ImageTableViewCell: TableViewCell {

    // MARK: UI

    private lazy var configuredImageView = makeImageView()
    private lazy var favoriteButton = makeFavoriteButton()
    private lazy var configuredLabel = makeConfiguredLabel()

    // MARK: State

    private var favoriteButtonAction: ((Bool) -> Void)?
    private var isSaved: Bool = false {
        didSet {
            changeFavoriteButtonImage()
        }
    }

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
        configuredImageView.image = UIImage(data: model.imageData)
        favoriteButtonAction = model.favoriteButtonAction
        isSaved = model.isSaved
        configuredLabel.text = model.requestBaseUrl
    }
}

// MARK: - UI methods

private extension ImageTableViewCell {

    func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    func setupLayout() {
        contentView.addSubview(configuredImageView)
        contentView.addSubview(configuredLabel)
        configuredImageView.addSubview(favoriteButton)

        NSLayoutConstraint.activate([
            configuredImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.horizontalOffset
            ),
            configuredImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.horizontalOffset
            ),
            configuredImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.imageTopOffset
            ),
            configuredImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: Constants.imageBottomInset
            ),
            configuredImageView.heightAnchor.constraint(
                equalToConstant: Constants.imageViewHeight
            ),

            configuredLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.horizontalOffset
            ),
            configuredLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.horizontalOffset
            ),
            configuredLabel.topAnchor.constraint(
                equalTo: configuredImageView.bottomAnchor,
                constant: Constants.labelTopOffset
            ),

            favoriteButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize),
            favoriteButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            favoriteButton.centerYAnchor.constraint(equalTo: configuredImageView.topAnchor, constant: Constants.buttonSize / 1.5),
            favoriteButton.leadingAnchor.constraint(equalTo: configuredImageView.leadingAnchor, constant: Constants.buttonSize / 6)
        ])
    }
}

// MARK: - Factory methods

private extension ImageTableViewCell {

    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .whiteBackground
        imageView.layer.cornerRadius = Constants.imageViewCornerRadius
        imageView.isUserInteractionEnabled = true
        return imageView.makeForLayout()
    }

    func makeFavoriteButton() -> UIButton {
        let button = UIButton(type: .system)
        button.contentMode = .scaleAspectFit
        button.tintColor = .goldColor
        button.backgroundColor = .clear
        return button.makeForLayout()
    }

    func makeConfiguredLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .textColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label.makeForLayout()
    }
}

// MARK: - Actions

private extension ImageTableViewCell {

    func setupActions() {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonDidTap), for: .touchUpInside)
    }

    func changeFavoriteButtonImage() {
        UIView.transition(
            with: self.favoriteButton,
            duration: 0.2,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                self?.favoriteButton.setImage(
                    self?.isSaved ?? false ? UIImage(named: "star_filled@44") : UIImage(named: "star@44"),
                    for: .normal
                )
            }, completion: nil
        )
    }

    @objc
    func favoriteButtonDidTap() {
        isSaved.toggle()
        favoriteButtonAction?(isSaved)
    }
}

// MARK: - Model

extension ImageTableViewCell {

    struct Model: TableCellModel {
        let uuid: UUID
        let reuseId: String = String(describing: ImageTableViewCell.self)
        let imageData: Data
        var isSaved: Bool
        let requestBaseUrl: String
        let favoriteButtonAction: (Bool) -> Void
    }
}

// MARK: - Constants

private extension ImageTableViewCell {

    enum Constants {
        static let buttonSize: CGFloat = 44

        static let horizontalOffset: CGFloat = 16
        static let imageTopOffset: CGFloat = 8
        static let imageBottomInset: CGFloat = -52

        static let imageViewCornerRadius: CGFloat = 16
        static let imageViewHeight: CGFloat = 350

        static let labelHeight: CGFloat = 44
        static let labelTopOffset: CGFloat = 10
        static let labelBottomInset: CGFloat = -8
    }
}
