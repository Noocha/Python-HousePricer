//
//  PredictViewController.swift
//  HousePricePrediction
//
//  Created by Nattagan Ananpech on 23/11/19.
//  Copyright © 2019 nooch. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import PickerView
import CDAlertView
import MapKit
import CoreLocation
import NVActivityIndicatorView
class PredictViewController: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet weak var tfBathroom: SkyFloatingLabelTextField!
    @IBOutlet weak var tfBedroom: SkyFloatingLabelTextField!
    @IBOutlet weak var tfLiving: SkyFloatingLabelTextField!
    @IBOutlet weak var tfLandSpace: SkyFloatingLabelTextField!
    @IBOutlet weak var tfFloor: SkyFloatingLabelTextField!
    @IBOutlet weak var tfWaterfront: SkyFloatingLabelTextField!
    @IBOutlet weak var tfView: SkyFloatingLabelTextField!
    @IBOutlet weak var tfCondition: SkyFloatingLabelTextField!
    @IBOutlet weak var tfGrade: SkyFloatingLabelTextField!
    @IBOutlet weak var tfAbove: SkyFloatingLabelTextField!
    @IBOutlet weak var tfBasement: SkyFloatingLabelTextField!
    @IBOutlet weak var tfYearBuilt: SkyFloatingLabelTextField!
    @IBOutlet weak var tfRenovated: SkyFloatingLabelTextField!
    
    @IBOutlet weak var hPriceConst: NSLayoutConstraint!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var hMapConst: NSLayoutConstraint!
    let locationManager = CLLocationManager()
    
    var currentLocation = CLLocation()
    var textFields: [SkyFloatingLabelTextField] = []
    
    let housePricer = HousePricer()
    let housePricerLatLong = HouseLatLongPricer()
    
    let lightGreyColor: UIColor = UIColor(red: 197 / 255, green: 205 / 255, blue: 205 / 255, alpha: 1.0)
    let darkGreyColor: UIColor = UIColor(red: 52 / 255, green: 42 / 255, blue: 61 / 255, alpha: 1.0)
    let overcastBlueColor: UIColor = UIColor(red: 0, green: 187 / 255, blue: 204 / 255, alpha: 1.0)
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceImg: UIImageView!
    static let urlString = "http://35.238.18.154:5000"
    let bedrooms: [String] = {
         var numbers = [String]()
         
         for index in 0...100 {
             numbers.append(String(index))
         }

         return numbers
     }()
    //มองเห็นแม่น้ำ Y, N
    let waterfronts = ["No waterfront", "Waterfront"]
    
    //ทิวทัศน์ 0-4
    let views = ["Poor", "Fair", "Average", "Good", "Excellent"]
    
    //สภาพบ้าน 1-5
    let conditions = ["Poor", "Fair", "Average", "Good", "Excellent"]
        
        //การก่อสร้างและdesign
    //    1-3 fall
    //    7 average
    //    11-13 high quality
    let grades: [String] = {
        var numbers = [String]()
        for index in 1...13 {
            numbers.append(String(index))
        }
        return numbers
    }()

    let yearbuild: [String] = {
        var numbers = [String]()
        for index in 1900...2015 {
            numbers.append(String(index))
        }
        numbers.insert("Unknown", at: 0)
        return numbers
    }()
    
    @IBOutlet weak var scrollView: UIScrollView!
    let renovated = ["No", "Yes"]

    
    @IBOutlet weak var mapIconImage: UIImageView!
    let theme = YBTextPickerAppearanceManager.init (
           pickerTitle         : "Pick item",
           titleFont           : UIFont.boldSystemFont(ofSize: 16),
           titleTextColor      : .white,
           titleBackground     : nil,
           searchBarFont       : UIFont.systemFont(ofSize: 16),
           searchBarPlaceholder: "Search",
           closeButtonTitle    : "Cancel",
           closeButtonColor    : .darkGray,
           closeButtonFont     : UIFont.systemFont(ofSize: 16),
           doneButtonTitle     : "Okay",
           doneButtonColor     : nil,
           doneButtonFont      : UIFont.boldSystemFont(ofSize: 16),
           checkMarkPosition   : .Right,
           itemCheckedImage    : nil,
           itemUncheckedImage  : nil,
           itemColor           : .black,
           itemFont            : UIFont.systemFont(ofSize: 16)
       )

    
    var house: HouseModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationLabel.text = ""
        locationLabel.textColor = darkGreyColor
        locationLabel.font = UIFont.systemFont(ofSize: 13)
        
        priceLabel.text = ""
        priceLabel.textColor = darkGreyColor
        priceLabel.font = UIFont.boldSystemFont(ofSize: 19)
        priceImg.isHidden = true
        hPriceConst.constant = 0
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        // Do any additional setup after loading the view.
        textFields = [tfBathroom, tfLandSpace, tfFloor, tfAbove, tfBasement, tfBedroom, tfYearBuilt, tfRenovated, tfView, tfCondition, tfLandSpace, tfGrade]

        for textField in textFields {
            textField.delegate = self
        }

        house = HouseModel()
        house.getDate()
        setUpTextFields()
    }
    func setUpTextFields() {
 
        tfBedroom.placeholder = "Number of Bedroom"
        tfBedroom.selectedTitle = "Number of Bedroom"
        tfBedroom.title = "Number of Bedroom"
        
        tfBathroom.placeholder = "Number of Bathroom"
        tfBathroom.selectedTitle = "Number of Bathroom"
        tfBathroom.title = "Number of Bathroom"
        
        tfLiving.placeholder = "Square footage of interior living space"
        tfLiving.selectedTitle = "Square footage of interior living space"
        tfLiving.title = "Square footage of interior living space"

        tfLandSpace.placeholder = "Square footage of the land space"
        tfLandSpace.selectedTitle = "Square footage of the land space"
        tfLandSpace.title = "Square footage of the land space"

        tfFloor.placeholder = "Number of Floor"
        tfFloor.selectedTitle = "Number of Floor"
        tfFloor.title = "Number of Floor"

        tfWaterfront.placeholder = "Waterfront"
        tfWaterfront.selectedTitle = "Waterfront"
        tfWaterfront.title = "Waterfront"

        tfView.placeholder = "How good the view of the property was"
        tfView.selectedTitle = "How good the view of the property was"
        tfView.title = "How good the view of the property was"

        //สภาพบ้าน
        tfCondition.placeholder = "Condition"
        tfCondition.selectedTitle = "Condition"
        tfCondition.title = "Condition"

        tfGrade.placeholder = "Building construction and design"
        tfGrade.selectedTitle = "How good the view of the property was"
        tfGrade.title = "How good the view of the property was"

        tfAbove.placeholder = "Sqft of interior housing space above ground level"
        tfAbove.selectedTitle = "(Sqft)Interior housing space above ground"
        tfAbove.title = "(Sqft)Interior housing space above ground"

        tfBasement.placeholder = "Sqft of the interior housing space below ground level"
        tfBasement.selectedTitle = "(Sqft)Interior housing space below ground"
        tfBasement.title = "(Sqft)Interior housing space below ground"

        tfYearBuilt.placeholder = "Year built"
        tfYearBuilt.selectedTitle = "Year built"
        tfYearBuilt.title = "Year built"

        tfRenovated.placeholder = "Renovated?"
        tfRenovated.selectedTitle = "Renovated?"
        tfRenovated.title = "Renovated?"

        //set Default value
        tfBedroom.text = ""
        tfBathroom.text = ""
        tfLiving.text = ""
        tfLandSpace.text = ""
        tfFloor.text = ""
        tfWaterfront.text = ""
        tfView.text = ""
        tfCondition.text = ""
        tfGrade.text = ""
        tfAbove.text = ""
        tfBasement.text = ""
        tfYearBuilt.text = ""
        tfRenovated.text = ""

        //set theme
        applySkyscannerTheme(textField: tfBedroom)
        applySkyscannerTheme(textField: tfBathroom)
        applySkyscannerTheme(textField: tfLiving)
        applySkyscannerTheme(textField: tfLandSpace)
        applySkyscannerTheme(textField: tfFloor)
        applySkyscannerTheme(textField: tfWaterfront)
        applySkyscannerTheme(textField: tfView)
        applySkyscannerTheme(textField: tfCondition)
        applySkyscannerTheme(textField: tfGrade)
        applySkyscannerTheme(textField: tfAbove)
        applySkyscannerTheme(textField: tfBasement)
        applySkyscannerTheme(textField: tfYearBuilt)
        applySkyscannerTheme(textField: tfRenovated)

    }
    
    func applySkyscannerTheme(textField: SkyFloatingLabelTextField) {
        textField.backgroundColor = .clear

        textField.tintColor = overcastBlueColor

        textField.textColor = darkGreyColor
        textField.lineColor = lightGreyColor

        textField.selectedTitleColor = overcastBlueColor
        textField.selectedLineColor = overcastBlueColor

        textField.placeholderFont = UIFont.systemFont(ofSize: 12)
        textField.titleFont = UIFont.systemFont(ofSize: 13)
 
      }
    
    @IBAction func chooseBedroom(_ sender: Any) {
           let arrTheme = bedrooms
           let picker = YBTextPicker.init(with: arrTheme, appearance: theme, onCompletion: { (selectedIndexes, selectedValues) in
               if let selectedValue = selectedValues.first {
                self.tfBedroom.text = selectedValue
               } else {
                self.tfBedroom.text = ""
               }
            
           }, onCancel: {
               
           })
           picker.show(withAnimation: .FromBottom)
    }
    

    @IBAction func chooseWaterfront(_ sender: Any) {
        let arrTheme = waterfronts
        let picker = YBTextPicker.init(with: arrTheme, appearance: theme, onCompletion: { (selectedIndexes, selectedValues) in
                if let selectedValue = selectedValues.first {
                    self.tfWaterfront.text = selectedValue
                } else {
                    self.tfWaterfront.text = ""
                }
            }, onCancel: {
        })
        picker.show(withAnimation: .FromBottom)
    }
    @IBAction func chooseView(_ sender: Any) {
        let arrTheme = views
        let picker = YBTextPicker.init(with: arrTheme, appearance: theme, onCompletion: { (selectedIndexes, selectedValues) in
                if let selectedValue = selectedValues.first {
                    self.tfView.text = selectedValue
                } else {
                    self.tfView.text = ""
                }
            }, onCancel: {
        })
        picker.show(withAnimation: .FromBottom)
    }
    @IBAction func chooseCondition(_ sender: Any) {
        let arrTheme = conditions
        let picker = YBTextPicker.init(with: arrTheme, appearance: theme, onCompletion: { (selectedIndexes, selectedValues) in
                if let selectedValue = selectedValues.first {
                    self.tfCondition.text = selectedValue
                } else {
                    self.tfCondition.text = ""
                }
            }, onCancel: {
        })
        picker.show(withAnimation: .FromBottom)
    }
    
    
    @IBAction func chooseGrade(_ sender: Any) {
        let arrTheme = grades
        let picker = YBTextPicker.init(with: arrTheme, appearance: theme, onCompletion: { (selectedIndexes, selectedValues) in
                if let selectedValue = selectedValues.first {
                    self.tfGrade.text = selectedValue
                } else {
                    self.tfGrade.text = ""
                }
            }, onCancel: {
        })
        picker.show(withAnimation: .FromBottom)
    }
    @IBAction func chooseYearBuilt(_ sender: Any) {
        let arrTheme = yearbuild
        let picker = YBTextPicker.init(with: arrTheme, appearance: theme, onCompletion: { (selectedIndexes, selectedValues) in
                if let selectedValue = selectedValues.first {
                    self.tfYearBuilt.text = selectedValue
                } else {
                    self.tfYearBuilt.text = ""
                }
            }, onCancel: {
        })
        picker.show(withAnimation: .FromBottom)
    }
    @IBAction func chooseRenovated(_ sender: Any) {
        let arrTheme = renovated
        let picker = YBTextPicker.init(with: arrTheme, appearance: theme, onCompletion: { (selectedIndexes, selectedValues) in
                if let selectedValue = selectedValues.first {
                    self.tfRenovated.text = selectedValue
                } else {
                    self.tfRenovated.text = ""
                }
            }, onCancel: {
        })
        picker.show(withAnimation: .FromBottom)
    }
    
    @IBAction func predict(_ sender: Any) {
        
        if currentLocation.coordinate.latitude == 0 {
            print(currentLocation)
            let alert = CDAlertView(title: "Oops", message: "This Prediction need your current location", type: .warning)
            let doneAction = CDAlertViewAction(title: "OK")
            alert.add(action: doneAction)
            alert.show()
            return
        }
        
        for textfield in textFields {
            if textfield.text == "" {
                let alert = CDAlertView(title: "Oops", message: "Please fill your data!!", type: .warning)
                let doneAction = CDAlertViewAction(title: "OK")
                alert.add(action: doneAction)
                alert.show()
                return
            }
        }

        let formatter = NumberFormatter()
        formatter.locale = Locale.current // USA: Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        
        let index = find(value: tfBedroom.text ?? "", in: bedrooms)
        house.bedroom = Double(index ?? 0)
        
        guard let bt = formatter.number(from: tfBathroom.text ?? "") else { return }
        house.bathroom = bt.doubleValue
        
        guard let living = formatter.number(from: tfLiving.text ?? "") else { return }
        house.living = living.doubleValue
        
        guard let land = formatter.number(from: tfLandSpace.text ?? "") else { return }
        house.landspace = land.doubleValue
        
        
        let wfindex = find(value: tfWaterfront.text ?? "", in: waterfronts)
        house.waterfront = Double(wfindex ?? 0)
        
        guard let above = formatter.number(from: tfAbove.text ?? "") else { return }
        house.above = above.doubleValue
        
        guard let basement = formatter.number(from: tfBasement.text ?? "") else { return }
        house.basement = basement.doubleValue
        
        guard let flr = formatter.number(from: tfFloor.text ?? "") else { return }
        house.floor = flr.doubleValue
   
        let viewindex = find(value: tfView.text ?? "", in: views)
        house.view = Double(viewindex ?? 0)
        
        var conindex = find(value: tfCondition.text ?? "", in: conditions)
        conindex = (conindex ?? 0) + 1
        house.condition = Double(conindex ?? 0)
        
        var gindex = find(value: tfGrade.text ?? "", in: grades)
        gindex = (gindex ?? 0) + 1
        house.grade = Double(gindex ?? 0)
        
        if tfYearBuilt.text?.lowercased() == "unknown" {
            house.yrsBuilt = 0
        } else {
            guard let year = formatter.number(from: tfYearBuilt.text ?? "") else { return }
            house.yrsBuilt = year.doubleValue
        }
        
        let renoindex = find(value: tfRenovated.text ?? "", in: renovated)
        house.renovate = renoindex == 0 ? 0 : 1

        
        let dict = ["bedrooms": house.bedroom,
                    "bathrooms": house.bathroom,
                    "sqft_living": house.living,
                    "sqft_lot": house.landspace,
                    "floors": house.floor,
                    "waterfront": house.waterfront,
                    "view": house.view,
                    "condition": house.condition,
                    "grade": house.grade,
                    "sqft_above": house.above,
                    "sqft_basement": house.basement,
                    "yr_built": house.yrsBuilt,
                    "renovated": house.renovate,
                    "lat": currentLocation.coordinate.latitude,
                    "long": currentLocation.coordinate.longitude]
        
        startAnimate()
        
        self.priceLabel.text = ""
        self.hPriceConst.constant = 0
        self.priceImg.isHidden = true
        
        var request = URLRequest(url: URL(string: PredictViewController.urlString)!)
              request.httpMethod = "POST"
              request.httpBody = try? JSONSerialization.data(withJSONObject: dict, options: [])
              request.addValue("application/json", forHTTPHeaderField: "Content-Type")

              let session = URLSession.shared
              let task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error -> Void in
                guard let self = self else { return }
                
                  print(response!)
                  self.stopAnimating()
                  do {
                      let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                      print(json)
                    if let price = json["data"] {
                        DispatchQueue.main.async {
                            self.priceLabel.text = "$\(price)"
                            self.hPriceConst.constant = 100
                            self.priceImg.isHidden = false
                        }
                    }
                    
                  } catch {
                    print("error")
//                    self.popupError()
                  }
              })

              task.resume()

    }
    
    func popupError() {
        let alert = CDAlertView(title: "Oops", message: "Something went wrong!!", type: .error)
                      let doneAction = CDAlertViewAction(title: "OK")
                      alert.add(action: doneAction)
                      alert.show()
    }
    
    
    func popupPrice(price: AnyObject) {
        
//        let alert = CDAlertView(title: "Result", message: "House Price is:", type: .success)
//            let doneAction = CDAlertViewAction(title: "OK")
//            alert.add(action: doneAction)
//            alert.show()
                    
        
//
//         let alert = CDAlertView(title: "Result", message: "House Price is: \(price)", type: .success)
//         let doneAction = CDAlertViewAction(title: "OK")
//         alert.add(action: doneAction)
//         alert.show()
//
    }
    func startAnimate() {
        startAnimating(CGSize.init(width: 60, height: 60),
                       message: "Predicting..",
                       messageFont: UIFont.systemFont(ofSize: 13),
                       type: .triangleSkewSpin,
                       color: UIColor.init(red: 249/255, green: 174/255, blue: 41/255, alpha: 1.0),
                       padding: 0.4,
                       displayTimeThreshold: 0,
                       minimumDisplayTime: 0,
                       backgroundColor: UIColor.init(white: 0.2, alpha: 0.6),
                       textColor: .white,
                       fadeInAnimation: .none)
        
    }
    
    func find(value searchValue: String, in array: [String]) -> Int? {
        for (index, value) in array.enumerated() {
            if value == searchValue {
                return index
            }
        }
        return nil
    }
    @IBAction func getLocation(_ sender: Any) {
        checkLocationServices()
    }
}

extension PredictViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textFields.contains(textField as! SkyFloatingLabelTextField) {
            textField.text = ""
        }
    }
}

extension PredictViewController {
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}

extension PredictViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            if location.coordinate.latitude == currentLocation.coordinate.latitude &&
                location.coordinate.longitude == currentLocation.coordinate.longitude {
                alertLocation(location: location)
                locationManager.stopUpdatingLocation()
                return
            }

            print("Latitude:\(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
            
            alertLocation(location: location)

            currentLocation = location
            locationManager.stopUpdatingLocation()
          }
      }
    
    func alertLocation(location: CLLocation) {
        let alert = CDAlertView(title: "Current Location", message: "Latitude:\(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)", type: .notification)
        let doneAction = CDAlertViewAction(title: "OK")
        alert.add(action: doneAction)
        alert.autoHideTime = 3
        alert.show()
        
 
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if let placemark = placemarks?[0]  {
                let lat = String(format: "%.04f", (placemark.location?.coordinate.longitude ?? 0.0)!)
                let lon = String(format: "%.04f", (placemark.location?.coordinate.latitude ?? 0.0)!)
                let name = placemark.name!
                let country = placemark.country!
                let region = placemark.administrativeArea!
                print("\(lat),\(lon)\n\(name),\(region) \(country)")
                
                self.locationLabel.text = "Latitude: \(location.coordinate.latitude) Longitude: \(location.coordinate.longitude)\n\(name), \(region), \(country)"
                
            }
        })
        
    }

    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: (error)")
        locationManager.stopUpdatingLocation()
    }
}
