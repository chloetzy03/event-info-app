/*
 NameCard/NameCardEditViewController.swift
 */



import UIKit

// TODO: Define the NameCardEditViewControllerDelegate protocol here
// It should inherit from AnyObject (for weak references)
// Add one method: nameCardEditDidSave(name: String, email: String, photo: UIImage?)
protocol NameCardEditViewControllerDelegate: AnyObject{
    func nameCardEditDidSave(name: String, email: String, photo: UIImage?)
}

/// Edit modal for name card - allows user to change photo, name, and email
/// Presented modally from NameCardDisplayViewController
// TODO: Add UIImagePickerControllerDelegate and UINavigationControllerDelegate conformance
class NameCardEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties

    // TODO: Add delegate property
    weak var delegate: NameCardEditViewControllerDelegate?

    private var selectedImage: UIImage?

    // MARK: - UI Components

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let cardContainerView = UIView()
    private let imageView = UIImageView()
    private let nameTextField = UITextField()
    private let emailTextField = UITextField()
    private let photoButton = UIButton(type: .system)

    // MARK: - Lifecycle

    /// Custom initializer to pass in existing data for editing
    /// Default parameters (= "") allow calling init() with no arguments
    /// Example: init() or init(name: "John") or init(name: "John", email: "test@test.com")
    init(name: String = "", email: String = "", photo: UIImage? = nil) {
        super.init(nibName: nil, bundle: nil)

        // Set text field values (happens before viewDidLoad)
        nameTextField.text = name
        emailTextField.text = email
        if let photo = photo {
            selectedImage = photo
        }
    }

    /// Required by UIViewController when you implement a custom init
    /// This init is for loading from Storyboards/XIBs (we don't use those)
    /// fatalError() crashes if somehow called - forces you to use init(name:email:photo:)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Edit Name Card"
        navigationItem.largeTitleDisplayMode = .always

        // Done button dismisses modal and saves changes
        // .done shows checkmark icon
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneTapped)
        )

        setupScrollView()
        setupCardContainer()
        setupImageView()
        setupTextFields()
        setupPhotoButton()
        setupKeyboardDismissal()

        // Apply selectedImage if it was passed in init
        if let image = selectedImage {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Actions

    @objc private func doneTapped() {
        // Get values from text fields
        // textField.text is optional (might be nil)
        // ?? "" means "if nil, use empty string instead"
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""

        // TODO: Call delegate method to save the data
        delegate?.nameCardEditDidSave(name: name, email: email, photo: selectedImage)

        // Dismiss modal and return to display view
        dismiss(animated: true)
    }

    // MARK: - Setup Methods

    private func setupScrollView() {
        // Add scroll view to main view
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true

        // Pin scroll view to edges of safe area
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        // Add content view inside scroll view
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        // Content view constraints determine scrollable area
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            // Width matches scroll view frame so content doesn't scroll horizontally
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    private func setupCardContainer() {
        // Configure card appearance
        cardContainerView.backgroundColor = .secondarySystemGroupedBackground
        cardContainerView.layer.cornerRadius = 16
        cardContainerView.layer.cornerCurve = .continuous

        contentView.addSubview(cardContainerView)
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false

        // Card has padding from screen edges
        NSLayoutConstraint.activate([
            cardContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            cardContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    private func setupImageView() {
        // Configure image view as circular profile photo
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 80 // Half of width/height for perfect circle
        imageView.backgroundColor = .systemGray5
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.systemBackground.cgColor

        // Add placeholder icon using SF Symbols
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        let placeholderImage = UIImage(systemName: "person.circle.fill", withConfiguration: config)
        imageView.image = placeholderImage
        imageView.tintColor = .systemGray3
        imageView.contentMode = .center

        cardContainerView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 32),
            imageView.centerXAnchor.constraint(equalTo: cardContainerView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }

    private func setupTextFields() {
        // Configure name field
        nameTextField.placeholder = "Your Name"
        nameTextField.autocapitalizationType = .words
        nameTextField.returnKeyType = .next
        nameTextField.delegate = self
        configureTextField(nameTextField)

        // Configure email field
        emailTextField.placeholder = "your.email@example.com"
        emailTextField.autocapitalizationType = .none
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .done
        emailTextField.delegate = self
        configureTextField(emailTextField)

        // Add to container
        cardContainerView.addSubview(nameTextField)
        cardContainerView.addSubview(emailTextField)

        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false

        // Layout text fields below image view
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            nameTextField.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),

            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12),
            emailTextField.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    /// Helper method to configure common text field styling
    /// This reduces code duplication between name and title fields
    private func configureTextField(_ textField: UITextField) {
        textField.font = .systemFont(ofSize: 17)
        textField.textAlignment = .center
        textField.backgroundColor = .tertiarySystemGroupedBackground
        textField.layer.cornerRadius = 10
        textField.layer.cornerCurve = .continuous

        // Add padding using invisible views on left and right
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        textField.leftView = leftPadding
        textField.leftViewMode = .always

        let rightPadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        textField.rightView = rightPadding
        textField.rightViewMode = .always
    }

    private func setupPhotoButton() {
        // Use iOS 26 Liquid Glass button style for premium look
        var config = UIButton.Configuration.prominentGlass()
        config.title = "Change Photo"
        config.image = UIImage(systemName: "camera.fill")
        config.imagePadding = 8
        config.buttonSize = .large

        photoButton.configuration = config
        photoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)

        cardContainerView.addSubview(photoButton)
        photoButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            photoButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 32),
            photoButton.centerXAnchor.constraint(equalTo: cardContainerView.centerXAnchor),
            photoButton.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -32)
        ])
    }

    private func setupKeyboardDismissal() {
        // Add tap gesture to dismiss keyboard when tapping outside text fields
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Allow other views to still receive touches
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Photo Selection

    // TODO: Implement photoButtonTapped
    // 1. Create UIAlertController with .actionSheet style
    // 2. Add "Take Photo" action if camera is available (check UIImagePickerController.isSourceTypeAvailable(.camera))
    //    - Call presentImagePicker(sourceType: .camera) in the action handler
    // 3. Add "Choose from Library" action
    //    - Call presentImagePicker(sourceType: .photoLibrary) in the action handler
    // 4. Add "Cancel" action with .cancel style
    // 5. For iPad: set popoverPresentationController.sourceView = photoButton
    // 6. Present the alert
    @objc private func photoButtonTapped() {
        let alert = UIAlertController(title: "Choose photo source", message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Take Photo", style: .default) {
                [weak self] _ in self?.presentImagePicker(sourceType: .camera)
            })
        }
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.presentImagePicker(sourceType: .photoLibrary)
        })
        // Cancel just closes the menu.
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // iPad shows this as a popover and needs to know which button it points to.
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = photoButton
        }
        
        present(alert, animated: true)
        
    }

    // TODO: Implement presentImagePicker(sourceType:)
    // 1. Create UIImagePickerController
    // 2. Set picker.delegate = self
    // 3. Set picker.sourceType to the parameter
    // 4. Set picker.allowsEditing = true
    // 5. Present the picker
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = sourceType
        picker.allowsEditing = true
        
        present(picker, animated: true)
    }

    // MARK: - UIImagePickerControllerDelegate

    // TODO: Implement imagePickerController(_:didFinishPickingMediaWithInfo:)
    // 1. Try to get edited image from info[.editedImage]
    // 2. If not found, get original image from info[.originalImage]
    // 3. Set selectedImage to the chosen image
    // 4. Update imageView.image
    // 5. Set imageView.contentMode = .scaleAspectFill
    // 6. Dismiss the picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        
        if let image = image {
            selectedImage = image
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
        }
        
        picker.dismiss(animated: true)
    }

    // TODO: Implement imagePickerControllerDidCancel(_:)
    // Just dismiss the picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension NameCardEditViewController: UITextFieldDelegate {
    /// Handle return key press on text fields
    /// Return key on name field moves to email field
    /// Return key on email field dismisses keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder() // Move to next field
        } else {
            textField.resignFirstResponder() // Dismiss keyboard
        }
        return true
    }
}
