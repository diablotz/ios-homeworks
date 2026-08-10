//
//  SettingsViewControllerDelegate.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 07/08/26.
//

import Foundation
import UIKit


protocol SettingsViewControllerDelegate: AnyObject {
    
    func settingsViewController(_ controller: SettingsViewController, didChangeForecastDays days: Int)
}
