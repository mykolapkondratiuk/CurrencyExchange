//
//  CurrencySellTableViewCell.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 18.10.2022.
//

import UIKit
import SnapKit

protocol CurrencySellTableViewCellDelegate: AnyObject {
    func readyToSell(
        currency: String,
        value: String,
        in cell: CurrencySellTableViewCell
    )
    
    func notReadyToSell(in cell: CurrencySellTableViewCell)
}

final class CurrencySellTableViewCell: UITableViewCell {

    // MARK: - Internal properties

    weak var delegate: CurrencySellTableViewCellDelegate?

    private(set) var currentCurrency: String = ""
    private(set) var currentCurrencyAmount: String = ""
    
    private(set) lazy var textField: UITextField = {
        let view = UITextField(frame: .zero)
        view.keyboardType = .decimalPad
        view.delegate = self
        view.isUserInteractionEnabled = true
        view.tag = 100
        view.textAlignment = .right
        
        return view
    }()

    private(set) lazy var dataPickerContainer: UITextField = {
        let view = UITextField(frame: .zero)
        view.keyboardType = .decimalPad
        view.delegate = self
        view.isUserInteractionEnabled = true
        view.tag = 200
        view.text = CurrencyType.euro.name
        
        return view
    }()

    // MARK: - Private properties
    
    private let upArrowImageView: UIImageView = {
        let imageView = UIImageView(image: Image.upArrow)
        return imageView
    }()

    private let sellLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Sell"
        
        return label
    }()

    private lazy var dataPicker: UIPickerView = {
        let frame = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: 120
        )
        let picker = UIPickerView(frame: frame)
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .cyan
        picker.selectRow(
            0,
            inComponent: 0,
            animated: false
        )
        
        return picker
    }()

    private let dropDownImageView: UIImageView = {
        let imageView = UIImageView(image: Image.dropDown)
        return imageView
    }()

    private var isPickerFirstTimeLoad = true

    // MARK: - Init

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        selectionStyle = .none
        
        dataPickerContainer.inputView = dataPicker
        
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

    // MARK: - Internal methods
    
    func updateCurrencyAmount(_ amount: String) {
        textField.text = amount
        currentCurrencyAmount = amount
    }
    
    // MARK: - Private Methods

    private func setupLayout() {
        addSubview(upArrowImageView)
        upArrowImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 43, height: 43))
            make.leading.equalToSuperview().inset(10)
        }

        addSubview(sellLabel)
        sellLabel.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.leading.equalTo(upArrowImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }

        addSubview(dataPickerContainer)
        dataPickerContainer.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(30)
        }
        
        addSubview(dropDownImageView)
        dropDownImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.leading.equalTo(dataPickerContainer.snp.trailing)
        }

        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.leading.equalTo(sellLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(90)
        }
    }

    fileprivate func checkForReadyToSell() {
        guard !currentCurrency.isEmpty,
              !currentCurrencyAmount.isEmpty else {
            delegate?.notReadyToSell(in: self)
            return
        }
        
        delegate?.readyToSell(
            currency: currentCurrency,
            value: currentCurrencyAmount,
            in: self
        )
    }
}

extension CurrencySellTableViewCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        return CurrencyType.allNames.count
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        return CurrencyType.allNames[row]
    }
}

extension CurrencySellTableViewCell: UIPickerViewDelegate {
    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        guard CurrencyType.allNames.count > row else {
            return
        }
        
        let selectedValue = CurrencyType.allNames[row]
        dataPickerContainer.text = selectedValue
        currentCurrency = selectedValue
        
        checkForReadyToSell()
    }
}

extension CurrencySellTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if textField.tag == 100 {
            currentCurrencyAmount = text
            checkForReadyToSell()
        }
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }

        let newText = oldText.replacingCharacters(
            in: r,
            with: string
        )
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1

        let numberOfDecimalDigits: Int
        if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(
                from: dotIndex,
                to: newText.endIndex
            ) - 1
        } else {
            numberOfDecimalDigits = 0
        }

        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }

    // became first responder
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 200 && isPickerFirstTimeLoad == true {
            dataPicker.selectRow(
                0,
                inComponent: 0,
                animated: true
            )
            currentCurrency = CurrencyType.euro.name
            textField.text = CurrencyType.euro.name
            isPickerFirstTimeLoad = false
        }
    }
}
