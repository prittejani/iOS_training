import UIKit

class LocalizationViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{
    
    var languagePicker = UIPickerView()
    let languages = ["Default","English","Hindi","Gujarati","Japanese"]
    let languagesCodes = ["en","en","hi","gu","ja"]
    @IBOutlet weak var languageField: UITextField!
    var currentLanguage:String!
    var selectedLanguageCode = ""
    @IBOutlet weak var lblParagraph: UILabel!
    var isDefaultSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        languageField.inputView = languagePicker
        languageField.delegate = self
        languagePicker.delegate = self
        languagePicker.dataSource = self

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let checkDefault:Bool = UserDefaults.standard.bool(forKey: "isDefault")
        
        if checkDefault == true {
            let langCode = Locale.current.languageCode!
            print(langCode)
            if Bundle.main.path(forResource: String(langCode), ofType: "lproj") != nil{
                languageChange(language: langCode)
                languageField.text = languages[0]
                languagePicker.selectRow(0, inComponent: 0, animated: false)
            }else{
                languageChange(language: "en")
            }
        }
        else{
            let langCode = UserDefaults.standard.string(forKey: "myLanguage")
            if let appLanguageCode = langCode{
                print(appLanguageCode)
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
    }
    func isLanguageSupported(languageCode: String) -> Bool {
        return Bundle.main.localizations.contains(languageCode)
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
        if row == 0{
            let langCode = Locale.current.languageCode!
            if let path = Bundle.main.path(forResource: String(langCode), ofType: "lproj"){
                languageChange(language: langCode)
              languagePicker.selectRow(0, inComponent: 0, animated: false)
                languageField.text = languages[row]
                UserDefaults.standard.set(true, forKey: "isDefault")
            }else{
                languageChange(language: "en")
                UserDefaults.standard.set(true, forKey: "isDefault")
            }
        }else{
            languageField.text = languages[row]
            languageChange(language: languagesCodes[row])
            languageField.resignFirstResponder()
            selectedLanguageCode = languagesCodes[row]
            UserDefaults.standard.set(selectedLanguageCode, forKey: "myLanguage")
            UserDefaults.standard.set(false, forKey: "isDefault")
            self.viewDidLoad()
        }
    }
  
    func languageChange(language:String){
        lblParagraph.text = "Paragraph".localizableString(loc: language)
    }
    
    
   
                                
                                    
}
extension String{
    func localizableString(loc: String) -> String{
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
