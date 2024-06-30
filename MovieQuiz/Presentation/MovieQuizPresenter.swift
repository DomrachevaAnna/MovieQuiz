//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Anna Domracheva on 27.06.2024.
//

import UIKit


final class MovieQuizPresenter {
    
    weak var viewController: MovieQuizViewControllerProtocol?

    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var currentQuestion: QuizQuestion?
    private var correctAnswers = 0
    private var isLoading = false
    private lazy var questionFactory: QuestionFactoryProtocol = QuestionFactory(delegate: self)
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    // MARK: - Public
    
    func loadInitial() {
        questionFactory.loadData()
        viewController?.showLoadingIndicator()
    }
    
    func buttonClicked(givenAnswer: Bool) {
        guard let currentQuestion, !isLoading else { return }
        isLoading = true
        let isCorrect = currentQuestion.correctAnswer == givenAnswer
        if isCorrect { correctAnswers += 1 }
        viewController?.highlightImageBorder(isCorrect: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.isLoading = false
        }
    }
    
    func restart() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory.requestNextQuestion()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                          question: model.text,
                          questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
}

// MARK: QuestionFactoryDelegate

extension MovieQuizPresenter: QuestionFactoryDelegate {
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        viewController?.show(quiz: convert(model: question))
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
}

// MARK: Private

private extension MovieQuizPresenter {
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func showNextQuestionOrResults() {
        if isLastQuestion() {
            endGame()
        } else {
            switchToNextQuestion()
            questionFactory.requestNextQuestion()
        }
    }
    
    func endGame() {
        statisticService.store(correct: correctAnswers, total: 10)
        let text = correctAnswers == questionsAmount ?
        "Поздравляем, вы ответили на 10 из 10!" :
        "Ваш результат: \(correctAnswers)/10"
        let moreText = "\n Количество сыгранных квизов:\(statisticService.gamesCount) \n Рекорд:\(statisticService.bestGame.correct)/10 (\(statisticService.bestGame.date.dateTimeString)) \n Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))% "
        let model = QuizResultsViewModel(title: "Этот раунд окончен!",
                                         text: text + moreText,
                                         buttonText: "Сыграть ещё раз")
        viewController?.showResult(model: model)
    }
}
