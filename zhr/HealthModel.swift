//
//  Untitled.swift
//  zhr
//
//  Created by Mona on 15/12/2024.
//

import HealthKit

class HealthKitManager {
    let healthStore = HKHealthStore()
    
    // Define date range variables once
    private var startDate: Date {
        Calendar.current.startOfDay(for: Date())
    }
    private var endDate: Date {
        Date()
    }

    // Request authorization for multiple health data types
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let typesToRead: Set = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        ]

        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if let error = error {
                print("Authorization failed: \(error.localizedDescription)")
            }
            completion(success)
        }
    }

    // Fetch steps
    func fetchSteps(completion: @escaping (Double) -> Void) {
        guard let stepsCount = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            completion(0)
            return
        }

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        let query = HKSampleQuery(sampleType: stepsCount, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (_, results, error) in
            guard let results = results as? [HKQuantitySample], error == nil else {
                print("Error fetching steps: \(String(describing: error))")
                completion(0)
                return
            }

            let totalSteps = results.reduce(0) { $0 + $1.quantity.doubleValue(for: HKUnit.count()) }
            completion(totalSteps)
        }

        healthStore.execute(query)
    }

    // Fetch heart rate
    func fetchHeartRate(completion: @escaping (Double) -> Void) {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            completion(0)
            return
        }

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (_, results, error) in
            guard let results = results as? [HKQuantitySample], error == nil else {
                print("Error fetching heart rate: \(String(describing: error))")
                completion(0)
                return
            }

            let heartRates = results.map { $0.quantity.doubleValue(for: HKUnit(from: "count/min")) }
            let averageHeartRate = heartRates.isEmpty ? 0 : heartRates.reduce(0, +) / Double(heartRates.count)
            completion(averageHeartRate)
        }

        healthStore.execute(query)
    }

    // Fetch sleep data
    func fetchSleep(completion: @escaping (Double) -> Void) {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(0)
            return
        }

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (_, results, error) in
            guard let results = results, error == nil else {
                print("Error fetching sleep data: \(String(describing: error))")
                completion(0)
                return
            }

            let totalSleep = results.reduce(0) { (total, sample) -> Double in
                if let sleepSample = sample as? HKCategorySample {
                    return total + sleepSample.endDate.timeIntervalSince(sleepSample.startDate)
                }
                return total
            }
            completion(totalSleep / 3600) // Return hours of sleep
        }

        healthStore.execute(query)
    }

    // Fetch blood oxygen saturation
    func fetchBloodOxygen(completion: @escaping (Double) -> Void) {
        guard let bloodOxygenType = HKObjectType.quantityType(forIdentifier: .oxygenSaturation) else {
            completion(0)
            return
        }

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        let query = HKSampleQuery(sampleType: bloodOxygenType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (_, results, error) in
            guard let results = results as? [HKQuantitySample], error == nil else {
                print("Error fetching blood oxygen: \(String(describing: error))")
                completion(0)
                return
            }

            let oxygenLevels = results.map { $0.quantity.doubleValue(for: HKUnit.percent()) }
            let averageOxygen = oxygenLevels.isEmpty ? 0 : oxygenLevels.reduce(0, +) / Double(oxygenLevels.count)
            completion(averageOxygen)
        }

        healthStore.execute(query)
    }
}
