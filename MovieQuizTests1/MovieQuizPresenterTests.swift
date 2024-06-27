//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests1
//
//  Created by Anna Domracheva on 27.06.2024.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizPresenterTests: XCTestCase {
    
    private var sut: MovieQuizPresenter!
    private var viewController: MovieQuizViewControllerMock!
    
    override func setUp() {
        super.setUp()
        viewController = MovieQuizViewControllerMock()
        sut = MovieQuizPresenter()
        sut.viewController = viewController
    }
    
    override func tearDown() {
        viewController = nil
        sut = nil
        super.tearDown()
    }
    
    func testDidReceiveNextQuestion() throws {
        // Arrange
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        
        // Act
        sut.didReceiveNextQuestion(question: question)
        
        // Assert
        XCTAssertNotNil(viewController.step?.image)
        XCTAssertEqual(viewController.step?.question, "Question Text")
        XCTAssertEqual(viewController.step?.questionNumber, "1/10")
    }
}
