import Foundation
import UIKit

class CurrencyConversionViewController: UIViewController {
    
    lazy var viewModel: CurrencyConversionViewStateModel = {
       let _vm = CurrencyConversionViewStateModel()
        
        return _vm
    }()
    
    enum Sections: Int, CaseIterable {
        case Form, List
        static var count: Int {
            allCases.count
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.register(FormCell.nib, forCellWithReuseIdentifier: FormCell.reuseId)
        cv.register(EmptyCell.self, forCellWithReuseIdentifier: EmptyCell.reuseId)
        cv.register(CurrencyExchangeCell.self, forCellWithReuseIdentifier: CurrencyExchangeCell.reuseId)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        collectionView.fill(view: self.view)
        collectionView.reloadData()
        
    }
}

extension CurrencyConversionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = Sections(rawValue: indexPath.section) else { return CGSize.zero }
        switch section {
        case .Form:
            return CGSize(width: collectionView.frame.width, height: 200)
        case .List:
            return CGSize(width: collectionView.frame.width - 20 / 2, height: collectionView.frame.width - 20 / 2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Sections(rawValue: indexPath.section) else { return collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCell.reuseId, for: indexPath) }
        switch section {
        case .Form:
            return collectionView.dequeueReusableCell(withReuseIdentifier: FormCell.reuseId, for: indexPath)
        case .List:
            return collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyExchangeCell.reuseId, for: indexPath) as! CurrencyExchangeCell
        }
    }
}

class SelectFromCurrencyVC: UIViewController {
    
}

extension UIView {
    func fill(view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: self.leftAnchor),
            view.rightAnchor.constraint(equalTo: self.rightAnchor),
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
