//
//  ActionSheetViewController.swift
//  Demo_1
//
//  Created by iMac on 16/04/24.
//

import UIKit

class ActionSheetViewController: UIViewController,UIPopoverPresentationControllerDelegate{

@IBOutlet weak var popOverButton: UIButton!
    @IBOutlet weak var showPopButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }

   
    @IBAction func showActionSheet(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Action Sheet", message: "Choose Option", preferredStyle: .actionSheet)
        let approve = UIAlertAction(title: "Approve", style: .default){(action) in
            self.customAlert(title: "", message: "You Choose Approve")
            
        }
        let edit = UIAlertAction(title: "Edit", style: .default){(action) in
            self.customAlert(title: "", message: "You Choose Edit")
        }
        let delete = UIAlertAction(title: "Delete", style: .destructive){(action) in
            self.customAlert(title: "", message: "You Choose Delete")
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(approve)
        actionSheet.addAction(delete)
        actionSheet.addAction(edit)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }

    @IBAction func onPopoverTapped(_ sender: UIButton) {
        guard let ourPopOver = preparePopUp(sourceRect: showPopButton.frame, VCIdentifier: "PopoverViewController") else { return }
              self.present(ourPopOver, animated: true, completion: nil)
    }
    
    @IBAction func showBottomSheet(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "BottomSheetViewController") as! BottomSheetViewController
        if let sheet = vc.sheetPresentationController{
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 25.0
            sheet.prefersGrabberVisible = true
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func onPopupTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PopupViewController") as! PopupViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    func customAlert(title:String,message:String){
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(saveAction)
        present(alert, animated: true)
    }
    
    
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle { return .none }
    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {}
    public func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool { return true }
        
   func preparePopUp(sourceRect : CGRect, VCIdentifier: String) -> UIViewController? {
        let popoverContentController = self.storyboard?.instantiateViewController(withIdentifier:"PopoverViewController") as! PopoverViewController
        popoverContentController.modalPresentationStyle = .popover
       popoverContentController.didSelectItem = { [weak self] selectedItem in
           self!.showPopButton.setTitle(selectedItem, for: UIControl.State.normal)
       }
        if let popoverPresentationController = popoverContentController.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .init([.up,.down])
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = sourceRect
            popoverPresentationController.delegate = self
            return popoverContentController
        }
    return nil
    }

}

