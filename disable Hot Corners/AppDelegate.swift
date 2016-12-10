//
//  AppDelegate.swift
//  disable Hot Corners
//
//  Created by xjbeta on 2016/12/6.
//  Copyright © 2016年 xjbeta. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		disableHotCorners()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
	}
	
	func disableHotCorners() {
		if value(for: .buttomLeft) == 0 &&
			value(for: .buttomRight) == 0 &&
			value(for: .topLeft) == 0 &&
			value(for: .topRight) == 0 {
			
			enable()
		} else {
			disable()
		}
		NSSound(contentsOfFile: "/System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/system/payment_success.aif", byReference: true)?.play()
		DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .milliseconds(500)) {
			NSApp.terminate(self)
		}
	}
	
	
	
	// You can custom default hot corner
	func enable() {
		setValue(for: .buttomLeft, function: .missionControl)
		setValue(for: .buttomRight, function: .launchpad)
		setValue(for: .topLeft, function: .null)
		setValue(for: .topRight, function: .desktop)
		killDock()
	}
	
	
	func disable() {
		setValue(for: .buttomLeft, function: .null)
		setValue(for: .buttomRight, function: .null)
		setValue(for: .topLeft, function: .null)
		setValue(for: .topRight, function: .null)
		killDock()
	}
	
	
	
	
	
	func setValue(for corner: corner, function: function) {
		let task = Process()
		task.launchPath = "/usr/bin/defaults"
		task.currentDirectoryPath = Bundle.main.bundlePath
		
		task.arguments = ["write",
		                  dock,
		                  corner.rawValue,
		                  "-int",
		                  "\(function.rawValue)"]
		task.launch()
		task.waitUntilExit()
	}
	
	func killDock() {
		let task = Process()
		task.launchPath = "/usr/bin/killall"
		task.currentDirectoryPath = Bundle.main.bundlePath
		
		task.arguments = ["Dock"]
		task.launch()
		task.waitUntilExit()
	}
	
	
	
	
	func value(for corner: corner) -> Int {
		return UserDefaults.standard.persistentDomain(forName: "com.apple.dock")?[corner.rawValue] as? Int ?? -1
	}
	
	
	

}

let dock = "com.apple.dock"
enum corner: String {
	case buttomLeft = "wvous-bl-corner"
	case buttomRight = "wvous-br-corner"
	case topLeft = "wvous-tl-corner"
	case topRight = "wvous-tr-corner"
}

enum function: Int {
	case null = 0
	case missionControl = 2
	case applicationWindows = 3
	case desktop = 4
	case startScreenSaver = 5
	case disableScreenSaver = 6
	case dashboard = 7
	case putDisplayToSleep = 10
	case launchpad = 11
	case notificationCenter = 12
}
