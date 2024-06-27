//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Anna Domracheva on 27.06.2024.
//

import UIKit


final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var currentQuestion: QuizQuestion?
    var correctAnswers = 0
    lazy var questionFactory: QuestionFactoryProtocol = QuestionFactory(delegate: self)
    weak var viewController: MovieQuizViewController?
    
    func buttonClicked(givenAnswer: Bool) {
        guard let currentQuestion else { return }
        if currentQuestion.correctAnswer == givenAnswer {
            correctAnswers += 1
        }
        viewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer == givenAnswer)
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func restart() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory.requestNextQuestion()
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        
        guard let question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        viewController?.show(quiz: viewModel)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
        if isLastQuestion() {
            viewController?.showResult()
        } else {
            switchToNextQuestion()
            questionFactory.requestNextQuestion()
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
}
