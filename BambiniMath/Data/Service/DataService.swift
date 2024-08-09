//
//  DataService.swift
//  BambiniMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation

protocol DataService : AnyObject {
    func insertAllData(object: Objects)
    func getQuestionByObjectId(objectId : Int) -> [Question]
    func updateQuestionisUsed(question: Question, isUsed: Bool)
    func updateObjectisComplete(object: Objects, isComplete: Bool)
    func updateObjectOnGoing(object: Objects, onGoing: Bool)
    func updateObjectCurrentQuestion(object: Objects, currentQuestion: Int)
    func updateObjectIndexBreakdown(object: Objects, indexBreakdown: Int)
    func updateObjectHealth(object: Objects, health: Int)
    func printHello()
}
