//
//  lsTrend.swift
//  LiquidSun
//
//  Created by Robert Carr on 11/3/19.
//  Copyright © 2019 TheCarrNation. All rights reserved.
//

import Foundation

public class lsTrend {
    private var sampleCount: Int = 0
    private var totalTemp: Double = 0.0
    private var totalHumidity: Double = 0.0
    private var totalApparentTemperature: Double = 0.0
    
    public var averageTemperature: Double { get { return totalTemp / Double(sampleCount)} }
    public var averageHumidity: Double { get { return totalHumidity / Double(sampleCount)} }
    public var averageApparentTemperature: Double { get { return totalApparentTemperature / Double(sampleCount)} }
    
    public func addWeatherPoint(temp: Double, humidity: Double, feelsLike: Double) {
        sampleCount += 1
        totalTemp += temp
        totalHumidity += humidity
        totalApparentTemperature += feelsLike
    }
}
