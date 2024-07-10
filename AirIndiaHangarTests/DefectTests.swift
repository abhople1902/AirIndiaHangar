//
//  DefectTests.swift
//  AirIndiaHangarTests
//
//  Created by E5000848 on 02/07/24.
//

import XCTest
import CoreData
@testable import AirIndiaHangar

class DefectTests: XCTestCase {

    var viewController: DetectFaultViewController!
    var mockContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Set up view controller from storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "DetectFaultViewController") as? DetectFaultViewController
        viewController.loadViewIfNeeded()

        // Set up in-memory Core Data context
        let mockPersistantContainer = NSPersistentContainer(name: "AirIndiaHangar")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        mockPersistantContainer.persistentStoreDescriptions = [description]
        mockPersistantContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        mockContext = mockPersistantContainer.viewContext
        viewController.context = mockContext
    }

    override func tearDownWithError() throws {
        viewController = nil
        mockContext = nil
        try super.tearDownWithError()
    }

    // Unit Tests

    func testViewControllerIsNotNil() {
        XCTAssertNotNil(viewController)
    }

    func testImagePickerIsSetUp() {
        XCTAssertEqual(viewController.imagePicker.delegate as? DetectFaultViewController, viewController)
        XCTAssertEqual(viewController.imagePicker.sourceType, .photoLibrary)
        XCTAssertFalse(viewController.imagePicker.allowsEditing)
    }

    func testDoneButtonPressedWithValidImage() {
        let testImage = UIImage(systemName: "star")
        viewController.faultImageView.image = testImage
        viewController.faultLabel.text = "Test Fault"

        viewController.doneButtonPressed(UIButton())

        let fetchRequest: NSFetchRequest<Defect> = Defect.fetchRequest()
        let results = try? mockContext.fetch(fetchRequest)
        XCTAssertEqual(results?.count, 1)
        XCTAssertEqual(results?.first?.name, "Test Fault")
    }

    func testImageConverterWithValidImage() {
        let testImage = UIImage(systemName: "star")
        let imageData = viewController.imageConverter(testImage!)
        XCTAssertNotNil(imageData)
    }

    func testImageConverterWithNilImage() {
        let imageData = viewController.imageConverter(UIImage())
        XCTAssertNotNil(imageData)
    }

    // UI Tests (Simplified for unit test environment)

    func testFaultLabelIsUpdatedAfterImagePick() {
        let testImage = UIImage(systemName: "star")
        let info: [UIImagePickerController.InfoKey: Any] = [.originalImage: testImage!]

        viewController.imagePickerController(viewController.imagePicker, didFinishPickingMediaWithInfo: info)

        XCTAssertNotNil(viewController.faultImageView.image)
        // Additional asynchronous tests for faultLabel text update should be done in UI test target
    }

    func testDefectAddedConfirmAlertPresented() {
        viewController.present(viewController.defectAddedConfirmAlert, animated: false, completion: nil)
        XCTAssertTrue(viewController.presentedViewController is UIAlertController)
        XCTAssertEqual((viewController.presentedViewController as? UIAlertController)?.title, "Defect saved")
    }

    func testDefectNotAddedAlertPresented() {
        viewController.present(viewController.defectNotAddedAlert, animated: false, completion: nil)
        XCTAssertTrue(viewController.presentedViewController is UIAlertController)
        XCTAssertEqual((viewController.presentedViewController as? UIAlertController)?.title, "Unable to save defect")
    }
}

// Mock Navigation Controller for testing modal presentation
class MockNavigationController: UINavigationController {
    var presentedVC: UIViewController?

    override func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        presentedVC = viewControllerToPresent
        super.present(viewControllerToPresent, animated: animated, completion: completion)
    }
}
