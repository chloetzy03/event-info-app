/*
 MainTabBarController.swift
 */



import UIKit

class MainTabBarController: UITabBarController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // TODO: Create three view controllers for the tabs:
        // - GeneralInfoViewController (for Info tab)
        // - TalksPageViewController (for Talks tab)
        // - NameCardDisplayViewController (for Name Card tab)
        let infoVC = GeneralInfoViewController()
        let talksVC = TalksPageViewController()
        let namecCardVC = NameCardDisplayViewController()

        // TODO: Configure tab bar items for each view controller
        // Use UITabBarItem(title:, image:, tag:)
        // Suggested icons: "info.circle", "speaker", "person.crop.rectangle"
        infoVC.tabBarItem = UITabBarItem(title: "General Info", image: UIImage(systemName: "info.circle"), tag: 0)
        talksVC.tabBarItem = UITabBarItem(title: "Talks", image: UIImage(systemName: "speaker"), tag: 1)
        namecCardVC.tabBarItem = UITabBarItem(title: "Name Card", image: UIImage(systemName: "person.crop.rectangle"), tag: 2)

        // TODO: Wrap each view controller in a navigation controller, gives each screen a top bar with large title
        // Use the createNavigationController(for:) helper method below
        let infoNav = createNavigationController(for: infoVC)
        let talksNav = createNavigationController(for: talksVC)
        let nameCardNav = createNavigationController(for: namecCardVC)

        // TODO: Set self.viewControllers to an array of the navigation controllers
        //gives tab bar its list of screens, in left to right order
        viewControllers = [infoNav, talksNav, nameCardNav]
    }

    // MARK: - Helper Methods

    /// Creates a navigation controller with large titles enabled
    /// - Parameter rootViewController: The view controller to wrap in navigation
    /// - Returns: Navigation controller containing the root view controller
    private func createNavigationController(for rootViewController: UIViewController) -> UINavigationController {
        // Enable large titles for this view controller
        rootViewController.navigationItem.largeTitleDisplayMode = .always

        // Create navigation controller with this view controller as root
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true

        return navigationController
    }
}





#Preview {
    MainTabBarController()
}
