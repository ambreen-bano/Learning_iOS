//
//  ViewController.swift
//  iOSDesignPatterns_Adapter
//
//  Created by Ambreen Bano on 25/08/25.
//

import UIKit

/* Design Pattern - Adapter Patter
 It is a wrapper for incompatible interfaces to make it compatable with other interfaces.
 Adapter class wrap one interface to make it compatible.
 
 can use for - legacy code or incompatible interfaces.
 Adapter pattern work with protocols only.
 
 Inject incompatable object inside Adapter
 
 Object Adaptor  - (Adopts Protocol and inject oldInterface class) prefered to use this way for adaptor.
 Class Adaptor - (Adopts Protocol and inheritance for oldInterface class) avoid to use this way for adaptor.
 */

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let adapter = PrinterAdapter(printer: oldPrinter())
        adapter.print()
    }
}

protocol newWayToPrint{
    var printerName: String { get } //We can only wrap computed properties (Stored are not allowed)
    func print()
}

class oldPrinter {
    var name: String {
        "My Old Printer"
    }
    
    func printOldStyleText() {
        print("Old Style Text Print")
    }
}


class PrinterAdapter: newWayToPrint { //This is Object Adaptor (Adopts New interface Protocol and inject oldInterface calss)
    
    let printer: oldPrinter
    init(printer: oldPrinter) { //inject incompatable object inside Adapter
        self.printer = printer
    }
    
    var printerName: String { //printerName property is a wrapper for oldPrinter name property
        "New Way for - " + self.printer.name
    }
    
    func print() {
        self.printer.printOldStyleText() //print() is a wrapper for oldPrinter using protocol newWayToPrint
    }
}
