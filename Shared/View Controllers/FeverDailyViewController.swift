//
//  FeverDailyViewController.swift
//  FeelBetter (iOS)
//
//  Created by Jason on 10/15/20.
//

import Foundation
import UIKit
import CareKit
import CareKitStore
import SwiftUI

class FeverDailyViewController: OCKDailyPageViewController {
    //TODO - Add home button to return back to main screen.
    
    func getPostID() -> String {
        let patient = ClericStore.shared.selectedPatient
        return ClericStore.shared.activeCarePlan[patient!]!
    }
    
    override func dailyPageViewController(_ dailyPageViewController: OCKDailyPageViewController, prepare listViewController: OCKListViewController, for date: Date) {
        
        let patientID = getPostID()
        let preIdentifiers = [
            "Temperature Check 1: ",
            "Temperature Check 2: ",
            "Temperature Check 3: ",
            "Temperature Check 4: ",
            "Temperature Check 5: ",
            "Temperature Check 6: ",
            "Food Log: ",
            "Liquid Log: ",
            "Medication Log: ",
            "Symptom Log: "
        ]
        var identifiers = [String]()
        for item in preIdentifiers {
            let temp = item + patientID
            identifiers.append(temp)
        }
        
        var query = OCKTaskQuery(for: date)
        query.ids = identifiers
        query.excludesTasksWithNoEvents = true
        
        storeManager.store.fetchAnyTasks(query: query, callbackQueue: .main) {
            result in
            switch result {
            case .failure(let error): print("Error: \(error)")
            case .success(let tasks):
                if let temperatureTask = tasks.first(where: { $0.id == identifiers[0] }) {
            
                    // dynamic gradient colors
                    let tempGradientStart = UIColor { traitCollection -> UIColor in
                        return traitCollection.userInterfaceStyle == .light ? #colorLiteral(red: 0.9960784314, green: 0.3725490196, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.8627432641, green: 0.2630574384, blue: 0.2592858295, alpha: 1)
                    }
                    let tempGradientEnd = UIColor { traitCollection -> UIColor in
                        return traitCollection.userInterfaceStyle == .light ? #colorLiteral(red: 0.9960784314, green: 0.4732026144, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.8627432641, green: 0.3598620686, blue: 0.2592858295, alpha: 1)
                    }

                    // Create a plot showing how charts work
                    let temperatureDataSeries = OCKDataSeriesConfiguration(
                        taskID: identifiers[0],
                        legendTitle: "Temperature Recording",
                        gradientStartColor: tempGradientStart,
                        gradientEndColor: tempGradientEnd,
                        markerSize: 10,
                        eventAggregator: OCKEventAggregator.countOutcomeValues)

                    let insightsCard = OCKCartesianChartViewController(
                        plotType: .bar,
                        selectedDate: date,
                        configurations: [temperatureDataSeries],
                        storeManager: self.storeManager)

                    insightsCard.chartView.headerView.titleLabel.text = "Temperature Check Task"
                    insightsCard.chartView.headerView.detailLabel.text = "This Week"
                    insightsCard.chartView.headerView.accessibilityLabel = "Temperature Task Example"
                    listViewController.appendViewController(insightsCard, animated: false)
                    
                    let temperatureCard = TemperatureViewController(
                        viewSynchronizer: TemperatureViewSynchronizer(),
                        task: temperatureTask,
                        eventQuery: .init(for: date),
                        storeManager: self.storeManager)
                
                listViewController.appendViewController(temperatureCard, animated: false)
                }
                
                if let temperatureTask2 = tasks.first(where: { $0.id == identifiers[1] }) {
                    
                        let temperatureCard = TemperatureViewController(
                            viewSynchronizer: TemperatureViewSynchronizer(),
                            task: temperatureTask2,
                            eventQuery: .init(for: date),
                            storeManager: self.storeManager)
                    
                    listViewController.appendViewController(temperatureCard, animated: false)
                }
                
                if let temperatureTask = tasks.first(where: { $0.id == identifiers[2] }) {
                    
                        let temperatureCard = TemperatureViewController(
                            viewSynchronizer: TemperatureViewSynchronizer(),
                            task: temperatureTask,
                            eventQuery: .init(for: date),
                            storeManager: self.storeManager)
                    
                    listViewController.appendViewController(temperatureCard, animated: false)
                }
                
                if let temperatureTask = tasks.first(where: { $0.id == identifiers[3] }) {
                    
                        let temperatureCard = TemperatureViewController(
                            viewSynchronizer: TemperatureViewSynchronizer(),
                            task: temperatureTask,
                            eventQuery: .init(for: date),
                            storeManager: self.storeManager)
                    
                    listViewController.appendViewController(temperatureCard, animated: false)
                }
                
                if let temperatureTask = tasks.first(where: { $0.id == identifiers[4] }) {
                    
                        let temperatureCard = TemperatureViewController(
                            viewSynchronizer: TemperatureViewSynchronizer(),
                            task: temperatureTask,
                            eventQuery: .init(for: date),
                            storeManager: self.storeManager)
                    
                    listViewController.appendViewController(temperatureCard, animated: false)
                }
                
                if let temperatureTask = tasks.first(where: { $0.id == identifiers[5] }) {
                    
                        let temperatureCard = TemperatureViewController(
                            viewSynchronizer: TemperatureViewSynchronizer(),
                            task: temperatureTask,
                            eventQuery: .init(for: date),
                            storeManager: self.storeManager)
                    
                    listViewController.appendViewController(temperatureCard, animated: false)
                }
                
                if let foodTask = tasks.first(where: { $0.id == identifiers[6] }) {
                    
                        let foodCard = OCKChecklistTaskViewController( task: foodTask,
                            eventQuery: .init(for: date),
                            storeManager: self.storeManager)
                    
                    listViewController.appendViewController(foodCard, animated: false)
                }
                
                if let liquidTask = tasks.first(where: { $0.id == identifiers[7] }) {
                    
                        let liquidCard = OCKChecklistTaskViewController( task: liquidTask,
                            eventQuery: .init(for: date),
                            storeManager: self.storeManager)
                    
                    listViewController.appendViewController(liquidCard, animated: false)
                }
                
                if let medicationTask = tasks.first(where: { $0.id == identifiers[8] }) {
                    
                        let medicationCard = OCKChecklistTaskViewController( task: medicationTask,
                            eventQuery: .init(for: date),
                            storeManager: self.storeManager)
                    
                    listViewController.appendViewController(medicationCard, animated: false)
                }
                
                if let symptomTask = tasks.first(where: { $0.id == identifiers[9] }) {
                    
                        let symptomCard = OCKChecklistTaskViewController( task: symptomTask,
                            eventQuery: .init(for: date),
                            storeManager: self.storeManager)
                    
                    listViewController.appendViewController(symptomCard, animated: false)
                }
            }
        }
    }
    

    
}
