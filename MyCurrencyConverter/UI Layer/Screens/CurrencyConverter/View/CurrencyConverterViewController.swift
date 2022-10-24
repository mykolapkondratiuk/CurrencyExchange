//
//  CurrencyConverterViewController.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 19.09.2022.
//

import UIKit
import SnapKit

final class CurrencyConverterViewController: UIViewController {

    // MARK: - Internal properties

    let customNavigationBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(
            red: 0,
            green: 120 / 255.0,
            blue: 199 / 255.0,
            alpha: 1
        )

        return view
    }()

    // MARK: - Private properties
    
    private let scrollContainer: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false

        return scroll
    }()
    
    private let contentView: UIView = {
        let content = UIView()
        content.backgroundColor = .clear
        return content
    }()

    private let myBalanceLabel: UILabel = {
        let label = UILabel()
        label.text = "MY BALANCES"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(
            red: 124 / 255.0,
            green: 136 / 255.0,
            blue: 148 / 255.0,
            alpha: 1
        )

        return label
    }()

    private let currencyCarouselView: CurrencyCarouselView = {
        let view = CurrencyCarouselView(currencies: [])
        view.backgroundColor = .clear

        return view
    }()

    private let currencyExchangeLabel: UILabel = {
        let label = UILabel()
        label.text = "CURRENCY EXCHANGE"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(
            red: 124 / 255.0,
            green: 136 / 255.0,
            blue: 148 / 255.0,
            alpha: 1
        )

        return label
    }()
    
    private let popUpIfNeedFeeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .green
        label.textAlignment = .right

        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .plain
        )
        tableView.separatorStyle = .singleLine
        tableView.register(
            CurrencySellTableViewCell.self,
            forCellReuseIdentifier: CurrencySellTableViewCell.className
        )
        tableView.register(
            CurrencyReceiveTableViewCell.self,
            forCellReuseIdentifier: CurrencyReceiveTableViewCell.className
        )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false

        return tableView
    }()

    private let myFeesLabel: UILabel = {
        let label = UILabel()
        label.text = "MY FEES"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(
            red: 124 / 255.0,
            green: 136 / 255.0,
            blue: 148 / 255.0,
            alpha: 1
        )

        return label
    }()

    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(
            red: 0,
            green: 119 / 255.0,
            blue: 197 / 255.0,
            alpha: 1
        )
        button.layer.cornerRadius = 24
        button.addTarget(
            self,
            action: #selector(didTapSubmitButton),
            for: .touchUpInside
        )
        button.setTitle(
            "SUBMIT",
            for: .normal
        )

        return button
    }()

    private let myFeeCarouselView: CurrencyCarouselView = {
        let view = CurrencyCarouselView(currencies: [])
        view.backgroundColor = .clear

        return view
    }()

    private var count = 0
    
    private var currencyForSell: Currency?
    private var typeForReceive: CurrencyType? = .dollarUS

    // MARK: - Initializable private properties

    private var viewModel: CurrencyConverterViewModel

    // MARK: - Initializers

    /// Designated Initializer
    ///
    /// - Parameters:
    ///     - viewModel: view model screen CurrencyConverter
    init(viewModel: CurrencyConverterViewModel) {
        self.viewModel = viewModel
        super.init(
            nibName: nil,
            bundle: nil
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureAppearance()

        setupBindingWithViewModel()
        
        setupLayout()

        viewModel.checkCurrentCurrencyValueInRepository { result in
            switch result {
            case .success((let listCurrencies, let listCommissions)):
                currencyCarouselView.updateCurrencies(listCurrencies)
                myFeeCarouselView.updateCurrencies(listCommissions)
            case .failure(let error):
                log.debug(error.localizedDescription)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        registerForKeyboardNotifications()
        registerTapGestureRecognizer()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        unregisterForKeyboardNotifications()
        endEditing()
    }

    // MARK: - Internal methods

    // MARK: - Private methods

    private func configureAppearance() {
        let color = UIColor(
            red: 0,
            green: 120 / 255.0,
            blue: 199 / 255.0,
            alpha: 1
        )
        self.navigationController?.setStatusBar(backgroundColor: color)
        self.navigationController?.navigationBar.setNeedsLayout()

        view.backgroundColor = .white
    }

    private func setupLayout() {
        view.addSubview(scrollContainer)
        scrollContainer.snp.makeConstraints { make in
            make.edges.equalTo(view)
            // make.top.equalTo(customNavigationBarView.snp.bottom)
            // make.leading.trailing.bottom.equalToSuperview()
        }
        
        // add contentView to scrollView
        scrollContainer.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollContainer)
        }
        // constrain contentView's width to scrollView's width
        // but we *don't* constrain its height
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollContainer)
        }

        contentView.addSubview(customNavigationBarView)
        customNavigationBarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(0)  // (88)
        }
        
        contentView.addSubview(myBalanceLabel)
        myBalanceLabel.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBarView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(10)
        }

        contentView.addSubview(currencyCarouselView)
        currencyCarouselView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
            make.top.equalTo(myBalanceLabel.snp.bottom).offset(42)
        }

        contentView.addSubview(currencyExchangeLabel)
        currencyExchangeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(currencyCarouselView.snp.bottom).offset(50)
            make.height.equalTo(10)
        }
        
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(currencyExchangeLabel.snp.bottom).offset(30)
            make.height.equalTo(100)
        }
        
        contentView.addSubview(popUpIfNeedFeeLabel)
        popUpIfNeedFeeLabel.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(tableView.snp.bottom).inset(5)
        }
        
        contentView.addSubview(myFeesLabel)
        myFeesLabel.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(10)
        }
        
        contentView.addSubview(myFeeCarouselView)
        myFeeCarouselView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
            make.top.equalTo(myFeesLabel.snp.bottom).offset(42)
        }
        
        contentView.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(33)
            make.top.equalTo(myFeeCarouselView.snp.bottom).offset(50)
        }
        
        // constrain the BOTTOM of the lastest view 20-pts from the bottom of contentView
        submitButton.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).offset(-20)
        }
    }

    private func setupBindingWithViewModel() {
        viewModel.exchangeChecked = { [weak self] amountAsString in
            self?.updateReceiveCell(ammount: amountAsString)
            if amountAsString == "Not enough money" {
                self?.popUpIfNeedFeeLabel.text = ""
            }
        }
        
        viewModel.showFeeAtExchangeChecking = { [weak self] amountAsString in
            guard let self = self,
                  let currencyForSellName = self.currencyForSell?.name
            else {
                assertionFailure("check it")
                return
            }
            
            let message = "Fee at this transaction will be \(amountAsString) \(currencyForSellName)"
            self.popUpIfNeedFeeLabel.text = message
        }
        
        viewModel.exchangeSubmittedWithFee = { [weak self] (selledCurrency: Currency, receivedCurrency: Currency, fee: Commission) in
            guard let self = self else { return }
            
            var message = "You have converted \(selledCurrency.amountAsString) \(selledCurrency.name) to "
            message.append("\(receivedCurrency.amountAsString) \(receivedCurrency.name) Commission Fee - ")
            message.append("\(fee.amountAsString) \(fee.name).")
            
            let alert = UIAlertController(
                title: "Currency converted",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                    title: "Done",
                    style: .default,
                    handler: { [weak self] _ in
                        guard let self = self else { return }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                            guard let strongSelf = self else { return }
                            
                            strongSelf.updateReceiveCell(ammount: "")
                            strongSelf.updateSellCell(amount: "")
                            strongSelf.currencyForSell = nil
                            strongSelf.popUpIfNeedFeeLabel.text = ""
                        }
                    }
                )
            )
            self.present(
                alert,
                animated: true
            )
            
            self.updateReceiveCell(ammount: receivedCurrency.amountAsString)

            self.currencyCarouselView.updateCurrencies(self.viewModel.currentListOfCurrency)
            self.myFeeCarouselView.updateCurrencies(self.viewModel.currentListOfCommission)
        }
    }
    
    private func updateReceiveCell(ammount: String) {
        guard let cell = tableView.cellForRow(
            at: IndexPath(
                row: 1,
                section: 0
            )
        ),
              let currencyReceiveTableViewCell = cell as? CurrencyReceiveTableViewCell
        else {
            assertionFailure()
            return
        }

        currencyReceiveTableViewCell.textField.text = ammount
    }

    private func updateSellCell(amount: String) {
        guard let cell = tableView.cellForRow(
            at: IndexPath(
                row: 0,
                section: 0
            )
        ),
              let currencySellTableViewCell = cell as? CurrencySellTableViewCell
        else {
            assertionFailure()
            return
        }

        currencySellTableViewCell.updateCurrencyAmount(amount)
    }
    
    // MARK: - Actions
    
    @objc
    override func endEditing() {
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }
    
    @objc
    private func didTapSubmitButton() {
        guard let typeForReceive = typeForReceive,
              let currencyForSell = currencyForSell else {
            log.debug("\nNEED UPDATE AMOUNT OR TYPE OF RECEIVED CURRENCY\n")
            return
        }
        
        viewModel.submitExchangeAction?(currencyForSell, typeForReceive)
    }
}

extension CurrencyConverterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 2
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CurrencySellTableViewCell.className,
                for: indexPath
            )
            if let cell = cell as? CurrencySellTableViewCell {
                cell.delegate = self
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CurrencyReceiveTableViewCell.className,
                for: indexPath
            )
            
            if let cell = cell as? CurrencyReceiveTableViewCell {
                cell.delegate = self
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let cell = tableView.cellForRow(at: indexPath)

        if let currencySellTableViewCell = cell as? CurrencySellTableViewCell {
            
            if count % 2 == 0 {
                currencySellTableViewCell.dataPickerContainer.becomeFirstResponder()
                count += 1
            } else {
                currencySellTableViewCell.textField.becomeFirstResponder()
                count += 1
            }
        }
        
        if let currencyReceiveTableViewCell = cell as? CurrencyReceiveTableViewCell {
            currencyReceiveTableViewCell.dataPickerContainer.becomeFirstResponder()
        }
    }
}

extension CurrencyConverterViewController: CurrencySellTableViewCellDelegate {
    func notReadyToSell(in cell: CurrencySellTableViewCell) {
        updateReceiveCell(ammount: "")
        currencyForSell = nil
        popUpIfNeedFeeLabel.text = ""
    }
    
    func readyToSell(
        currency: String,
        value: String,
        in cell: CurrencySellTableViewCell
    ) {
        guard let currencyType = CurrencyType.create(from: currency) else {
            assertionFailure()
            return
        }
        
        currencyForSell = Currency(
            currencyType: currencyType,
            stringDecimal: value
        )
        
        guard let typeForReceive = typeForReceive,
              let currencyForSell = currencyForSell else {
            log.debug("\nNEED UPDATE AMOUNT OR TYPE OF RECEIVED CURRENCY\n")
            return
        }
        
        viewModel.checkExchangeAction?(currencyForSell, typeForReceive)
    }
}

extension CurrencyConverterViewController: CurrencyReceiveTableViewCellDelegate {
    func readyToReceveCurrency(
        type: String,
        in cell: CurrencyReceiveTableViewCell
    ) {
        guard let currencyType = CurrencyType.create(from: type) else {
            assertionFailure()
            return
        }
        
        typeForReceive = currencyType
        
        guard let typeForReceive = typeForReceive,
              let currencyForSell = currencyForSell else { return }
        
        viewModel.checkExchangeAction?(currencyForSell, typeForReceive)
    }
}
