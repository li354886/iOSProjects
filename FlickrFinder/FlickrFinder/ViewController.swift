//
//  ViewController.swift
//  FlickrFinder
//
//  Created by 李正宁 on 6/8/15.
//  Copyright (c) 2015 Zhengning Li. All rights reserved.
//

import UIKit


let BASE_URL = "https://api.flickr.com/services/rest/"
let METHOD_NAME = "flickr.photos.search"
let API_KEY = "3c43cbf75a4cddeddc57cf7d6d3c3108"
let EXTRAS = "url_m"
let SAFE_SEARCH = "1"
let DATA_FORMAT = "json"
let NO_JSON_CALLBACK = "1"
let BOUNDING_BOX_HALF_WIDTH = 1.0
let BOUNDING_BOX_HALF_HEIGHT = 1.0
let LAT_MIN = -90.0
let LAT_MAX = 90.0
let LON_MIN = -180.0
let LON_MAX = 180.0

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var phraseTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    
    
    @IBAction func searchPhotoByPhrase(sender: AnyObject) {
        self.dismissAnyVisibleKeyboards()
        
        if !self.phraseTextField.text.isEmpty {
            self.photoTitleLabel.text = "Searching..."
            let methodArguments = [
                "method": METHOD_NAME,
                "api_key": API_KEY,
                "text": self.phraseTextField.text,
                "safe_search": SAFE_SEARCH,
                "extras": EXTRAS,
                "format": DATA_FORMAT,
                "nojsoncallback": NO_JSON_CALLBACK
            ]
            getImageFromFlickrBySearch(methodArguments)
        } else {
            self.photoTitleLabel.text = "Phrase Empty."
        }

    }
    
    @IBAction func searchPhotoByLonLati(sender: AnyObject) {
        self.dismissAnyVisibleKeyboards()
        
        if !self.latitudeTextField.text.isEmpty && !self.longitudeTextField.text.isEmpty {
            if validLatitude() && validLongitude() {
                self.photoTitleLabel.text = "Searching..."
                let methodArguments = [
                    "method": METHOD_NAME,
                    "api_key": API_KEY,
                    "bbox": createBoundingBoxString(),
                    "safe_search": SAFE_SEARCH,
                    "extras": EXTRAS,
                    "format": DATA_FORMAT,
                    "nojsoncallback": NO_JSON_CALLBACK
                ]
                getImageFromFlickrBySearch(methodArguments)
            } else {
                if !validLatitude() && !validLongitude() {
                    self.photoTitleLabel.text = "Lat/Lon Invalid.\nLat should be [-90, 90].\nLon should be [-180, 180]."
                } else if !validLatitude() {
                    self.photoTitleLabel.text = "Lat Invalid.\nLat should be [-90, 90]."
                } else {
                    self.photoTitleLabel.text = "Lon Invalid.\nLon should be [-180, 180]."
                }
            }
        } else {
            if self.latitudeTextField.text.isEmpty && self.longitudeTextField.text.isEmpty {
                self.photoTitleLabel.text = "Lat/Lon Empty."
            } else if self.latitudeTextField.text.isEmpty {
                self.photoTitleLabel.text = "Lat Empty."
            } else {
                self.photoTitleLabel.text = "Lon Empty."
            }
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        /* Add tap recognizer to dismiss keyboard */
        self.addKeyboardDismissRecognizer()
        
        self.subscribeToKeyboardNotifications()
    }

    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        /* Remove tap recognizer */
        self.removeKeyboardDismissRecognizer()
        
        /* Unsubscribe to all keyboard events */
        self.unsubscribeToKeyboardNotifications()
    }
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if self.photoImageView.image != nil {
            self.defaultLabel.alpha = 0.0
        }
        println(1)
        self.view.frame.origin.y -= self.getKeyboardHeight(notification) / 2
    }
    
    func keyboardWillHide(notification: NSNotification) {
        println(1
        )
        if self.photoImageView.image == nil {
            self.defaultLabel.alpha = 1.0
        }
        self.view.frame.origin.y += self.getKeyboardHeight(notification) / 2
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func createBoundingBoxString() -> String {
        
        let latitude = (self.latitudeTextField.text as NSString).doubleValue
        let longitude = (self.longitudeTextField.text as NSString).doubleValue
        
        /* Fix added to ensure box is bounded by minimum and maximums */
        let bottom_left_lon = max(longitude - BOUNDING_BOX_HALF_WIDTH, LON_MIN)
        let bottom_left_lat = max(latitude - BOUNDING_BOX_HALF_HEIGHT, LAT_MIN)
        let top_right_lon = min(longitude + BOUNDING_BOX_HALF_HEIGHT, LON_MAX)
        let top_right_lat = min(latitude + BOUNDING_BOX_HALF_HEIGHT, LAT_MAX)
        
        return "\(bottom_left_lon),\(bottom_left_lat),\(top_right_lon),\(top_right_lat)"
    }

    func validLatitude() -> Bool {
        if let latitude : Double? = self.latitudeTextField.text.toDouble() {
            if latitude < LAT_MIN || latitude > LAT_MAX {
                return false
            }
        } else {
            return false
        }
        return true
    }

    func validLongitude() -> Bool {
        if let longitude : Double? = self.longitudeTextField.text.toDouble() {
            if longitude < LON_MIN || longitude > LON_MAX {
                return false
            }
        } else {
            return false
        }
        return true
    }
    
    func getLatLonString() -> String {
        let latitude = (self.latitudeTextField.text as NSString).doubleValue
        let longitude = (self.longitudeTextField.text as NSString).doubleValue
        
        return "(\(latitude), \(longitude))"
    }
    
    func getImageFromFlickrBySearch(methodArguments: [String : AnyObject]) {
        
        let session = NSURLSession.sharedSession()
        let urlString = BASE_URL + escapedParameters(methodArguments)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                println("Could not complete the request \(error)")
            } else {
                
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                if let photosDictionary = parsedResult.valueForKey("photos") as? [String:AnyObject] {
                    
                    if let totalPages = photosDictionary["pages"] as? Int {
                        
                        /* Flickr API - will only return up the 4000 images (100 per page * 40 page max) */
                        let pageLimit = min(totalPages, 40)
                        let randomPage = Int(arc4random_uniform(UInt32(pageLimit))) + 1
                        self.getImageFromFlickrBySearchWithPage(methodArguments, pageNumber: randomPage)
                        
                    } else {
                        println("Cant find key 'pages' in \(photosDictionary)")
                    }
                } else {
                    println("Cant find key 'photos' in \(parsedResult)")
                }
            }
        }
        
        task.resume()
    }
    
    func getImageFromFlickrBySearchWithPage(methodArguments: [String : AnyObject], pageNumber: Int) {
        
        /* Add the page to the method's arguments */
        var withPageDictionary = methodArguments
        withPageDictionary["page"] = pageNumber
        
        let session = NSURLSession.sharedSession()
        let urlString = BASE_URL + escapedParameters(withPageDictionary)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                println("Could not complete the request \(error)")
            } else {
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                if let photosDictionary = parsedResult.valueForKey("photos") as? [String:AnyObject] {
                    
                    var totalPhotosVal = 0
                    if let totalPhotos = photosDictionary["total"] as? String {
                        totalPhotosVal = (totalPhotos as NSString).integerValue
                    }
                    
                    if totalPhotosVal > 0 {
                        if let photosArray = photosDictionary["photo"] as? [[String: AnyObject]] {
                            
                            let randomPhotoIndex = Int(arc4random_uniform(UInt32(photosArray.count)))
                            let photoDictionary = photosArray[randomPhotoIndex] as [String: AnyObject]
                            
                            let photoTitle = photoDictionary["title"] as? String
                            let imageUrlString = photoDictionary["url_m"] as? String
                            let imageURL = NSURL(string: imageUrlString!)
                            
                            if let imageData = NSData(contentsOfURL: imageURL!) {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.defaultLabel.alpha = 0.0
                                    self.photoImageView.image = UIImage(data: imageData)
                                    
                                    if methodArguments["bbox"] != nil {
                                        self.photoTitleLabel.text = "\(self.getLatLonString()) \(photoTitle!)"
                                    } else {
                                        self.photoTitleLabel.text = "\(photoTitle!)"
                                    }
                                    
                                })
                            } else {
                                println("Image does not exist at \(imageURL)")
                            }
                        } else {
                            println("Cant find key 'photo' in \(photosDictionary)")
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.photoTitleLabel.text = "No Photos Found. Search Again."
                            self.defaultLabel.alpha = 1.0
                            self.photoImageView.image = nil
                        })
                    }
                } else {
                    println("Cant find key 'photos' in \(parsedResult)")
                }
            }
        }
        
        task.resume()
    }

    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController {
    func dismissAnyVisibleKeyboards() {
        if phraseTextField.isFirstResponder() || latitudeTextField.isFirstResponder() || longitudeTextField.isFirstResponder() {
            self.view.endEditing(true)
        }
    }
}


