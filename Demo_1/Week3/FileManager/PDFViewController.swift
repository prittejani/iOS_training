//
//  PDFViewController.swift
//  FileManager
//
//  Created by iMac on 04/03/24.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    var pdfUrl:URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = pdfUrl.lastPathComponent
        let pdfView = PDFView()
        pdfView.frame = self.view.frame
        pdfView.autoScales = true
        if let document = PDFDocument(url: pdfUrl){
            pdfView.document = document
        }
        self.view.addSubview(pdfView)
    }
        

}
