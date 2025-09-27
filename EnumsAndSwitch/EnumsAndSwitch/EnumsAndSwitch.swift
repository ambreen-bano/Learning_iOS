//
//  EnumsAndSwitch.swift
//  EnumsAndSwitch
//
//  Created by Ambreen Bano on 19/02/23.
//

import UIKit

class EnumsAndSwitch: UIViewController {
    
    //Enums are value type
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1. Simple Enum
        MySimpleEnumCall(value: .iphone6)
        
        //2. Enum with RawValue
        MyRawTypeEnumCall(value: .iphone6)
        MyRawTypeIntEnumCall(value: .iphone11)
        
        //3. Enum with Constants
        MyConstantEnumCall()
        
        //4. Enum With caseIterable
        MyCaseIterableEnumCall()
        
        //5. Enum With Associated Values
        MyAssociatedValueEnumCall(value: .iphone11(year: 2023, age: 25))
        
        
        /*___________________*/
        switchCasesHandling(value: .iphone11)
        switchCaseWithRangeOfUnlimitedValues(value: 11)
        switchCaseWithFallthroughCases(value: "Amber")
        /*__________________*/
    }
    
    
    //1. Simple Enum
    enum MySimpleEnum {
        case iphone6
        case iphone11, iphone12
    }
    
    func MySimpleEnumCall(value:MySimpleEnum){
        switch value {
        case .iphone6:
            print(MySimpleEnum.iphone6)
            print(MySimpleEnum.iphone6.hashValue)
            print("iphone6")
        case .iphone11:
            print("iphone11")
        case .iphone12:
            print("iphone12")
        }
    }
    
    
    
    
    
    //2. Enum with (RawValue) some String or Int type raw value
    enum MyRawTypeEnum: String {
        case iphone6 = "iphone_6"
        case iphone11 = "iphone_11"
        case iphone12 = "iphone_12"
    }
    
    func MyRawTypeEnumCall(value:MyRawTypeEnum){
        switch value {
        case .iphone6:
            print(MyRawTypeEnum.iphone6.rawValue)
        case .iphone11:
            print(MyRawTypeEnum.iphone11.rawValue)
        case .iphone12:
            print(MyRawTypeEnum.iphone12.rawValue)
        }
    }
    
    enum MyRawTypeIntEnum: Int {
        //By default will start from 0, but if we assign value to only first one then it will take in increment fashion from 5
        case iphone6 = 5
        case iphone11
        case iphone12
    }
    
    func MyRawTypeIntEnumCall(value:MyRawTypeIntEnum){
        switch value {
        case .iphone6:
            print(MyRawTypeIntEnum.iphone6.rawValue)
        case .iphone11:
            print(MyRawTypeIntEnum.iphone11.rawValue)
        case .iphone12:
            print(MyRawTypeIntEnum.iphone12.rawValue)
        }
    }
    
    
    
    
    
    //3. Constant Enum - for static let constants can be use
    enum MyConstantEnum {
        static let constant1 = "MYConstant1"
        static let constant2 = "MYConstant2"
    }
    
    func MyConstantEnumCall(){
        let contantValue = MyConstantEnum.constant2
        print(contantValue)
    }
    
    
    
    
    
    //4. CaseIterable Enum - give Collection of the enum cases for count or loop
    enum MyCaseIterableEnum: String,CaseIterable {
        case iphone6 = "1iphone_6"
        case iphone11 = "2iphone_11"
        case iphone12 = "3iphone_12"
    }
    
    func MyCaseIterableEnumCall(){
        let _ = MyCaseIterableEnum.allCases.count
        for value in MyCaseIterableEnum.allCases {
            print(value.rawValue)
        }
    }
    
    
    
    
    
    //5. Enum with associated values (Like Result<success,failure> Type - special enum with only two cases)
    enum MyAssociatedValueEnum{
        //Not necessary to give associated values to every enum case
        case iphone6(version:Int) //like we are giving arguments in functions
        case iphone11(year:Int, age: Int)
        case iphone12(core:Int)
        case iphone13(name:String)
        case iphone14(Int)
        case iphone15
    }
    
    func MyAssociatedValueEnumCall(value:MyAssociatedValueEnum){
        switch value {
        case .iphone6(let version):
            if version > 15 {
                print("New")
            }
        case var .iphone11(year: yearInt, age: _ ): //we can write "let" or "var" outside also
            if yearInt > 2021 {
                print("Newer than 2021")
                yearInt = 2022 //we can modify if it is var
            }
        case .iphone12:
            // if don't want to use associated value just remove it
            break
        case .iphone13(let name):
            print("\(name)")
        case .iphone14(let val):
            print("iphone14")
        case .iphone15:
            print("iphone15")
        }
    }
}



extension EnumsAndSwitch {
    
    /*_______________________*/
    
    func switchCasesHandling(value: MySimpleEnum){
        switch value {
        case .iphone6, .iphone11:
            print("compound cases")
        case .iphone12:
            print("single cases")
        }
    }
    
    func switchCaseWithRangeOfUnlimitedValues(value: Int) {
        switch value {
        case 0:
            print("case 0")
        case 1...10: //For exact value use 3 ...
            print("1 to 10 case")
        case 11..<200: //For less than value use 2 ..
            print("11 to 199 case")
        default:
            print("Any other possible value case")
        }
    }
    
    func switchCaseWithFallthroughCases(value:String){
        switch value {
        case "Amber":
            print("Amber Case")
            
            //fallthrough case will execute next case also
            fallthrough
            
        case "Iram":
            print("Iram Case")
        case "Khushi":
            print("Khushi Case")
        default:
            break
        }
    }
    
    /*_______________________*/
}
