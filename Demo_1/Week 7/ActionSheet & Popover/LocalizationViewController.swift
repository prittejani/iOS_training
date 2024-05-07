//
//  LocalizationViewController.swift
//  Demo_1
//
//  Created by iMac on 29/04/24.
//

import UIKit

class LocalizationViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{
    
    var languagePicker = UIPickerView()
    let languages = ["English","Hindi","Gujarati","Japanese"]
    let languagesCodes = ["en","hi","gu","ja"]
    @IBOutlet weak var languageField: UITextField!
    
    var selectedLanguageCode = ""
    @IBOutlet weak var lblParagraph: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        languageField.inputView = languagePicker
        languageField.delegate = self
        languagePicker.delegate = self
        languagePicker.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let appLanguageCode = Locale.autoupdatingCurrent.languageCode {
            if appLanguageCode == "en"{
                languageField.text = "English"
                languageChange(language: "en")
            }
            else if appLanguageCode == "gu"{
                languageField.text = "Gujarati"
                languageChange(language: "gu")
            }
            else if appLanguageCode == "hi"{
                languageField.text = "Hindi"
                languageChange(language: "hi")
            }
            else if appLanguageCode == "ja"{
                languageField.text = "Japanese"
                languageChange(language: "ja")
            }else{
                languageField.text = "English"
                languageChange(language: "en")
            }

        }

    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
            languageField.text = languages[row]
            languageChange(language: languagesCodes[row])
            languageField.resignFirstResponder()
            selectedLanguageCode = languagesCodes[row]
            UserDefaults.standard.set(selectedLanguageCode, forKey: "appLanguage")
            UserDefaults.standard.set([selectedLanguageCode],forKey: "AppleLanguages")
            self.viewDidLoad()
    }
  
    func languageChange(language:String){
        lblParagraph.text = "Paragraph".localizableString(loc: language)
    }
    
    @IBAction func onSettingTapped(_ sender: UIBarButtonItem) {
        if let url = URL.init(string: UIApplication.openSettingsURLString){
            UIApplication.shared.open(url,options: [:],completionHandler: nil)
        }
    }
}
extension String{
    func localizableString(loc: String) -> String{
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
class LanguageManager {
    static let shared = LanguageManager()
    
    func setLanguage(languageCode: String) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Reload the app UI after changing the language
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Change "Main" to your storyboard name
        let viewController = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
        // Optional: Notify any listeners about the language change
        NotificationCenter.default.post(name: .languageChanged, object: nil)
    }
}

extension Notification.Name {
    static let languageChanged = Notification.Name("LanguageChangedNotification")
}
