/*
*     Copyright 2016 IBM Corp.
*     Licensed under the Apache License, Version 2.0 (the "License");
*     you may not use this file except in compliance with the License.
*     You may obtain a copy of the License at
*     http://www.apache.org/licenses/LICENSE-2.0
*     Unless required by applicable law or agreed to in writing, software
*     distributed under the License is distributed on an "AS IS" BASIS,
*     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*     See the License for the specific language governing permissions and
*     limitations under the License.
*/



import UIKit



// MARK: - Swift 3

#if swift(>=3.0)
    


class CallbackPickerViewController: NSObject,UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var callbackType: CallbackType = .delegate
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        return CallbackType.allValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
        return CallbackType.allValues[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        self.callbackType = CallbackType.allValues[row]
    }
    
}



enum CallbackType: String {
    
    case delegate = "Delegate"
    case completionHandler = "Completion Handler"
    
    static var allValues: [CallbackType] {
        
        return [delegate, completionHandler]
    }
}
    
    
    
    
    
/**************************************************************************************************/
    
    
    
    
    
// MARK: - Swift 2
    
#else
    
    

class CallbackPickerViewController: NSObject,UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var callbackType: CallbackType = .delegate
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        return CallbackType.allValues.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
        return CallbackType.allValues[row].rawValue
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        self.callbackType = CallbackType.allValues[row]
    }

}



enum CallbackType: String {
    
    case delegate = "Delegate"
    case completionHandler = "Completion Handler"
    
    static var allValues: [CallbackType] {
        
        return [delegate, completionHandler]
    }
}



#endif
