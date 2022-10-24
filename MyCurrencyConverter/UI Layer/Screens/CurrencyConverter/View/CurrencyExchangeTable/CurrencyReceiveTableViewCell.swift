//
//  CurrencyReceiveTableViewCell.swift
//  MyCurrencyConverter
//
//  Created by Mykola Kondratiuk on 19.10.2022.
//

import UIKit
import SnapKit

protocol CurrencyReceiveTableViewCellDelegate: AnyObject {
    func readyToReceveCurrency(
        type: String,
        in cell: CurrencyReceiveTableViewCell
    )
}

final class CurrencyReceiveTableViewCell: UITableViewCell {

    // MARK: - Internal properties

    weak var delegate: CurrencyReceiveTableViewCellDelegate?

    private(set) var currentCurrencyType: String = ""
    
    // MARK: - Private properties
    
    private let downArrowImageView: UIImageView = {
        let imageView = UIImageView(image: Image.downArrow)
        return imageView
    }()

    private let receiveLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Receive"
        
        return label
    }()

    private(set) lazy var textField: UITextField = {
        let view = UITextField(frame: .zero)
        view.keyboardType = .decimalPad
        view.textAlignment = .right
        view.textColor = .green

        return view
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
            1,
            inComponent: 0,
            animated: false
        )
        
        return picker
    }()
    
    private(set) lazy var dataPickerContainer: UITextField = {
        let view = UITextField(frame: .zero)
        view.keyboardType = .decimalPad
        view.delegate = self
        view.isUserInteractionEnabled = true
        view.tag = 100
        view.text = CurrencyType.dollarUS.name
        
        return view
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

    // MARK: - Private Methods

    private func setupLayout() {
        addSubview(downArrowImageView)
        downArrowImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 43, height: 43))
            make.leading.equalToSuperview().inset(10)
        }

        addSubview(receiveLabel)
        receiveLabel.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.leading.equalTo(downArrowImageView.snp.trailing).offset(10)
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
            make.leading.equalTo(receiveLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(90)
        }
    }
    
    fileprivate func checkReadyForReceive() {
        guard !currentCurrencyType.isEmpty else {
            return
        }
        
        delegate?.readyToReceveCurrency(
            type: currentCurrencyType,
            in: self
        )
    }
}

extension CurrencyReceiveTableViewCell: UIPickerViewDataSource {
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

extension CurrencyReceiveTableViewCell: UIPickerViewDelegate {
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
        currentCurrencyType = selectedValue
        
        checkReadyForReceive()
    }
}

extension CurrencyReceiveTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        return true
    }
    
    // became first responder
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 100 && isPickerFirstTimeLoad == true {
            dataPicker.selectRow(
                1,
                inComponent: 0,
                animated: true
            )
            textField.text = CurrencyType.dollarUS.name
            currentCurrencyType = CurrencyType.dollarUS.name
            isPickerFirstTimeLoad = false
            
            checkReadyForReceive()
        }
    }
}
