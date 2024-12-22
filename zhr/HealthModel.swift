//
//  Untitled.swift
//  zhr
//
//  Created by Mona on 15/12/2024.
//

import HealthKit

class HealthKitManager {
    private let healthStore = HKHealthStore()
    private let startDate = Calendar.current.startOfDay(for: Date())
    private let endDate = Date()

    private func fetchData(sampleType: HKSampleType, completion: @escaping (Double) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (_, results, error) in
            guard let results = results else {
                print("Error fetching data: \(String(describing: error))")
                completion(0)
                return
            }

            let total = results.reduce(0) { (sum, sample) in
                if let quantitySample = sample as? HKQuantitySample {
                    return sum + quantitySample.quantity.doubleValue(for: HKUnit.count())
                } else if let categorySample = sample as? HKCategorySample {
                    return sum + categorySample.endDate.timeIntervalSince(categorySample.startDate)
                }
                return sum
            }
            completion(total)
        }
        healthStore.execute(query)
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let typesToRead: Set<HKSampleType> = [
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

    func fetchSteps(completion: @escaping (Double) -> Void) {
        fetchData(sampleType: HKObjectType.quantityType(forIdentifier: .stepCount)!, completion: completion)
    }

    func fetchHeartRate(completion: @escaping (Double) -> Void) {
        fetchData(sampleType: HKObjectType.quantityType(forIdentifier: .heartRate)!) { total in
            completion(total / Double(60)) // Average heart rate per minute
        }
    }

    func fetchSleep(completion: @escaping (Double) -> Void) {
        fetchData(sampleType: HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!) { total in
            completion(total / 3600) // Return hours of sleep
        }
    }

    func fetchBloodOxygen(completion: @escaping (Double) -> Void) {
        fetchData(sampleType: HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!) { total in
            completion(total / Double(100)) // Average oxygen saturation
        }
    }
}
