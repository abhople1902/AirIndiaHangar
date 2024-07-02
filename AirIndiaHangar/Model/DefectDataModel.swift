//
//  DefectDataModel.swift
//  AirIndiaHangar
//
//  Created by E5000848 on 01/07/24.
//

import Foundation
import UIKit
import CoreLocation

protocol CellContent {
    var defectName: String { get set }
    var image: UIImage { get set }
    var lat: CLLocationDegrees? { get set }
    var lon: CLLocationDegrees? { get set }
}

struct DefectDataModel: CellContent {
    var defectName: String
    var image: UIImage
    var lat: CLLocationDegrees?
    var lon: CLLocationDegrees?
}

struct TableDataSource {
    static var mainArr: [CellContent] = []
    var data: DefectDataModel?
    
    mutating func storeData(_ name: String, _ image: UIImage) {
        data = DefectDataModel(defectName: name, image: image)
    }
    
    static func getData() -> [CellContent] {
        return mainArr
    }
    
    mutating func addData(_ name: String, _ image: UIImage) -> [CellContent] {
        let tempObject = DefectDataModel(defectName: name, image: image)
        TableDataSource.mainArr.append(tempObject)
        return TableDataSource.mainArr
    }
    
    mutating func addData(_ name: String, _ image: UIImage, _ lat: CLLocationDegrees, _ lon: CLLocationDegrees) -> [CellContent]{
        return TableDataSource.mainArr
    }
}
