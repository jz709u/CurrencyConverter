
import UIKit

class SelectFromCurrencyVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Private Variables
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: self.view.bounds)
        tv.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tv.estimatedRowHeight = 100
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    
    private let currencies: [Currency]
    private let onSelect: (Currency) -> Void
    
    // MARK: - Life Cycle
    
    init(currencies: [Currency],
         onSelect: @escaping (Currency) -> Void) {
        self.currencies = currencies
        self.onSelect = onSelect
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.fill(view: self.view)
        tableView.reloadData()
    }
    
    // MARK: - UITableviewDataSource UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let currency = currencies[indexPath.row]
        cell.textLabel?.text =  currency.localizedName + " " + currency.abbreviation
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelect(currencies[indexPath.row])
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }        
    }
}
