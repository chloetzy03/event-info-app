/*
 Talks/TalksPageViewController.swift
 */


import UIKit

// TODO: Conform to UIPageViewControllerDataSource
class TalksPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    // MARK: - Properties

    private var talkViewControllers = [UIViewController]()
    private let pageControl = UIPageControl()

    /// Conference talks to display (swipe left/right to navigate)
    private let talks = [
        Talk(title: "The Art of Underwater Basket Weaving", speaker: "John Doe", time: "10:00 AM", summary: "A deep dive into the history and techniques of underwater basket weaving."),
        Talk(title: "Modern Basket Weaving Materials", speaker: "Jane Smith", time: "11:00 AM", summary: "Exploring new and sustainable materials for basket weaving."),
        Talk(title: "Basket Weaving for Fun and Profit", speaker: "Peter Jones", time: "1:00 PM", summary: "How to turn your hobby into a successful business.")
    ]

    // MARK: - Lifecycle

    init() {
        // UIPageViewController transitions between view controllers with gestures
        // .scroll gives us horizontal swiping between pages
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Talks"

        // TODO: Set datasource and delegate
        dataSource = self
        delegate = self

        configurePages()
        configurePageControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Setup

    private func configurePages() {
        // TODO: Create talkViewControllers array by mapping talks
        talkViewControllers = talks.map{
            talk in TalkViewController(talk: talk)
        }
        // TODO: Set the initial view controller
        // Get the first view controller from talkViewControllers
        if let firstVC = talkViewControllers.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        // TODO: Configure page control
        // Set pageControl.numberOfPages and pageControl.currentPage as necessary
        //one dot per card, first dot active
        pageControl.numberOfPages = talkViewControllers.count
        pageControl.currentPage = 0
    }

    private func configurePageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        // Style the page control dots
        pageControl.currentPageIndicatorTintColor = .label // Active dot
        pageControl.pageIndicatorTintColor = UIColor.label.withAlphaComponent(0.2) // Inactive dots

        pageControl.isUserInteractionEnabled = false // User can't tap dots, only swipe
        pageControl.hidesForSinglePage = true // Hide if only one page

        // Add page control on top of page view controller's content
        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl) // Ensure it's visible above other views

        // Position at bottom center of screen
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - UIPageViewControllerDataSource

    // TODO: Implement viewControllerBefore , when users swiipe right
    // 1. Find currentIndex using talkViewControllers.firstIndex
    // 2. Calculate previousIndex
    // 3. Check if previousIndex >= 0, otherwise return nil
    // 4. Return talkViewControllers[previousIndex]
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //find the position of the current card in the list
        guard let currentIndex = talkViewControllers.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else { return nil } //if alr on the first card, theres nth before it
        
        return talkViewControllers[previousIndex]
    }

    // TODO: Implement viewControllerAfter , when users swipe left
    // 1. Find currentIndex using talkViewControllers.firstIndex
    // 2. Calculate nextIndex = currentIndex + 1
    // 3. Check if nextIndex < talkViewControllers.count, otherwise return nil
    // 4. Return talkViewControllers[nextIndex]
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = talkViewControllers.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = currentIndex + 1
        guard nextIndex < talkViewControllers.count else { return nil } //if alr on the last card, theres nth after it
        
        return talkViewControllers[nextIndex]
    }

    // MARK: - UIPageViewControllerDelegate

    // TODO: Implement didFinishAnimating
    // 1. Check if completed is true (transition actually finished)
    // 2. Get the current view controller from viewControllers?.first
    // 3. Find its index in talkViewControllers array
    // 4. Update pageControl.currentPage to that index
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        //if user started swiping but let go and it snapped back, do nth
        guard completed else { return }
        //check which card is currently on screen
        guard let currentVC = viewControllers?.first,
              let index = talkViewControllers.firstIndex(of: currentVC) else { return }
        //move the active dot to match
        pageControl.currentPage = index
    }
}
