

import UIKit

class ByteCoinViewController: UIViewController {
    
    var coinManager = CoinManager()
    
    lazy var currencyPicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.contentMode = .scaleToFill
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.contentMode = .scaleToFill
        stackView.alignment = .center
        stackView.spacing = 25
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var coinView: UIView = {
        let view = UIView()
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let byteCoinLabel: UILabel = {
        let label = UILabel()
        label.text = "ByteCoin"
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 45)
        return label
    }()
    
    lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var byteCoinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bitcoinsign.circle.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var bitcoinLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25)
        return label
    }()
    
    let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "USD"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        
        coinManager.delegate = self
    }
    
    func setupViews() {
        view.backgroundColor = .systemMint
        view.addSubview(verticalStackView)
        view.addSubview(currencyPicker)
        verticalStackView.addArrangedSubview(byteCoinLabel)
        verticalStackView.addArrangedSubview(coinView)
        coinView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(byteCoinImageView)
        horizontalStackView.addArrangedSubview(bitcoinLabel)
        horizontalStackView.addArrangedSubview(currencyLabel)
    }
}

//MARK: - Constraints

extension ByteCoinViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            currencyPicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            currencyPicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            currencyPicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            currencyPicker.heightAnchor.constraint(equalToConstant: 216),
            
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            byteCoinLabel.heightAnchor.constraint(equalToConstant: 45),
            byteCoinLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 230),
            
            coinView.heightAnchor.constraint(equalToConstant: 79),
            coinView.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor, constant: 10),
            coinView.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor, constant: -10),
            
            byteCoinImageView.topAnchor.constraint(equalTo: coinView.topAnchor),
            byteCoinImageView.bottomAnchor.constraint(equalTo: coinView.bottomAnchor),
            byteCoinImageView.widthAnchor.constraint(equalToConstant: 79),
            
            horizontalStackView.topAnchor.constraint(equalTo: coinView.topAnchor, constant: 10),
            horizontalStackView.bottomAnchor.constraint(equalTo: coinView.bottomAnchor, constant: -10),
            horizontalStackView.trailingAnchor.constraint(equalTo: coinView.trailingAnchor, constant: -10),
            horizontalStackView.leadingAnchor.constraint(equalTo: coinView.leadingAnchor, constant: 10),
        ])
    }
}

//MARK: - UIPickerViewDataSource

extension ByteCoinViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

//MARK: - UIPickerViewDelegate
extension ByteCoinViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
        currencyLabel.text = selectedCurrency
        
    }
}

//MARK: - CoinManagerDelegate
extension ByteCoinViewController: CoinManagerDelegate {
    
    func didUpdatePrice(_ coinManager: CoinManager, price: String) {
        DispatchQueue.main.async { [weak self] in
            self?.bitcoinLabel.text = price
        }
    }
    
    func didFailWithError(_ coinManager: CoinManager, error: Error) {
        print(error)
    }
}
