//
//  CurrencyCollectionCell.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 16.10.2022.
//

import UIKit

final class CurrencyCollectionCell: UICollectionViewCell {

    // MARK: - Nested types

    private enum Consts {

        enum AmmountLabel {
            static let width: CGFloat = 71 // 120 - 40 - 5 - 2 -2 =
            
            static let edgeInsets: NSDirectionalEdgeInsets = .init(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 0
            )
        }

        enum CurrencyNameLabel {
            static let width: CGFloat = 40 // 3 x 16
            static let leadingOffset: CGFloat = 5
            static let edgeInsets: NSDirectionalEdgeInsets = .init(
                top: 2,
                leading: 0,
                bottom: 2,
                trailing: 2
            )
        }
    }

    private let ammountLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()

    private let currencyNameLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .natural
        label.numberOfLines = 1
        return label
    }()

    // MARK: - Initializers

    /// Designated initializer
    /// Parameters:
    /// - frame:  frame current view
    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { return nil }

    // MARK: - Life Cycle

    override func prepareForReuse() {
        super.prepareForReuse()

        ammountLabel.text = nil
        currencyNameLabel.text = nil
    }

    // MARK: - Internal methods

    /// Method for configuration this cell
    /// Parameters:
    /// - currency:  CurrencyShowType object for configure current cell
    func configure(with currency: CurrencyShowType ) {
        ammountLabel.text = currency.amountAsString
        currencyNameLabel.text = currency.name
    }

    // MARK: - Private methods

    private func setupLayout() {
        addSubview(ammountLabel)
        ammountLabel.snp.makeConstraints { make in
            make.width.equalTo(Consts.AmmountLabel.width)
            make.top.leading.bottom.equalToSuperview().inset(Consts.AmmountLabel.edgeInsets)
        }

        addSubview(currencyNameLabel)
        currencyNameLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(Consts.CurrencyNameLabel.edgeInsets)
            make.leading.equalTo(ammountLabel.snp.trailing).offset(Consts.CurrencyNameLabel.leadingOffset)
        }
    }
}
