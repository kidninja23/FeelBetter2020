//
//  TemperatureViewController.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/30/20.
//

import Foundation
import ResearchKit
import CareKit
import CareKitStore
import CareKitUI

// 1. Subclass a task view controller to customize the control flow and present a ResearchKit survey!
class TemperatureViewController: OCKInstructionsTaskViewController, ORKTaskViewControllerDelegate {

    // 2. This method is called when the use taps the button!
    override func taskView(_ taskView: UIView & OCKTaskDisplayable, didCompleteEvent isComplete: Bool, at indexPath: IndexPath, sender: Any?) {
        
        // 2a. If the task was marked incomplete, fall back on the super class's default behavior or deleting the outcome.
        if !isComplete {
            super.taskView(taskView, didCompleteEvent: isComplete, at: indexPath, sender: sender)
            
            return
        }

        // 2b. If the user attempted to mark the task complete, display a ResearchKit survey.
        let answerFormat = ORKAnswerFormat.continuousScale(withMaximumValue: 105, minimumValue: 95, defaultValue: 98.6, maximumFractionDigits: 1, vertical: false, maximumValueDescription: "105° F", minimumValueDescription: "95° F")
        let feverStep = ORKQuestionStep(identifier: "fever-record", title: "Temperature", question: "Record your child's temperature", answer: answerFormat)
        let surveyTask = ORKOrderedTask(identifier: "feverRecord", steps: [feverStep])
        let surveyViewController = ORKTaskViewController(task: surveyTask, taskRun: nil)
        surveyViewController.delegate = self

        // 3a. Present the survey to the user
        
        present(surveyViewController, animated: true, completion: nil)
    }

    // 3b. This method will be called when the user completes the survey.
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        taskViewController.dismiss(animated: true, completion: nil)
        guard reason == .completed else {
            taskView.completionButton.label.text = "Record Temperature"
            taskView.completionButton.isSelected = false
            return
        }

        // 4a. Retrieve the result from the ResearchKit survey
        let survey = taskViewController.result.results!.first(where: { $0.identifier == "fever-record" }) as! ORKStepResult
        let feverResult = survey.results!.first as! ORKScaleQuestionResult
        let answer = Int(truncating: feverResult.scaleAnswer!)

        // 4b. Save the result into CareKit's store
        controller.appendOutcomeValue(value: answer, at: IndexPath(item: 0, section: 0), completion: nil)
    }
}

class TemperatureViewSynchronizer: OCKInstructionsTaskViewSynchronizer {

    // Customize the initial state of the view
    override func makeView() -> OCKInstructionsTaskView {
        let instructionsView = super.makeView()
        instructionsView.completionButton.label.text = loc("Record Temperature")
        return instructionsView
    }

    // Customize how the view updates
    override func updateView(_ view: OCKInstructionsTaskView, context: OCKSynchronizationContext<OCKTaskEvents>) {
        
        super.updateView(view, context: context)
        
        // Check if an answer exists or not and set the detail label accordingly

        
    }
}

