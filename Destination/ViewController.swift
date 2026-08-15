//
//  ViewController.swift
//  Destination
//
//  Created by Timur Zakirov on 14/08/26.
//

import UIKit
import MapKit
import CoreLocation

final class ViewController: UIViewController {

    private let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        map.userTrackingMode = .follow
        return map
    }()
    
    private let routeButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Маршрут"
        config.baseBackgroundColor = .systemBlue
        config.image = UIImage(systemName: "arrow.triangle.turn.up.right.diamond.fill")
        config.imagePadding = 6
        let button = UIButton(configuration: config)
        return button
    }()
    
    private let clearButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Очистить"
        config.baseBackgroundColor = .systemRed
        config.baseForegroundColor = .white
        config.image = UIImage(systemName: "trash.fill")
        config.imagePadding = 6
        let button = UIButton(configuration: config)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        return stack
    }()
    
    // опциональная переменная для хранения текущей целевой точки
    private var destinationCoordinate: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupViews()
        setupActions()
        setupGesture()
    }
    
    private func setupViews() {
        view.addSubview(mapView)
        view.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(clearButton)
        buttonStackView.addArrangedSubview(routeButton)
        
        mapView.delegate = self
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupActions() {
        routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
    }
    
    // жест долгого нажатия
    private func setupGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.7 // время нажатия в секундах до срабатывания
        mapView.addGestureRecognizer(longPressGesture)
    }
    
    // Обработка долгого нажатия
    @objc private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        guard gestureRecognizer.state == .began else { return }
        
        // получаем точку касания на экране телефона
        let touchPoint = gestureRecognizer.location(in: mapView)
        
        // конвертируем точку экрана в географические координаты карты
        let targetCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        // присваиваем выбранную координату переменной для хранения текущей целевой точки
        self.destinationCoordinate = targetCoordinate
        
        // перед установкой новой точки очищаем старые маркеры и маршруты
        clearMap()
        
        // ставим новую точку на карте (Pin)
        let annotation = MKPointAnnotation()
        annotation.coordinate = targetCoordinate
        annotation.title = "Выбранное место"
        mapView.addAnnotation(annotation)
        
       
    }
    
    @objc private func routeButtonTapped() {
        triggerRouteCalculation()
        let alert = UIAlertController(title: "Маршрут до точки успешно построен", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        present(alert, animated: true)
    }
    
    // метод для запуска логики построения
    private func triggerRouteCalculation() {
        guard let userCoordinate = mapView.userLocation.location?.coordinate else {
            
            let alert = UIAlertController(title: "Ваше местоположение еще не определено", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            
            present(alert, animated: true)
            
            return
        }
        
        guard let destination = destinationCoordinate else {
            
            let alert = UIAlertController(title: "Поставьте точку на карте долгим нажатием", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            
            present(alert, animated: true)
            
            return
        }
        
        calculateRoute(from: userCoordinate, to: destination)
    }
    
    @objc private func clearButtonTapped() {
        clearMap()
        destinationCoordinate = nil // Сбрасываем сохраненную цель
    }
    
    
    private func clearMap() {
        mapView.removeOverlays(mapView.overlays)
        let userLocationAnnotation = mapView.userLocation
        let annotationsToRemove = mapView.annotations.filter { $0 !== userLocationAnnotation }
        mapView.removeAnnotations(annotationsToRemove)
    }
    
    private func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        mapView.removeOverlays(mapView.overlays)
        let request = MKDirections.Request()
        request.source = MKMapItem(location: CLLocation(latitude: source.latitude, longitude: source.longitude), address: nil)
        request.destination = MKMapItem(location: CLLocation(latitude: destination.latitude, longitude: destination.longitude), address: nil)
        request.requestsAlternateRoutes = true
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            guard let self = self, let route = response?.routes.first else { return }
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 60, left: 60, bottom: 100, right: 60), animated: true)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 6.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}


//import UIKit
//import MapKit
//import CoreLocation
//
//final class ViewController: UIViewController {
//
//    private let mapView: MKMapView = {
//        let map = MKMapView()
//        map.translatesAutoresizingMaskIntoConstraints = false
//        map.showsUserLocation = true
//        map.userTrackingMode = .follow
//        return map
//    }()
//    
//    // маршрут
//    private let routeButton: UIButton = {
//        var config = UIButton.Configuration.filled()
//        config.title = "Маршрут"
//        config.baseBackgroundColor = .systemBlue
//        config.image = UIImage(systemName: "arrow.triangle.turn.up.right.diamond.fill")
//        config.imagePadding = 6
//        let button = UIButton(configuration: config)
//        return button
//    }()
//    
//    // Очистить
//    private let clearButton: UIButton = {
//        var config = UIButton.Configuration.filled()
//        config.title = "Очистить"
//        config.baseBackgroundColor = .systemRed
//        config.baseForegroundColor = .white
//        config.image = UIImage(systemName: "trash.fill")
//        config.imagePadding = 6
//        let button = UIButton(configuration: config)
//        return button
//    }()
//    
//    // стек для размещения двух кнопок в ряд
//    private let buttonStackView: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .horizontal
//        stack.distribution = .fillEqually
//        stack.spacing = 12
//        return stack
//    }()
//    
//    private let destinationCoordinate = CLLocationCoordinate2D(latitude: 55.7228, longitude: 37.6173)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        
//        setupViews()
//        setupActions()
//        addDestinationPin()
//    }
//    
//    private func setupViews() {
//        view.addSubview(mapView)
//        view.addSubview(buttonStackView)
//        
//        // Добавляем кнопки в стек
//        buttonStackView.addArrangedSubview(clearButton)
//        buttonStackView.addArrangedSubview(routeButton)
//        
//        mapView.delegate = self
//        
//        NSLayoutConstraint.activate([
//            mapView.topAnchor.constraint(equalTo: view.topAnchor),
//            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            
//            
//            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
//            buttonStackView.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
//    
//    private func setupActions() {
//        routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
//        
//        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
//    }
//    
//    private func addDestinationPin() {
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = destinationCoordinate
//        annotation.title = "Пункт назначения"
//        mapView.addAnnotation(annotation)
//    }
//    // прокладывание маршрута
//    @objc private func routeButtonTapped() {
//        guard let userCoordinate = mapView.userLocation.location?.coordinate else { return }
//        calculateRoute(from: userCoordinate, to: destinationCoordinate)
//        let alert = UIAlertController(title: "Маршрут успешно построен", message: nil, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
//        present(alert, animated: true)
//    }
//    
//    // очистка карты
//    @objc private func clearButtonTapped() {
//        // Удаляем все линии и overlays (маршруты)
//        mapView.removeOverlays(mapView.overlays)
//        
//        // Удаляем все точки (Pins), КРОМЕ синей точки пользователя
//        let userLocationAnnotation = mapView.userLocation
//        let annotationsToRemove = mapView.annotations.filter { $0 !== userLocationAnnotation }
//        
//        mapView.removeAnnotations(annotationsToRemove)
//        
//        print("Карта успешно очищена от кастомных точек и маршрутов")
//        print(destinationCoordinate.latitude, destinationCoordinate.longitude)
//    }
//    
//    private func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
//        mapView.removeOverlays(mapView.overlays)
//        let request = MKDirections.Request()
//        request.source = MKMapItem(location: CLLocation(latitude: source.latitude, longitude: source.longitude), address: nil)
//        request.destination = MKMapItem(location: CLLocation(latitude: destination.latitude, longitude: destination.longitude), address: nil)
//        //request.transportType = .automobile
//        request.transportType = .walking
//        
//        let directions = MKDirections(request: request)
//        directions.calculate { [weak self] response, error in
//            guard let self = self, let route = response?.routes.first else { return }
//            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
//            let rect = route.polyline.boundingMapRect
//            self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 60, left: 60, bottom: 100, right: 60), animated: true)
//        }
//    }
//}
//
//extension ViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if let polyline = overlay as? MKPolyline {
//            let renderer = MKPolylineRenderer(polyline: polyline)
//            renderer.strokeColor = .systemBlue
//            renderer.lineWidth = 6.0
//            return renderer
//        }
//        return MKOverlayRenderer(overlay: overlay)
//    }
//}

//import UIKit
//import MapKit
//import CoreLocation
//
//final class ViewController: UIViewController {
//
//    // 1. Создаем карту
//    private let mapView: MKMapView = {
//        let map = MKMapView()
//        map.translatesAutoresizingMaskIntoConstraints = false
//        map.showsUserLocation = true
//        map.userTrackingMode = .follow
//        
//        let config = MKStandardMapConfiguration(elevationStyle: .realistic)
//        config.showsTraffic = true
//        map.preferredConfiguration = config
//        return map
//    }()
//    
//    private let routeButton: UIButton = {
//        var config = UIButton.Configuration.filled()
//        config.title = "Маршрут"
//        config.baseBackgroundColor = .systemBlue
//        config.image = UIImage(systemName: "arrow.triangle.turn.up.right.diamond.fill")
//        config.imagePadding = 6
//        let button = UIButton(configuration: config)
//        return button
//    }()
//    
//    // 1. Создаем кнопку Очистить
//    private let clearButton: UIButton = {
//        var config = UIButton.Configuration.filled()
//        config.title = "Очистить"
//        config.baseBackgroundColor = .systemRed // Красный цвет для удаления
//        config.baseForegroundColor = .white
//        config.image = UIImage(systemName: "trash.fill")
//        config.imagePadding = 6
//        let button = UIButton(configuration: config)
//        return button
//    }()
//    
//    // Стек для удобного размещения двух кнопок в ряд
//    private let buttonStackView: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .horizontal
//        stack.distribution = .fillEqually
//        stack.spacing = 12
//        return stack
//    }()
//    
//    // Целевая точка для маршрута
//    private let destinationCoordinate = CLLocationCoordinate2D(latitude: 55.7228, longitude: 37.6173)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        
//        setupViews()
//        setupActions()
//        addDestinationPin()
//    }
//    
//    // Размещение элементов на экране
//    private func setupViews() {
//        view.addSubview(mapView)
//        view.addSubview(buttonStackView)
//        
//        mapView.delegate = self
//        
//        NSLayoutConstraint.activate([
//            // Карта на весь экран
//            mapView.topAnchor.constraint(equalTo: view.topAnchor),
//            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            
//            // Кнопка внизу экрана с отступами
//            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
//            buttonStackView.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
//    
//    private func setupActions() {
//        // Привязываем нажатие кнопки к методе прокладки маршрута
//        routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
//        
//        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
//    }
//    
//    // Добавление маркера цели на карту
//    private func addDestinationPin() {
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = destinationCoordinate
//        annotation.title = "Пункт назначения"
//        mapView.addAnnotation(annotation)
//    }
//    
//    // Логика нажатия на кнопку
//    @objc private func routeButtonTapped() {
//        // Проверяем, определила ли карта геопозицию (синюю точку)
//        guard let userCoordinate = mapView.userLocation.location?.coordinate else {
//            print("Не удалось определить ваше местоположение")
//            return
//        }
//        
//        calculateRoute(from: userCoordinate, to: destinationCoordinate)
//    }
//    @objc private func clearButtonTapped() {
//        // Удаляем все линии и overlays (маршруты)
//        mapView.removeOverlays(mapView.overlays)
//        
//        // Удаляем все точки (Pins), КРОМЕ синей точки пользователя
//        let userLocationAnnotation = mapView.userLocation
//        let annotationsToRemove = mapView.annotations.filter { $0 !== userLocationAnnotation }
//        
//        mapView.removeAnnotations(annotationsToRemove)
//        
//        print("Карта успешно очищена от кастомных точек и маршрутов")
//    }
//    
//    // Расчет маршрута (актуально для iOS 26+)
//    private func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
//        mapView.removeOverlays(mapView.overlays)
//        
//        let request = MKDirections.Request()
//        
//        let sourceLocation = CLLocation(latitude: source.latitude, longitude: source.longitude)
//        let destinationLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
//        
//        
//        request.source = MKMapItem(location: sourceLocation, address: nil)
//        request.destination = MKMapItem(location: destinationLocation, address: nil)
//        //request.transportType = .automobile
//        request.requestsAlternateRoutes = true
//        request.transportType = .walking
//        let directions = MKDirections(request: request)
//        directions.calculate { [weak self] response, error in
//            guard let self = self else { return }
//            
//            if let error = error {
//                print("Ошибка расчета маршрута: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let route = response?.routes.first else { return }
//            
//            // Добавляем линию маршрута поверх дорог
//            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
//            
//            // Красиво масштабируем карту, оставляя нижний отступ больше (bottom: 100),
//            // чтобы маршрут не перекрывался нашей кнопкой
//            let rect = route.polyline.boundingMapRect
//            let padding = UIEdgeInsets(top: 60, left: 60, bottom: 100, right: 60)
//            self.mapView.setVisibleMapRect(rect, edgePadding: padding, animated: true)
//        }
//    }
//}
//
//// MARK: - MKMapViewDelegate
//extension ViewController: MKMapViewDelegate {
//    
//    // Отрисовка линии маршрута
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if let polyline = overlay as? MKPolyline {
//            let renderer = MKPolylineRenderer(polyline: polyline)
//            renderer.strokeColor = .systemBlue
//            renderer.lineWidth = 6.0
//            return renderer
//        }
//        return MKOverlayRenderer(overlay: overlay)
//    }
//}


//import UIKit
//import MapKit
//import CoreLocation
//import _LocationEssentials
//
//final class ViewController: UIViewController {
//
//    // 1. Создаем карту с кастомным внешним видом
//    private let mapView: MKMapView = {
//        let map = MKMapView()
//        map.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Настройка внешнего вида карты через свойства MKMapView
//        map.showsUserLocation = true // Включает отображение синей точки пользователя
//        map.userTrackingMode = .follow // Карта автоматически центрируется на пользователе
//        
//        // Конфигурация деталей (iOS 13+)
//        let config = MKStandardMapConfiguration(elevationStyle: .realistic)
//        config.showsTraffic = true // Показывать пробки
//        config.pointOfInterestFilter = .includingAll // Показывать все интересные места
//        map.preferredConfiguration = config
//        
//        return map
//    }()
//    
//    // Координаты целевой точки (куда прокладываем маршрут)
//    // Для примера возьмем случайную точку рядом
//    private let destinationCoordinate = CLLocationCoordinate2D(latitude: 54.7558, longitude: 37.6173)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        
//        setupMapView()
//        addDestinationPin()
//        
//        // Маршрут строим после того, как карта загрузится и определит геопозицию пользователя
//        NotificationCenter.default.addObserver(self, selector: #selector(routeWhenReady), name: .init("LocationUpdated"), object: nil)
//    }
//    
//    private func setupMapView() {
//        view.addSubview(mapView)
//        mapView.delegate = self // Обязательно для отрисовки линий overlay
//        
//        NSLayoutConstraint.activate([
//            mapView.topAnchor.constraint(equalTo: view.topAnchor),
//            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    // 2. Установка Pin (маркера) на карту
//    private func addDestinationPin() {
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = destinationCoordinate
//        annotation.title = "Конечная точка"
//        annotation.subtitle = "Сюда мы проложим маршрут"
//        mapView.addAnnotation(annotation)
//    }
//    
//    @objc private func routeWhenReady() {
//        // Проверяем, определились ли координаты пользователя
//        guard let userCoordinate = mapView.userLocation.location?.coordinate else { return }
//        calculateRoute(from: userCoordinate, to: destinationCoordinate)
//    }
//    
//    // 3. Расчет и прокладывание маршрута
//    private func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
//        // Очищаем старые маршруты
//        mapView.removeOverlays(mapView.overlays)
//        
//        let request = MKDirections.Request()
//        
//        // 1. Преобразуем CLLocationCoordinate2D в объекты CLLocation
//        let sourceLocation = CLLocation(latitude: source.latitude, longitude: source.longitude)
//        let destinationLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
//        
//        // 2. Создаем MKMapItem напрямую через актуальный init(location:address:) для iOS 26+
//        // Мы передаем CLLocation, а адрес оставляем nil
//        let sourceMapItem = MKMapItem(location: sourceLocation, address: nil)
//        let destinationMapItem = MKMapItem(location: destinationLocation, address: nil)
//        
//        // 3. Передаем созданные элементы в запрос
//        request.source = sourceMapItem
//        request.destination = destinationMapItem
//        request.transportType = .automobile
//        
//        let directions = MKDirections(request: request)
//        directions.calculate { [weak self] response, error in
//            guard let self = self else { return }
//            
//            if let error = error {
//                print("Ошибка расчета маршрута: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let route = response?.routes.first else { return }
//            
//            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
//            
//            let rect = route.polyline.boundingMapRect
//            // Устанавливаем отступы по 50 поинтов со всех сторон (сверху, слева, снизу, справа)
//            let padding = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
//            self.mapView.setVisibleMapRect(rect, edgePadding: padding, animated: true)
//        }
//    }
//
//
//}
//
//// MARK: - MKMapViewDelegate
//extension ViewController: MKMapViewDelegate {
//    
//    // Этот метод отвечает за внешний вид линии маршрута на карте
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if let polyline = overlay as? MKPolyline {
//            let renderer = MKPolylineRenderer(polyline: polyline)
//            renderer.strokeColor = .systemBlue // Цвет линии маршрута
//            renderer.lineWidth = 5.0           // Толщина линии
//            return renderer
//        }
//        return MKOverlayRenderer(overlay: overlay)
//    }
//    // Метод срабатывает, когда карта успешно определила вашу позицию
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        // Задаем масштаб: 0.05 — это примерно радиус в несколько километров
//        let region = MKCoordinateRegion(
//            center: userLocation.coordinate,
//            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        )
//        // Плавно перемещаем камеру к синей точке
//        mapView.setRegion(region, animated: true)
//    }
//}
//
//// Вспомогательное расширение для красивых отступов при масштабировании
//extension MKMapRect {
//    func region(withPadding padding: CGFloat) -> MKCoordinateRegion {
//        var region = MKCoordinateRegion(self)
//        region.span.latitudeDelta *= 1.3
//        region.span.longitudeDelta *= 1.3
//        return region
//    }
//}
