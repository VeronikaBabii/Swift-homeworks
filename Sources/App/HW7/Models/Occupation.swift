//
//  Occupation.swift
//
//  Created by Veronika Babii on 14.11.2021.
//

import Foundation
import Vapor

enum Occupation: String, Codable, Content {
    case medWorkerCovid = "med_worker_covid"
    case elderlyWorker = "elderly_worker"
    case soldiersAtWar = "soldiers_at_war"
    case medWorker = "med_worker"
    case socialWorkers = "social_workers"
    case criticalSecurityService = "critical_security_service"
    case education
    case prisonWorker = "prison_worker"
    case prisoner
    case other
}
