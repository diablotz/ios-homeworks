//
//  CitiesPageViewControllerDelegate.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 06/08/26.
//

import Foundation

protocol CitiesPageViewControllerDelegate: AnyObject{
    func citiesPageViewController(
        _ controller: CitiesPageViewController,
        didChangePage index: Int
    )
}
