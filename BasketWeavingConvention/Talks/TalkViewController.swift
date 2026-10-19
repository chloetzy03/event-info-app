/*
 Talks/TalkViewController.swift
 */


import UIKit

class TalkViewController: UIViewController {

    // MARK: - Properties

    private let talk: Talk

    // MARK: - Lifecycle

    init(talk: Talk) {
        self.talk = talk
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Transparent background so we can see through to the page view controller
        view.backgroundColor = .clear
        view.clipsToBounds = false // Allow shadow to extend outside view bounds

        setupCardContainer()
    }

    // MARK: - Setup

    private func setupCardContainer() {
        // MARK: Card Container with Shadow

        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.layer.cornerCurve = .continuous // Smoother corners (iOS 13+)

        // Shadow properties - shadows are drawn OUTSIDE the view's bounds
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1 // 10% opacity for subtle shadow
        containerView.layer.shadowRadius = 10 // Blur distance
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4) // Shadow offset downward
        containerView.layer.masksToBounds = false // MUST be false for shadows to show

        // MARK: Labels

        let titleLabel = UILabel()
        titleLabel.text = talk.title
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.numberOfLines = 0 // Allow multiple lines for long titles

        let speakerLabel = UILabel()
        speakerLabel.text = "by \(talk.speaker)"
        speakerLabel.font = .systemFont(ofSize: 18, weight: .medium)
        speakerLabel.textColor = .secondaryLabel // Slightly dimmed text

        let timeLabel = UILabel()
        timeLabel.text = talk.time
        timeLabel.font = .systemFont(ofSize: 16, weight: .regular)
        timeLabel.textColor = .tertiaryLabel // More dimmed text

        let summaryLabel = UILabel()
        summaryLabel.text = talk.summary
        summaryLabel.font = .systemFont(ofSize: 16, weight: .regular)
        summaryLabel.numberOfLines = 0 // Allow text to wrap
        summaryLabel.textColor = .secondaryLabel

        // MARK: Spacer View Pattern

        // This empty view pushes all content to the top of the stack view
        // It expands to fill remaining space because:
        // - Low content hugging priority = "I don't need to hug my content tightly"
        // - Low compression resistance = "I'm OK being compressed"
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .vertical)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        // Create vertical stack of all labels + spacer
        let stackView = UIStackView(arrangedSubviews: [titleLabel, speakerLabel, timeLabel, summaryLabel, spacerView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 16 // Space between elements

        // MARK: Layout

        // Add container to main view
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])

        // Add stack view inside container
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        ])
    }
}
