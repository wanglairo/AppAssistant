//
//  AssistantGPSViewController.swift
//  AppAssistant
//
//  Created by wangbao on 2020/10/10.
//

import CoreLocation
import Foundation
import MapKit

class AssistantGPSViewController: UIViewController {

    var mapView = MKMapView()
    var locationManager: CLLocationManager?
    var operateView = AssistantMockGPSOperateView()
    var inputGPSView = AssistantMockGPSInputView()
    var mapCenterView = AssistantMockGPSCenterView()

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }

    func initUI() {

        self.needBigTitleView = true
        self.assistant_setNavTitle(localizedString("模拟GPS"))

        operateView.switchView.isOn = AssistantCacheManager.shared.mockGPSSwitch()
        operateView.switchView.addTarget(self, action: #selector(switchAction), for: .touchUpInside)
        self.view.addSubview(operateView)
        operateView.snp.makeConstraints { (maker) in
            maker.left.equalTo(6.fitSizeFrom750Landscape)
            maker.top.equalTo(AssistantGPSViewController.bigTitleViewH + 24.fitSizeFrom750Landscape)
            maker.right.equalTo(0)
            maker.height.equalTo(124.fitSizeFrom750Landscape)
        }

        inputGPSView.delegate = self
        self.view.addSubview(inputGPSView)
        inputGPSView.snp.makeConstraints { (maker) in
            maker.left.equalTo(6.fitSizeFrom750Landscape)
            maker.top.equalTo(operateView.snp.bottom).offset(17.fitSizeFrom750Landscape)
            maker.right.equalTo(-6.fitSizeFrom750Landscape)
            maker.height.equalTo(170.fitSizeFrom750Landscape)
        }

        // 获取定位服务授权
        requestUserLocationAuthor()

        mapView.mapType = .standard
        mapView.delegate = self
        self.view.addSubview(mapView)
        self.view.sendSubviewToBack(mapView)
        mapView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(0)
        }

        self.mapView.addSubview(mapCenterView)
        mapCenterView.snp.makeConstraints { (maker) in
            maker.center.equalTo(mapView.snp.center)
            maker.size.equalTo(CGSize(width: 250.fitSizeFrom750, height: 250.fitSizeFrom750))
        }

        if operateView.switchView.isOn {
            let coordinate = AssistantCacheManager.shared.mockCoordinate()
            mapCenterView.hiddenGPSInfo(false)
            mapCenterView.renderUIWithGPS(String(format: "%f, %f", coordinate.longitude, coordinate.latitude))
            mapView.setCenter(coordinate, animated: false)
            let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            AssistantGPSMocker.shareInstance.mockPoint(location: loc)

        } else {
            mapCenterView.hiddenGPSInfo(true)
            AssistantGPSMocker.shareInstance.stopMockPoint()
        }
    }

    @objc
    func switchAction(sender: UISwitch) {
        let isButtonOn = sender.isOn
        AssistantCacheManager.shared.saveMockGPSSwitch(isButtonOn)

        if isButtonOn {
            let coordinate = CLLocationCoordinate2D()
            mapCenterView.hiddenGPSInfo(false)
            mapCenterView.renderUIWithGPS(String(format: "%f, %f", coordinate.longitude, coordinate.latitude))
            mapView.setCenter(coordinate, animated: false)

            let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            AssistantGPSMocker.shareInstance.mockPoint(location: loc)
        } else {
            mapCenterView.hiddenGPSInfo(true)
            AssistantGPSMocker.shareInstance.stopMockPoint()
        }
    }

    // 如果没有获得定位授权，获取定位授权请求
    func requestUserLocationAuthor() {
        locationManager = CLLocationManager()
        if CLLocationManager.locationServicesEnabled(), CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager?.requestWhenInUseAuthorization()
        }
    }
}

extension AssistantGPSViewController: AssistantMockGPSInputViewDelegate {
    func inputViewOkClick(gps: String) {
        if AssistantCacheManager.shared.mockGPSSwitch() == false {
            return
        }

        let array = gps.components(separatedBy: " ")
        if array.count == 2 {
            let longitudeValue = array[0]
            let latitudeValue = array[1]
            if longitudeValue.isEmpty || latitudeValue.isEmpty {
                return
            }
            let longitude = Float(longitudeValue) ?? 0
            let latitude = Float(latitudeValue) ?? 0
            if longitude < -180 || longitude > 180 {
                return
            }
            if latitude < -90 || latitude > 90 {
                return
            }

            var coordinate = CLLocationCoordinate2D()
            coordinate.latitude = CLLocationDegrees(latitude)
            coordinate.longitude = CLLocationDegrees(longitude)
            mapCenterView.hiddenGPSInfo(false)
            mapCenterView.renderUIWithGPS(String(format: "%f, %f", coordinate.longitude, coordinate.latitude))
            mapView.setCenter(coordinate, animated: false)

            let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            AssistantGPSMocker.shareInstance.mockPoint(location: loc)
        } else {
            return
        }
    }
}

extension AssistantGPSViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centerCoordinate = mapView.region.center

        if AssistantCacheManager.shared.mockGPSSwitch() == false {
            return
        }

        AssistantCacheManager.shared.saveMockCoordinate(centerCoordinate)
        mapCenterView.hiddenGPSInfo(false)
        mapCenterView.renderUIWithGPS(String(format: "%f, %f", centerCoordinate.longitude, centerCoordinate.latitude))

        let loc = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        AssistantGPSMocker.shareInstance.mockPoint(location: loc)
    }
}
