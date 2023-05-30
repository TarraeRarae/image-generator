//
//  FavoritePresenterTests.swift
//  image-generatorTests
//
//  Created by Alexey Zubkov on 30.05.2023.
//

import XCTest

@testable import image_generator

final class FavoritePresenterTests: XCTestCase {

    // MARK: Dependencies

    var controllerMock: FavoriteImagesControllerMock!
    var generatedImagesServiceMock: GeneratedImagesServiceMock!
    var presenter: IFavoriteImagesPresenter!

    // MARK: Lifecycle

    override func setUp() {
        super.setUp()
        continueAfterFailure = true

        controllerMock = FavoriteImagesControllerMock()
        generatedImagesServiceMock = GeneratedImagesServiceMock()

        presenter = FavoriteImagesPresenter(generatedImagesLocalService: generatedImagesServiceMock)
        presenter.view = controllerMock
    }

    override func tearDown() {
        presenter = nil
        generatedImagesServiceMock = nil
        controllerMock = nil

        super.tearDown()
    }
}

// MARK: - Tests

extension FavoritePresenterTests {

    func testSuccessUpdateContent() {
        // given
        generatedImagesServiceMock.invokedFetchDataCompletionResult = .success([])

        // when
        presenter.updateContent()

        // then
        XCTAssertEqual(generatedImagesServiceMock.invokedFetchDataCount, 1)
        XCTAssertEqual(controllerMock.invokedConfigreCount, 1)
    }

    func testFailureUpdateContent() {
        // given
        generatedImagesServiceMock.invokedFetchDataCompletionResult = .failure(.unableToSaveData)

        // when
        let alertExpectation = self.expectation(description: "controller alert call")
        controllerMock.invokedShowCommonErrorAlertAction = {
            alertExpectation.fulfill()
        }
        presenter.updateContent()
        waitForExpectations(timeout: 1)

        // then
        XCTAssertEqual(generatedImagesServiceMock.invokedFetchDataCount, 1)
        XCTAssertEqual(controllerMock.invokedConfigreCount, 0)
        XCTAssertEqual(controllerMock.invokedShowCommonErrorAlertCount, 1)
    }
}
