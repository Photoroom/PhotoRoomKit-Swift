//
//  ResultViewController.swift
//  api-demo
//
//  Created by Matthieu Rouif on 01/04/2021.
//

import UIKit
/// Ready to use ViewController to remove the background
final public class PhotoRoomViewController: UIViewController {
    enum ViewState {
        case success
        case loading
        case error(error: Error?)
    }
    
    let completionHandler: ((UIImage) -> Void)?
    let originalImage: UIImage
    var finalImage: UIImage? = nil
    let icon = UIImage(named: "PhotoRoomAttribution", in: PhotoRoomRessource.bundle, compatibleWith: nil)
    let urlString = "https://apps.apple.com/app/apple-store/id1455009060?pt=120355336&ct=api-"
        .appending(Bundle.main.bundleIdentifier ?? "")
        .appending("&mt=8")
    let apiKey: String
    let color = UIColor(red: 0.290, green: 0.239, blue: 0.8627, alpha: 1.0)

    let padding: CGFloat = 16.0

    var viewState: ViewState = .loading {
        didSet {
            switch viewState {
            case .success:
                imageView.image = finalImage
                attributionButton.alpha = 1.0
                validateButton.alpha = 1.0
                messageLabel.alpha = 0.0
                loadingIndicator.isHidden = true
                messageLabel.text = ""
            case .loading:
                imageView.image = originalImage
                attributionButton.alpha = 0.0
                validateButton.alpha = 0.0
                messageLabel.alpha = 1.0
                loadingIndicator.isHidden = false
                messageLabel.text = "Removing Background"
            case .error(let error):
                attributionButton.alpha = 0.0
                validateButton.alpha = 0.0
                messageLabel.alpha = 1.0
                imageView.image = originalImage
                loadingIndicator.isHidden = true
                print("error")
                messageLabel.text = error?.localizedDescription
            }
        }
    }
    
    // MARK: - Subviews

    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = originalImage
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    private lazy var attributionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .leading
        button.setImage(icon, for: .normal)
        button.addTarget(self, action: #selector(didTapAttribution), for: .touchUpInside)
        return button
    }()
    
    private lazy var validateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = padding
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.addTarget(self, action: #selector(didTapValidate), for: .touchUpInside)
        return button
    }()


    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        indicator.style = .large
        indicator.color = color
        return indicator
    }()

    // MARK: - Life Cycle
    /// - Parameters:
    ///     - image: The image you want to remove background
    ///     - apiKey: PhotoRoom API key
    ///     - completionHandler: Called once the background removal has been completed. Will not return if errored
    public init(image: UIImage, apiKey: String, completionHandler: ((UIImage) -> Void)? = nil) {
        self.originalImage = image
        self.apiKey = apiKey
        self.completionHandler = completionHandler
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(dismissButton)
        view.addSubview(loadingIndicator)
        view.addSubview(messageLabel)
        view.addSubview(validateButton)
        view.addSubview(attributionButton)
        activateConstraints()
        viewState = .loading

        //remove background
        let segmentationService = SegmentationService(apiKey: apiKey)
        segmentationService.segment(image: originalImage) { (image, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self.viewState = .error(error: error)
                }
                guard let image = image else {
                    self.viewState = .error(error: error)
                    return
                }
                self.finalImage = image
                UIView.animate(withDuration: 0.2, animations: {
                    self.viewState = .success
                })
            }
        }
    }
    
    // MARK: - Constraints

    private func activateConstraints() {
        let buttonSize: CGFloat = 64.0
        let attributionSize: CGFloat = 48.0
        let margins = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            dismissButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            dismissButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: padding),
            dismissButton.heightAnchor.constraint(equalToConstant: 40.0),
            dismissButton.widthAnchor.constraint(equalToConstant: 40.0),
            dismissButton.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -padding),

            imageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: attributionButton.topAnchor, constant: -(padding + buttonSize)),
            
            messageLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: validateButton.topAnchor, constant: -padding/2),
            
            validateButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            validateButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            validateButton.heightAnchor.constraint(equalToConstant: buttonSize),
            validateButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            
            loadingIndicator.centerYAnchor.constraint(equalTo: validateButton.centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: validateButton.centerXAnchor),

            attributionButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            attributionButton.widthAnchor.constraint(equalTo: attributionButton.heightAnchor, multiplier: 3.933),
            attributionButton.heightAnchor.constraint(equalToConstant: attributionSize),
            attributionButton.bottomAnchor.constraint(equalTo: validateButton.topAnchor, constant: -padding)
        ])
    }

    // MARK: - Actions

    @objc private func didTapDismiss(button _: UIButton) {
        dismiss(animated: true)
    }

    @objc private func didTapValidate(button _: UIButton) {
        guard let completionHandler = completionHandler,
              let image = finalImage else {
            dismiss(animated: true)
            return
        }
        completionHandler(image)
        dismiss(animated: true)
    }

    @objc private func didTapAttribution(button _: UIButton) {
        guard let attributionURL = URL(string: urlString) else {return}
        UIApplication.shared.open(attributionURL as URL, options: [UIApplication.OpenExternalURLOptionsKey : Any](), completionHandler: nil)
    }
}

private final class PhotoRoomRessource {
    static let bundle: Bundle = {
        let myBundle = Bundle(for: PhotoRoomRessource.self)

        guard let resourceBundleURL = myBundle.url(
            forResource: "PhotoRoomKit", withExtension: "bundle")
            else { fatalError("PhotoRoomKit.bundle not found!") }

        guard let resourceBundle = Bundle(url: resourceBundleURL)
            else { fatalError("Cannot access PhotoRoomKit.bundle!") }

        return resourceBundle
    }()
}
