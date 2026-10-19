/*
 NameCard/NameCardData.swift
 */


import UIKit

/// Simple helper struct for saving and loading name card data
/// Uses UserDefaults for text data and Documents directory for photo
/// Static methods allow you to call them directly without creating an instance
struct NameCardData {

    // MARK: - UserDefaults Keys

    // UserDefaults: Simple key-value storage (like a dictionary that persists)
    // Good for: small text data, settings, preferences
    // NOT good for: large data, images, sensitive data (use Keychain for passwords)
    private static let nameKey = "nameCard.name"
    private static let emailKey = "nameCard.email"
    private static let photoFilename = "nameCardPhoto.jpg"

    // MARK: - Save Methods

    /// Save name to UserDefaults
    /// - Parameter name: The name to save
    static func saveName(_ name: String) {
        UserDefaults.standard.set(name, forKey: nameKey)
    }

    /// Save email to UserDefaults
    /// - Parameter email: The email to save
    static func saveEmail(_ email: String) {
        UserDefaults.standard.set(email, forKey: emailKey)
    }

    /// Save photo to Documents directory
    /// - Parameter photo: The photo to save (nil to delete existing photo)
    static func savePhoto(_ photo: UIImage?) {
        guard let url = photoURL else { return }

        if let photo = photo, let data = photo.jpegData(compressionQuality: 0.8) {
            // Convert UIImage to JPEG data (compressed to 80% quality)
            try? data.write(to: url)
        } else {
            // No photo provided, delete existing file
            try? FileManager.default.removeItem(at: url)
        }
    }

    // MARK: - Load Methods

    /// Load name from UserDefaults
    /// - Returns: Saved name, or empty string if not found
    static func loadName() -> String {
        UserDefaults.standard.string(forKey: nameKey) ?? ""
    }

    /// Load email from UserDefaults
    /// - Returns: Saved email, or empty string if not found
    static func loadEmail() -> String {
        UserDefaults.standard.string(forKey: emailKey) ?? ""
    }

    /// Load photo from Documents directory
    /// - Returns: Saved photo, or nil if not found
    static func loadPhoto() -> UIImage? {
        guard let url = photoURL, FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    // MARK: - Photo Persistence Helper

    /// Get the file URL for the photo in the Documents directory
    /// Documents directory is permanent storage that survives app restarts
    /// Other directories: Caches (temporary), Temporary (cleared frequently)
    private static var photoURL: URL? {
        // FileManager handles all file system operations
        // .documentDirectory = where app can save permanent user files
        // .userDomainMask = current user's directory (vs system-wide)
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil // Couldn't access Documents directory (very rare)
        }
        // Append filename to get full path like: /Documents/nameCardPhoto.jpg
        return documentsPath.appendingPathComponent(photoFilename)
    }
}
