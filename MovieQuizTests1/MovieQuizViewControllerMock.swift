//
//  MovieQuizViewControllerMock.swift
//  MovieQuizTests1
//
//  Created by Anna Domracheva on 27.06.2024.
//

import UIKit
@testable import MovieQuiz

final class MovieQuizViewControllerMock: UIViewController, MovieQuizViewControllerProtocol {
    
    private(set) var step: QuizStepViewModel?
    
    func show(quiz step: QuizStepViewModel) {
        self.step = step
    }
    
    func showResult(model: QuizResultsViewModel) { }
    
    func highlightImageBorder(isCorrect: Bool) { }
    
    func showNetworkError(message: String) { }
    
    func hideLoadingIndicator() { }
    
    func showLoadingIndicator() { }
}
