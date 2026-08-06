//
//  CitiesPageViewController.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 06/08/26.
//

import UIKit

final class CitiesPageViewController: UIPageViewController {

    private var pages: [CityWeatherViewController] = []
    
    weak var pageDelegate: CitiesPageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
    }

//    func setCities(_ cities: [City]) {
//
//        pages = cities.map {
//
//            CityWeatherViewController(city: $0)
//
//        }
//
//        guard let first = pages.first else { return }
//
//        setViewControllers(
//            [first],
//            direction: .forward,
//            animated: false
//        )
//    }
    
    func addCity(_ city: City) {
        
        let controller = CityWeatherViewController(city: city)
        
        pages.append(controller)
        
        if pages.count == 1 {
            
            setViewControllers(
                [controller],
                direction: .forward,
                animated: false
            )
        } else {
            setViewControllers(
                [controller],
                direction: .forward,
                animated: true
            )
        }
    }
    
    func configure(with cities: [City]) {
        
        pages.removeAll()
        
        for city in cities {
            pages.append(CityWeatherViewController(city: city))
        }
        
        guard let first = pages.first else {return}
        
        setViewControllers(
            [first],
            direction: .forward,
            animated: false
        )
    }
    
    
}

extension CitiesPageViewController:
UIPageViewControllerDataSource {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {

        guard

            let vc = viewController as? CityWeatherViewController,

            let index = pages.firstIndex(of: vc),

            index > 0

        else {

            return nil

        }

        return pages[index - 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {

        guard

            let vc = viewController as? CityWeatherViewController,

            let index = pages.firstIndex(of: vc),

            index < pages.count - 1

        else {

            return nil

        }

        return pages[index + 1]
    }
}

extension CitiesPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed,
              let current = viewControllers?.first as? CityWeatherViewController,
              let index = pages.firstIndex(of: current)
        else {
            return
        }
        
        pageDelegate?.citiesPageViewController(self, didChangePage: index)
        
    }
}



