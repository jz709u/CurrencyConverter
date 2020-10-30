import UIKit

class BaseCVCell: UICollectionViewCell {
    
    static var reuseId: String { "\(self)"}
    static var nib: UINib { UINib(nibName: "\(self)",
                                  bundle: nil) }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        
    }
}

class EmptyCell: BaseCVCell { }

class FormCell: BaseCVCell, UITextFieldDelegate {
    
    static let cellHeight: CGFloat = 150
    
    // MARK: - IBOutlets
    @IBOutlet weak var selectCurrencyButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    
    var onPressCurrencyButton: ((UIButton) -> Void)?
    var onAmountChangedIsValid: ((String) -> Bool)?
    var onConvert: (() -> Void)?
    var previousValue = ""
    
    @IBAction func pressed(selectCurrencyButton: UIButton) {
        onPressCurrencyButton?(selectCurrencyButton)
    }
    
    @IBAction func changed(amountTextField: UITextField) {
        guard let newValue = amountTextField.text,
              let onAmountChanged = onAmountChangedIsValid else { return }
        convertButton.isEnabled = onAmountChanged(newValue)
    }
    
    @IBAction func pressed(convertButton:UIButton) {
        onConvert?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        amountTextField.textAlignment = .right
        amountTextField.keyboardType = .decimalPad
        amountTextField.placeholder = "enter"
        amountTextField.delegate = self
        selectCurrencyButton.titleLabel?.numberOfLines = 2
        convertButton.isEnabled = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let previousText = textField.text as NSString? else { return true }
        let updatedText = previousText.replacingCharacters(in: range, with: string)
        let validText = CurrencyConversionViewFormatters.DigitFormatter.formatText(prevValue: previousText as String,
                                                                                   newValue: updatedText)
        
        return validText == updatedText
    }
}

class CurrencyExchangeCell: BaseCVCell {
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(frame: self.contentView.bounds)
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return sv
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    lazy var currencyLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override func commonInit() {
        contentView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(currencyLabel)
    }
}

class SectionHeader: UICollectionReusableView {

    static var reuseId: String { "\(self)"}
    static let height: CGFloat = 50
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            layoutMarginsGuide.leftAnchor.constraint(equalTo: titleLabel.leftAnchor,
                                                     constant: 0),
            layoutMarginsGuide.rightAnchor.constraint(equalTo: titleLabel.rightAnchor,
                                                      constant: 0),
            layoutMarginsGuide.topAnchor.constraint(equalTo: titleLabel.topAnchor,
                                                    constant: 0),
            layoutMarginsGuide.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                       constant: 0)
        ])
    }
}
