//
//  ShowPDFViewController.swift
//  test
//
//  Created by USER on 31/05/24.
//

import UIKit
import PDFKit
class ShowPDFViewController: UIViewController {

    var pdfUrl:URL!
    var titlePDf:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titlePDf
        let pdfView = PDFView()
        pdfView.frame = self.view.frame
        pdfView.autoScales = true
        if let document = PDFDocument(url: pdfUrl){
            pdfView.document = document
        }
        self.view.addSubview(pdfView)
    }
}
