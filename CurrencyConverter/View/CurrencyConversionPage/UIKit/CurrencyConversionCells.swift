import UIKit

class BaseCVCell: UICollectionViewCell {
    static var reuseId: String { "\(self)"}
}

class EmptyCell: BaseCVCell { }

class FormCell: BaseCVCell {
    
    static var nib: UINib {
        UINib(nibName: "FormCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class CurrencyExchangeCell: BaseCVCell {
    
}
