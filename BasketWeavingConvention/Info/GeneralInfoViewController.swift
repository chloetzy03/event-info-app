/*
 Info/GeneralInfoViewController.swift
 */



import UIKit
import MapKit

// TODO: Conform to the following protocols
// UITableViewDelegate: handles user interactions with table rows
// UITableViewDataSource: provides data to populate the table view
class GeneralInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties

    private let tableView = UITableView()
    private let mapView = MKMapView()

    // Array of (label, value) tuples for event details
    private let eventInfo = [
        ("Date", "1st - 3rd December 2025"),
        ("Time", "9:00 AM - 5:00 PM"),
        ("Venue", "Ngee Ann Polytechnic Convention Centre"),
        ("Address", "535 Clementi Rd, Singapore 599489")
    ]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "General Info"
        navigationItem.largeTitleDisplayMode = .always

        setupMapView()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Setup

    private func setupMapView() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false

        // Map takes 30% of screen height at the top
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])

        // TODO: Create CLLocationCoordinate2D for your location
        // NP Coordinates: latitude: 1.332, longitude: 103.774
        let coordinate = CLLocationCoordinate2D(latitude: 1.332, longitude: 103.774)

        // TODO: Create MKCoordinateRegion centered on the coordinate
        // Use 1000m for both latitudinalMeters and longitudinalMeters
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)

        // TODO: Set the region on mapView using setRegion(_:animated:)
        mapView.setRegion(region, animated: false) //tells the map to display that region

        // TODO: Create MKPointAnnotation for the location
        // Set coordinate and title, e.g. "Ngee Ann Polytechnic"
        // Add annotation to mapView using addAnnotation(_:)
        let pin = MKPointAnnotation() //make a blank pin
        pin.coordinate = coordinate //put it at our point
        pin.title = "Ngee Ann Poly" //text shown at the pin
        mapView.addAnnotation(pin) //stick the pin onto the map
        
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        // Table view fills remaining space below the map
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        // TODO: Set tableView.delegate = self
        tableView.delegate = self
        // TODO: Set tableView.dataSource = self
        tableView.dataSource = self

        // TODO: Register cell identifiers for reuse
        // Register "cell" for event info rows
        // Register "moreInfoCell" for the "More info" row
        // Use tableView.register(UITableViewCell.self, forCellReuseIdentifier:)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "moreInfoCell")

        // Empty footer view removes separator lines below last row
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .systemBackground
    }

    // MARK: - UITableViewDataSource

    // TODO: Implement numberOfRowsInSection
    // Return eventInfo.count + 1 (4 event rows + 1 "More info" row)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        eventInfo.count + 1
        
    }

    // TODO: Implement cellForRowAt
    // Called once per row: "What should row number X look like?"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < eventInfo.count{
            //rows 0-3: the event details (Date, Time, Venue, Address)
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            //get this row's label, value pair  .0 = first item, .1 = second
            let info = eventInfo[indexPath.row]
            
            // Configure the cell's look.
            var content = cell.defaultContentConfiguration()
            content.text = info.0           // e.g. "Date"
            content.secondaryText = info.1  // e.g. "1st - 3rd December 2025"
            cell.contentConfiguration = content  // Apply it to cell, without this the cell stays blank
            
            cell.selectionStyle = .none     // No highlight on tap
            cell.accessoryType = .none      // No arrow on the right
            
            return cell
        } else { //last row, more info row
            let cell = tableView.dequeueReusableCell(withIdentifier: "moreInfoCell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = "More info"
            content.textProperties.color = view.tintColor
            cell.contentConfiguration = content
            
            cell.accessoryType = .disclosureIndicator  // The ">" arrow
            cell.selectionStyle = .default             // Highlights when tapped
            return cell
        }
    }
    // If indexPath.row < eventInfo.count:
    //   - Dequeue cell with identifier "cell"
    //   - Get info tuple from eventInfo array
    //   - Configure cell with defaultContentConfiguration()
    //   - Set text = info.0, secondaryText = info.1
    //   - Set selectionStyle = .none, accessoryType = .none
    // Else (last row is "More info"):
    //   - Dequeue cell with identifier "moreInfoCell"
    //   - Set text = "More info"
    //   - Set textProperties.color = view.tintColor
    //   - Set accessoryType = .disclosureIndicator
    //   - Set selectionStyle = .default

    // MARK: - UITableViewDelegate

    // TODO: Implement didSelectRowAt, called when users taps a row
    // Check if indexPath.row == eventInfo.count (the "More info" row)
    // Deselect the row with tableView.deselectRow(at:animated:)
    // Push MoreInfoViewController using navigationController?.pushViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //only react to the last row (more info)
        //if not last row, stop
        guard indexPath.row == eventInfo.count else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        //push the more info screen on top, slides in from right
        let moreInfoVC = MoreInfoViewController()
        navigationController?.pushViewController(moreInfoVC, animated: true)
    }
}


