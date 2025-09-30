//
//  PublicOpenPrivateFilePrivateInternal.swift
//  InstanceStaticPrivate
//
//  Created by Ambreen Bano on 02/02/23.
//

import UIKit

class PublicOpenPrivateFilePrivateInternal: UIViewController {
    
    //Access Controls/ Access Modifiers :
    //1. private - can be use within class and with class extension if extensionn is in within same file
    //2. fileprivate - can be use in different classes but within file only.
    //3. Internal - is default, if we are not setting any access control then by default it is Internal and can be use within module/project but not outside module.
    //4. public - can be use within module/project and Outside module(SDK). We can override it in inherit class(we can subclass it) within module/project. But we can not override it in inherit class Outside module(SDK).
    //5. open - can be use within module/project and Outside module(SDK). We can override it in inherit class within module/project and Outside module(SDK). eg. UITableviewDelegats are open
    
    
    var defaultVar: Int = 0 //internal
    
    private var privateVar: Int = 0 //private
    fileprivate var fileprivateVar: Int = 0 //fileprivate
    private func privateFunction(){  }
    fileprivate func fileprivatefunction(){ }
    public var publicVar : Int = 1 //Public
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Default is Internal access control
        defaultVar = 10
        
        // "private" we can use within class only.
        privateVar = 20
        privateFunction()
    }
}

extension PublicOpenPrivateFilePrivateInternal {
    func exampleFunc(){
        // "private" we can use within class extension if extension is withing file only.
        //Can NOT use private properties/methods if extension is in another file
        self.privateVar = 30
        self.privateFunction()
    }
}




class newClassForPrivateFilePrivate: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let obj = PublicOpenPrivateFilePrivateInternal()
        
        //By default properties and methods are internal. we can use them anywhere inside our module
        _ = obj.defaultVar
        
        //"private" we can access within class only
        //        _ = obj.privateVar
        //        obj.privateFunction()
        
        //"fileprivate" we can access within file only
        _ = obj.fileprivateVar
        obj.fileprivatefunction()
        
        //"Public" we can access within module and in imported module also
        _ = obj.publicVar
    }
}






extension UITableView {
    //We are importing UIKit and UITableView is in UIKit module/SDK and we are defining open var and method there
    //Now whereever we are using UITableView, we can access below open variable and method also
    @objc public var publicVar: Int {
        return 10
    }
    
    @objc open var openVar: Int {
        return 10
    }
    @objc open func openFunction(){ }
}


class newClassForOpenPublic: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //"Open" can access outside module also. It's open to access in another module/SDK
        //We are importing UIKit and UITableView is part of UIKit module and we are using open var/method of tableView in our module project
        //We can create our SDK with open methods and whoever importing our SDK, can access open or public methods or properties
        let tableView = UITableView()
        _ = tableView.openVar
        tableView.openFunction()
        
    }
}

class newTableView: UITableView {
    
    //We can subclass/inherit UITableView in our module as it is define in UIKit as Open
    //We can not subclass/inherit anything in our module from UIKit which is define as public but we can use them just.
    override var publicVar: Int { //We can override/inherit public properties within modele but not allowed outside module, like UITableView public properties/method we can't override
        return 15
    }
    
    override var openVar: Int {
        return 20
    }
    
    //We can not override/inherit stored properties, stored properties Dosen't support Inheritance
    //override var style: UITableView.Style = .grouped
    
    override func beginUpdates() {
        //We can override/inherit open computed properties and methods of the imported Module (UITableView)
    }
}
