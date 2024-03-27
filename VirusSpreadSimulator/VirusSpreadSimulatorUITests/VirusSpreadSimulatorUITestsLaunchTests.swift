//
//  VirusSpreadSimulatorUITestsLaunchTests.swift
//  VirusSpreadSimulatorUITests
//
//  Created by Максим Кузнецов on 27.03.2024.
//

import XCTest

final class VirusSpreadSimulatorUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
    }
}
