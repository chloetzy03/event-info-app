/*
 Info/MoreInfoViewController.swift
 */



import UIKit

class MoreInfoViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "More Info"
        navigationItem.largeTitleDisplayMode = .always
        configureNavigationItems()
        configureContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Setup

    private func configureNavigationItems() {
        // Create a bar button item with SF Symbol icon
        let feedbackItem = UIBarButtonItem(image: UIImage(systemName: "paperplane.fill"), style: .plain, target: self, action: #selector(sendFeedback))

        // Accessibility label is what VoiceOver reads to users
        feedbackItem.accessibilityLabel = "Send Feedback"
        navigationItem.rightBarButtonItem = feedbackItem
    }

    private func configureContent() {
        // MARK: Scroll View Setup

        // Scroll view allows content to scroll when it's taller than the screen
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true // Allows "rubber band" bounce even when content fits
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)

        // Pin scroll view to safe area edges
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        // MARK: Stack View Setup

        // Stack view arranges all our content vertically
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24 // Space between each section
        stackView.alignment = .leading // Align content to left edge

        // Layout margins add padding around the stack view's content
        // isLayoutMarginsRelativeArrangement = true makes arranged subviews respect these margins
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 24, leading: 20, bottom: 40, trailing: 20)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(stackView)

        // IMPORTANT: Scroll views have TWO layout guides:
        // - contentLayoutGuide: defines the scrollable content area (can be larger than screen)
        // - frameLayoutGuide: defines the scroll view's visible frame (matches scroll view size)
        NSLayoutConstraint.activate([
            // These 4 constraints to contentLayoutGuide determine the scrollable area
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            // This width constraint to frameLayoutGuide prevents horizontal scrolling
            // It matches stack view width to scroll view's visible width
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        // MARK: Content

        // Introduction label at the top
        let introLabel = UILabel()
        introLabel.text = "Welcome to BasketWeavingCon 2025"
        introLabel.font = .systemFont(ofSize: 28, weight: .bold)
        introLabel.numberOfLines = 0 // Allows text to wrap to multiple lines
        stackView.addArrangedSubview(introLabel)

        // Array of (title, detail) tuples representing each info section
        let blurbs: [(String, String)] = [
            ("Hydration Strategy", "Complimentary pandan-infused water stations will be refreshed every odd hour. Bring your own eco-friendly tumbler to unlock the secret durian-cucumber spritzer option."),
            ("Workshop Dress Code", "Loose linen encouraged; synthetic fibres may eerily whistle during underwater demos. Flip-flops acceptable only if they match your loom."),
            ("Late Night Loom Lounge", "From 9 PM, join fellow weavers for experimental basket jazz, glow-in-the-dark reeds, and a karaoke segment featuring nothing but weaving puns."),
            ("Official Snack Pairing", "Day 1: kaya toast flight. Day 2: otah sliders. Day 3: a mystery dessert rumoured to be woven entirely from gula melaka."),
            ("Secret Achievement", "Scan three QR codes hidden around campus to unlock a limited-edition badge titled 'Thread Head Supreme'." )
        ]

        // Create a section view for each blurb
        // forEach loops through each tuple, unpacking title and detail
        blurbs.forEach { title, detail in
            let section = createInfoSection(title: title, detail: detail)
            stackView.addArrangedSubview(section)
        }

        // Footer label with smaller text
        let footerLabel = UILabel()
        footerLabel.text = "Need something even more specific? Tap the paper plane to holler at the organisers."
        footerLabel.font = .preferredFont(forTextStyle: .footnote) // Smallest standard text style
        footerLabel.numberOfLines = 0
        footerLabel.textColor = .tertiaryLabel // Most dimmed text color
        stackView.addArrangedSubview(footerLabel)
    }

    // MARK: - Helper Methods

    /// Creates a vertical stack containing a title and detail label
    /// This reduces code duplication when creating multiple info sections
    /// - Parameters:
    ///   - title: The section heading
    ///   - detail: The section body text
    /// - Returns: A UIStackView containing the formatted title and detail labels
    private func createInfoSection(title: String, detail: String) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: .headline) // Bold heading style
        titleLabel.numberOfLines = 0

        let detailLabel = UILabel()
        detailLabel.text = detail
        detailLabel.font = .preferredFont(forTextStyle: .body) // Standard body text
        detailLabel.numberOfLines = 0
        detailLabel.textColor = .secondaryLabel // Slightly dimmed for contrast with title

        // Stack arranges title above detail with 8pt spacing
        let sectionStack = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        sectionStack.axis = .vertical
        sectionStack.spacing = 8

        return sectionStack
    }

    // MARK: - Actions

    @objc private func sendFeedback() {
        // Create mailto URL to open email app
        // %20 represents a space in URL encoding
        guard let url = URL(string: "mailto:feedback@basketweavingcon.sg?subject=Feedback%20for%20BasketWeavingCon") else {
            return // URL is malformed, exit early
        }

        // Open the URL in the default email app (Mail, Gmail, etc.)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
