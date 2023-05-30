//
//  TextFieldTableViewCell.swift
//  image-generator
//
//  Created by Alexey Zubkov on 29.05.2023.
//

import UIKit

final class TextFieldTableViewCell: TableViewCell {

    // MARK: UI

    private lazy var textField = makeTextField()

    // MARK: State

    private var inputAction: ((String) -> Void)?

    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
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
        textField.text = model.textFieldText
        inputAction = model.inputAction
    }
}

// MARK: - UI methods

private extension TextFieldTableViewCell {

    func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    func setupLayout() {
        contentView.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.horizontalOffset
            ),
            textField.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.horizontalOffset
            ),
            textField.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.verticalOffset
            ),
            textField.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Constants.verticalOffset
            ),
            textField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight)
        ])
    }
}

// MARK: - Factory methods

private extension TextFieldTableViewCell {

    func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.textColor = .textColor
        textField.backgroundColor = .whiteBackground
        textField.layer.borderColor = UIColor.borderColor.cgColor
        textField.layer.borderWidth = Constants.borderWidth
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.leftView = UIView(frame: Constants.textFieldSideViewFrame)
        textField.rightView = UIView(frame: Constants.textFieldSideViewFrame)
        textField.delegate = self
        return textField.makeForLayout()
    }
}

// MARK: - UITextFieldDelegate

extension TextFieldTableViewCell: UITextFieldDelegate {

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        inputAction?(newString)
        return true
    }
}

// MARK: - Model

extension TextFieldTableViewCell {

    struct Model: TableCellModel {
        let uuid: UUID = UUID()
        let reuseId = String(describing: TextFieldTableViewCell.self)
        let textFieldText: String
        let inputAction: (String) -> Void

        init(
            textFieldText: String = "",
            inputAction: @escaping (String) -> Void
        ) {
            self.textFieldText = textFieldText
            self.inputAction = inputAction
        }
    }
}

// MARK: - Constants

private extension TextFieldTableViewCell {

    enum Constants {
        static let textFieldSideViewFrame: CGRect = CGRect(x: 0, y: 0, width: 7, height: 1)
        static let textFieldHeight: CGFloat = 55
        static let borderWidth: CGFloat = 1.5
        static let cornerRadius: CGFloat = 16
        static let horizontalOffset: CGFloat = 16
        static let verticalOffset: CGFloat = 10
    }
}
