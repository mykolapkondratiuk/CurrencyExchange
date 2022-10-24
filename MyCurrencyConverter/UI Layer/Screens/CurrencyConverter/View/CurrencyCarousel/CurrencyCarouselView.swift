//
//  CurrencyCarouselView.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 16.10.2022.
//

import UIKit
import SnapKit

// Class for construct view of carousel of currencies
final class CurrencyCarouselView: UIView {

    // MARK: - Nested types

    private enum Consts {
        enum CellItem {
            static let width: CGFloat = 120
            static let height: CGFloat = 20
        }

        enum CollectionViewFlowLayout {
            static let minimumInteritemSpacing: CGFloat = 5
        }
    }

    // MARK: - Private properties

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: Consts.CellItem.width,
            height: Consts.CellItem.height
        )
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = Consts.CollectionViewFlowLayout.minimumInteritemSpacing
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        return collectionView
    }()

    // MARK: - Initializable private properties

    private var currencies: [CurrencyShowType]

    // MARK: - Initializers
    /// Designated initializer
    /// Parameters:
    /// - currencies:  Array of currencies for showing in carousel
    init(currencies: [CurrencyShowType]) {
        self.currencies = currencies

        super.init(frame: .zero)

        configureAppearance()
        configureSubviews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { return nil }

    // MARK: - Internal methods

    /// Method for update carousel of currencies
    /// Parameters:
    /// - services:  Array of currency for update this view
    func updateCurrencies(_ currencies: [CurrencyShowType]) {
        self.currencies = currencies
        collectionView.reloadData()
    }
    // MARK: - Private methods

    private func configureAppearance() {
        backgroundColor = .clear

        collectionView.dataSource = self

        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            CurrencyCollectionCell.self,
            forCellWithReuseIdentifier: CurrencyCollectionCell.className
        )
    }

    private func configureSubviews() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CurrencyCarouselView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return currencies.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CurrencyCollectionCell.className,
                for: indexPath
        ) as? CurrencyCollectionCell else {
            return .init()
        }

        cell.configure(with: currencies[indexPath.row])

        return cell
    }
}
