import Foundation
import UIKit

class CurrencyConversionViewController: UIViewController {
    
    // MARK: - Variables
    
    private lazy var reloadDataClosure: () -> Void = { [weak self] () in
        self?.collectionView.reloadData()
    }
    
    private lazy var viewModel: CurrencyConversionViewStateModel = {
        let _vm = CurrencyConversionViewStateModel()
        _vm.onFromCurrencyChanged = self.reloadDataClosure
        _vm.onAvailableExchangeRatesChanged = self.reloadDataClosure
        return _vm
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.register(FormCell.nib,
                    forCellWithReuseIdentifier: FormCell.reuseId)
        cv.register(EmptyCell.self,
                    forCellWithReuseIdentifier: EmptyCell.reuseId)
        cv.register(CurrencyExchangeCell.self,
                    forCellWithReuseIdentifier: CurrencyExchangeCell.reuseId)
        cv.register(SectionHeader.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: SectionHeader.reuseId)
        return cv
    }()
    
    private enum Sections: Int, CaseIterable {
        case Form, List
        static var count: Int { allCases.count }
        var localizedHeader: String {
            switch self {
            case .Form:
                return "Convert From"
            case .List:
                return "Exchange Rates"
            }
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        collectionView.fill(view: self.view)
        collectionView.reloadData()
        
        navigationItem.title = "Currency Conversion!"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "clear cache",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(pressed(clearCacheButton:)))
        
        viewModel.fetchAvailableCurrencies { }
    }
    
    // MARK: - Action
    
    @objc private func pressed(clearCacheButton: UIButton) {
        AppManager.config.database.clear()
    }
    
    private func _presentCurrencySelectorVC() {
        self.navigationController?.pushViewController(SelectFromCurrencyVC(currencies: self.viewModel.availableCurrencies, onSelect: { [weak self] (currency) in
            self?.viewModel.fromCurrency = currency
        }), animated: true)
    }
}

extension CurrencyConversionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Items
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Sections(rawValue: section) else { return 0 }
        switch section {
        case .Form:
            return 1
        case .List:
            return viewModel.availableExchangeRates.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Sections(rawValue: indexPath.section) else { return collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCell.reuseId, for: indexPath) }
        switch section {
        case .Form:
            let formCell = collectionView.dequeueReusableCell(withReuseIdentifier: FormCell.reuseId,
                                                              for: indexPath) as! FormCell
            
            formCell.selectCurrencyButton.setTitle(viewModel.fromCurrency.abbreviation + " " + viewModel.fromCurrency.localizedName,
                                                   for: .normal)
            
            formCell.onAmountChangedIsValid = {[weak self] (amount) in
                guard let self = self else { return false }
                self.viewModel.amount = amount
                return self.viewModel.isValidAmount() != nil
            }
            
            formCell.onPressCurrencyButton = {[weak self] (button) in
                self?._presentCurrencySelectorVC()
            }
            
            formCell.onConvert = { [weak self] () in
                self?.viewModel.fetchActiveExchangeRates { }
            }
            
            return formCell
        case .List:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyExchangeCell.reuseId, for: indexPath) as! CurrencyExchangeCell
            let exchangeRate = viewModel.availableExchangeRates[indexPath.row]
            
            // format title
            var titleLabel = exchangeRate.toCurrencyAbbrev
            if let localized = viewModel.abbreviationToLocalizedName[titleLabel] {
                titleLabel = localized
            }
            cell.titleLabel.text = titleLabel
            
            // format currency
            let formatter = CurrencyConversionViewFormatters.currencyNumberFormatter(with: exchangeRate.toCurrencyAbbrev)
            cell.currencyLabel.text = formatter.string(from: NSNumber(value: exchangeRate.rate))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = Sections(rawValue: indexPath.section) else { return CGSize.zero }
        switch section {
        case .Form:
            return CGSize(width: collectionView.frame.width, height: FormCell.cellHeight)
        case .List:
            let lengthOfSide =  (collectionView.frame.width / 2) - 20
            return CGSize(width: lengthOfSide, height: lengthOfSide)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let section = Sections(rawValue: section) else { return UIEdgeInsets.zero }
        switch section {
        case .Form:
            return UIEdgeInsets.zero
        case .List:
            return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
    }
    
    // MARK: - Supplementary Views
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let emptyReusableView = UICollectionReusableView(frame: .zero)
        guard let section = Sections(rawValue: indexPath.section) else { return emptyReusableView }
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: SectionHeader.reuseId,
                                                                         for: indexPath) as! SectionHeader
            header.titleLabel.text = section.localizedHeader
            return header
        default:
            return emptyReusableView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let section = Sections(rawValue: section) else { return .zero }
        switch section {
        case .Form:
            return CGSize(width: collectionView.bounds.width,
                          height: SectionHeader.height)
        case .List:
            if viewModel.availableExchangeRates.count > 0 {
                return CGSize(width: collectionView.bounds.width,
                              height: SectionHeader.height)
            }
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize.zero
    }
}
