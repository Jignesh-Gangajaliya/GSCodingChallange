//
//  POTDViewController.swift
//  GSCodingChallange
//
//  Created by Jignesh Gajjar on 26/03/22.
//

import UIKit

class POTDViewController: UIViewController, PODViewDelegate, ActivityIndicatorPresenter {
    
    private let viewModel: POTDViewModel
    var activityIndicator = UIActivityIndicatorView()
    
    var isPOTDFavorite: Bool = false {
        didSet {
            if isPOTDFavorite {
                favoriteActionButton.setTitle("Delete from favourite", for: .normal)
            } else {
                favoriteActionButton.setTitle("Add to favourite", for: .normal)
            }
        }
    }
    
    private let imageView: GSImageView = {
       let imageView = GSImageView()
        imageView.contentMode = .scaleToFill
        imageView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        imageView.layer.cornerRadius = 4
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    private let favoriteActionButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemBlue
       return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
       return scrollView
    }()

    private let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchTextField: UITextField = {
       let searchTextField = UITextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.placeholder = "Search By Date"
        searchTextField.borderStyle = .roundedRect
        searchTextField.textColor = .black
       return searchTextField
    }()
    
    private let dateLabel: UILabel = {
       let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
       return label
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
       return label
    }()
    
    private let explanationLabel: UILabel = {
       let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
       return label
    }()
    
    init(viewModel: POTDViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show favorite", style: .plain, target: self, action: #selector(showFavorite))
        scrollView.frame = view.bounds
        view.addSubview(searchTextField)
        scrollView.bringSubviewToFront(searchTextField)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addArrangedSubview(dateLabel)
        scrollViewContainer.addArrangedSubview(titleLabel)
        scrollViewContainer.addArrangedSubview(imageView)
        scrollViewContainer.addArrangedSubview(explanationLabel)
        scrollViewContainer.addArrangedSubview(favoriteActionButton)
        favoriteActionButton.addTarget(self, action: #selector(handleFavoriteAction(_:)), for: .touchUpInside)
        addScrollViewConstraint()
        addMainViewOfScrollView()
        addSearchTextFieldConstraint()
        applyDatePicker()
        loadPicOfTheDay()
    }
    
    @objc func handleFavoriteAction(_ sender: UIButton) {
        viewModel.shouldFavoritePOTD(isfavorite: isPOTDFavorite)
    }
    
    private func addSearchTextFieldConstraint() {
        searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchTextField.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
    }
    
    private func addFavoriteActionButtonConstraint() {
        favoriteActionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        favoriteActionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        favoriteActionButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        favoriteActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
    }
    
    private func addScrollViewConstraint() {
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
    }
    
    @objc func showFavorite() {
        let service = RetriveFavouriteServiceImpl()
        let favouriteViewModel = FavouriteViewModelImpl(databaseService: service)
        let favouriteList = FavouriteViewController(viewModel: favouriteViewModel)
        favouriteViewModel.delegate = favouriteList
        navigationController?.pushViewController(favouriteList, animated: true)
    }
    
    private func addMainViewOfScrollView() {
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12).isActive = true
        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    private func loadPicOfTheDay() {
        showActivityIndicator()
        viewModel.loadPicOfTheDay()
    }
    
    private func applyDatePicker() {
        searchTextField.inputView = datePicker
        let pickerToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        pickerToolbar.barStyle = .default
        pickerToolbar.barTintColor = UIColor.black
        pickerToolbar.backgroundColor = UIColor.white
        pickerToolbar.isTranslucent = false

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:
                                            #selector(cancelBtnClicked(_:)))
        cancelButton.tintColor = UIColor.white
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:
                                            #selector(doneBtnClicked(_:)))
        doneButton.tintColor = UIColor.white
        pickerToolbar.items = [cancelButton, flexSpace, doneButton]
        searchTextField.inputAccessoryView = pickerToolbar
    }
    
    @objc func cancelBtnClicked(_ button: UIBarButtonItem?) {
        searchTextField.resignFirstResponder()
    }
    
    @objc func doneBtnClicked(_ button: UIBarButtonItem?) {
        searchTextField.resignFirstResponder()
        showActivityIndicator()
        viewModel.loadPicOfTheDay(by: datePicker.date)
    }
    
    func showError(error: String) {
        hideActivityIndicator()
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        present(alert, animated: true)
    }
    
    func displayPicOfTheDay(data: PictureOfTheDay) {
        hideActivityIndicator()
        DispatchQueue.main.async { [weak self] in
            self?.setupDataToDisplay(data: data)
        }
    }
    
    private func setupDataToDisplay(data: PictureOfTheDay) {
        isPOTDFavorite = false
        dateLabel.text = data.date
        titleLabel.text = data.title
        explanationLabel.text = data.explanation
        imageView.loadImage(from: data.url)
        viewModel.checkFavouritePOTD()
    }
    
    func showFavuoriteTitleButton(isFavourite: Bool) {
        self.isPOTDFavorite = isFavourite
    }
}

class GSImageView: UIImageView {
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
       let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
       return activityIndicator
    }()
    
    func loadImage(from url: String) {
        image = nil
        guard let url = URL(string: url) else {
            return
        }
        activityIndicator.startAnimating()
        ImageLoader.image(for: url) { [weak self] image in
            self?.activityIndicator.stopAnimating()
            self?.image = image
        }
    }
}


