//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Anna Domracheva on 19.06.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
