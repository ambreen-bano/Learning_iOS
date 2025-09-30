//
//  InstanceStaticPrivate.swift
//  InstanceStaticPrivate
//
//  Created by Ambreen Bano on 23/01/23.
//

import UIKit

class InstanceStaticPrivate: UIViewController {
    //Static Properties/function are Global Properties
    //Static Properties/function can be access only using class/struct/enum name (for class level Properties/function we use name to call)
    //Static properties/function can not be access using class/struct/enum instance (for final Properties/function we use instnace to call)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Instance Or Object of the Class
        let instanceOfClass = InstanceVariablesAndMethod()
        
        //Instance variables and Methods can be access using Instance Object of the class
        let _ = instanceOfClass.name
        let _ = instanceOfClass.age
        instanceOfClass.getStudentData()
        
        //Private variables and Methods are inaccessiable using Instance Object of the class
        //instanceOfClass.privateName
        
        //Its getter is public/Internal so we can read outside class using instance of the class
        let _ = instanceOfClass.writeIsPrivate
        let _ = instanceOfClass.writeIsPrivate2
        //Setter is inaccessible as it is private(set)
        //instanceOfClass.writeIsPrivate = ""
        
        let player1 = staticPropertyAndMethod()
        player1.updatePlayerScore(score: 20)
        let player2 = staticPropertyAndMethod()
        player2.updatePlayerScore(score: 50)
        let player3 = staticPropertyAndMethod()
        player3.updatePlayerScore(score: 30)
        let highestScoreValueFromAllPlayer = staticPropertyAndMethod.highestScore
        print(highestScoreValueFromAllPlayer)
        //Static Functions can be access using class/struct/enum Name only
        //Static function/varaibles are at global level and live until app is KILL
        staticPropertyAndMethod.staticFunction()
        
        //Push FirstVC to check Static Shared Instance of the class
        self.navigationController?.pushViewController(FirstVC(), animated: true)
    }
}



/*________________________________________________________________*/

class InstanceVariablesAndMethod: UIViewController {
    
    //Instance Variables or properties
    //The Default (Internal) will act as public within the same package and acts as private outside the package.
    var name: String? //By default properties are Internal
    public var age: Int?
    private var privateName: String? //can be use within class only
    public private(set) var writeIsPrivate: String? //can be read outside class but can be written within class only as setter is private
    private(set) var writeIsPrivate2: String?
    
    //Instance Method
    func getStudentData() {
        name = "Amber"
        age = 30
        privateName = "nickNName"
        writeIsPrivate = "private setter"
        
        if let name = name, let age = age, let privateName = privateName, let writeisPrivate = writeIsPrivate {
            print(name + " \(age)" + " " + privateName + " " + writeisPrivate)
        }
    }
}

/*________________________________________________________________*/


class staticPropertyAndMethod: UIViewController {
    
    //Static Properties/function are Global Properties
    //Static Properties/function can be access only using class/struct/enum name
    //Static properties/function can not be access using class/struct/enum instance
    //Static can use for constancts or manager class methods (API calling methods or logging methods, where global access is required)
    
    //Instance Stored Properties
    var playerName: String?
    var playerScore: Int = 0
    
    //Static Stored Property
    static var highestScore : Int = 0
    
    //Static Computed Property
    static var computedHighestScore : Int {
        return highestScore * 100
    }
    
    //Static Function can be called globally in the project using class name (reuse methods)
    static func staticFunction() {
        print("\(self.highestScore)")
        //Instance Properties can not be access inside Static methods
        //playerName = "NewPlayer"
    }
    
    func updatePlayerScore(score: Int){
        playerScore = score
        if staticPropertyAndMethod.highestScore < playerScore {
            //Static can be access using Class Name only
            staticPropertyAndMethod.highestScore = playerScore
        }
    }
}



