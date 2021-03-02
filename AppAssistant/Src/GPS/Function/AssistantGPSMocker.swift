//
//  AssistantGPSMocker.swift
//  AppAssistant
//
//  Created by wangbao on 2020/10/14.
//

import CoreLocation
import Foundation

class AssistantGPSMocker: NSObject {

    var isMocking: Bool = false
    var locationMonitor: NSMapTable<AnyObject, AnyObject>?
    var oldLocation: CLLocation?
    var pointLocation: CLLocation?
    var simTimer: Timer?

    static let shareInstance = AssistantGPSMocker()

    override init() {
        super.init()

        locationMonitor = NSMapTable.strongToWeakObjects()
    }

    func startHookDelegate() {
        DispatchQueue.once(token: "assistantGPSMocker") {
            CLLocationManager.assistant_swizzleInstanceMethodWithOriginSel(
                oriSel: #selector(setter: CLLocationManager.delegate),
                swiSel: #selector(CLLocationManager.assistant_SwizzleLocationDelegate(delegate:)))
        }
    }

    func addLocationBinder(binder: AnyObject, delegate: AnyObject) {
        let binderKey = NSString(format: "%p_binder", binder as? CVarArg ?? Int(bitPattern: 0))
        let delegateKey = NSString(format: "%p_delegate", binder as? CVarArg ?? Int(bitPattern: 0))
        locationMonitor?.setObject(binder, forKey: binderKey)
        locationMonitor?.setObject(delegate, forKey: delegateKey)
    }

    func mockPoint(location: CLLocation) {
        isMocking = true
        pointLocation = location
        pointMock()
//        if (simTimer != nil) {
//            pointMock()
//        } else {
//            simTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(pointMock), userInfo: nil, repeats: true)
//            simTimer?.fire()
//        }
    }

    @objc
    func pointMock() {
        let coordinate2DLatitude = self.pointLocation?.coordinate.latitude ?? 0
        let coordinate2DLogitude = self.pointLocation?.coordinate.longitude ?? 0

        let mockLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: coordinate2DLatitude, longitude: coordinate2DLogitude),
                                      altitude: 0,
                                      horizontalAccuracy: 5,
                                      verticalAccuracy: 5,
                                      timestamp: Date())
        self.dispatchLocationsToAll(locations: [mockLocation])
    }

    func dispatchLocationsToAll(locations: [ CLLocation]) {
        guard let enumerator = locationMonitor?.keyEnumerator() else {
            return
        }
        for key in enumerator.allObjects {
            let keyString = key as? String ?? ""
            if keyString.hasSuffix("_binder") {
                let keyStringTmp = NSString(string: keyString)
                let binderManager = locationMonitor?.object(forKey: keyStringTmp)
                self.dispatchLocationUpdate(manager: binderManager as? CLLocationManager ?? CLLocationManager(), locations: locations)
            }
        }

    }

    func stopMockPoint() {
        isMocking = false
        if simTimer != nil {
            simTimer?.invalidate()
            simTimer = nil
        }
    }

    func enumDelegate(manager: CLLocationManager, block: (CLLocationManagerDelegate?) -> Void) {
        let keyString = NSString(format: "%p_delegate", manager)
        let delegate = locationMonitor?.object(forKey: keyString) as? CLLocationManagerDelegate
        if delegate != nil {
            block(delegate)
        }
    }
}

extension AssistantGPSMocker: CLLocationManagerDelegate {

//    func locationManager(_ manager: CLLocationManager,
//                         didUpdateToLocation newLocation: CLLocation,
//                         fromLocation oldLocation: CLLocation) {
//
//    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if isMocking {
            let coordinate2DLatitude = AssistantGPSMocker.shareInstance.pointLocation?.coordinate.latitude ?? 0
            let coordinate2DLogitude = AssistantGPSMocker.shareInstance.pointLocation?.coordinate.longitude ?? 0
            let mockLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: coordinate2DLatitude, longitude: coordinate2DLogitude),
                                          altitude: 0,
                                          horizontalAccuracy: 5,
                                          verticalAccuracy: 5,
                                          timestamp: Date())
            self.enumDelegate(manager: manager) { (delegate) in
                delegate?.locationManager?(manager, didUpdateLocations: [mockLocation])
            }
        } else {
            self.enumDelegate(manager: manager) { (delegate) in
                delegate?.locationManager?(manager, didUpdateLocations: locations)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.enumDelegate(manager: manager) { (delegate) in
            delegate?.locationManager?(manager, didUpdateHeading: newHeading)
        }
    }

    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        var ret = false
        self.enumDelegate(manager: manager) { (delegate) in
            ret = ((delegate?.locationManagerShouldDisplayHeadingCalibration?(manager)) != nil)
        }
        return ret
    }

    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        self.enumDelegate(manager: manager) { (delegate) in
            delegate?.locationManager?(manager, didDetermineState: state, for: region)
        }
    }

    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        self.enumDelegate(manager: manager) { (delegate) in
            delegate?.locationManager?(manager, rangingBeaconsDidFailFor: region, withError: error)
        }
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        self.enumDelegate(manager: manager) { (delegate) in
            delegate?.locationManager?(manager, didRangeBeacons: beacons, in: region)
        }
    }

    @available(iOS 13.0, *)
    func locationManager(_ manager: CLLocationManager, didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint, error: Error) {
        self.enumDelegate(manager: manager) { (delegate) in
            delegate?.locationManager?(manager, didFailRangingFor: beaconConstraint, error: error)
        }
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.enumDelegate(manager: manager) { (delegate) in
            delegate?.locationManager?(manager, didEnterRegion: region)
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        self.enumDelegate(manager: manager) { (delegate) in
            delegate?.locationManager?(manager, didExitRegion: region)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.enumDelegate(manager: manager) { (delegate) in
            delegate?.locationManager?(manager, didFailWithError: error)
        }
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        self.enumDelegate(manager: manager) { (delegate) in
            delegate?.locationManager?(manager, monitoringDidFailFor: region, withError: error)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.enumDelegate(manager: manager) { (delegate) in
            delegate?.locationManager?(manager, didChangeAuthorization: status)
        }
    }

    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        self.enumDelegate(manager: manager) { (delegate) in
            delegate?.locationManager?(manager, didStartMonitoringFor: region)
        }
    }

    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        self.enumDelegate(manager: manager) { (delegate) in
            delegate?.locationManagerDidPauseLocationUpdates?(manager)
        }
    }

    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        self.enumDelegate(manager: manager) { (delegate) in
            delegate?.locationManagerDidResumeLocationUpdates?(manager)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        self.enumDelegate(manager: manager) { (delegate) in
            delegate?.locationManager?(manager, didFinishDeferredUpdatesWithError: error)
        }
    }

    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        self.enumDelegate(manager: manager) { (delegate) in
            delegate?.locationManager?(manager, didVisit: visit)
        }
    }

    func dispatchLocationUpdate(manager: CLLocationManager, locations: [CLLocation]) {
        let keyString = NSString(format: "%p_delegate", manager)
        let delegate = locationMonitor?.object(forKey: keyString) as? CLLocationManagerDelegate
        delegate?.locationManager?(manager, didUpdateLocations: locations)
    }
}
