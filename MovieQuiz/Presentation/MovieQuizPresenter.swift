//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Anna Domracheva on 27.06.2024.
//

import UIKit


final class MovieQuizPresenter {
    
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
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
    
}
