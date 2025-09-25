//
//  HigherOrderFunctionVC.swift
//  HOF
//
//  Created by Ambreen Bano on 20/01/23.
//

import UIKit

struct User {
    let name: String
    let age: Int
}

struct UserSalary {
    let name: String
    let salary: Int
}

class HigherOrderFunctionVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Map/CompactMap - map compactMap is enumerated on every element and perform some action and return new elements
        //FlatMap - flatMap is use to give flat sequence/collection of elements from nested collections
        //Reduce - reduce is use to perform some action on elements to reduce into single value
        //Filter - Filter return filtered elements on the basis of condition
        //Sorted - Sort is for sorting on the basis of some condition
        //Contains - Contains return true false on the basis of condition
        //ForEach - ForEach calls the given closure on each element in the same order as a for-in loop. doesn't return any value, just iterate
        //Remove - Remove will delete elements
        
        mapExamples()
        compactMapExamples()
        flatMapExamples()
        reduceExamples()
        filterExamples()
        sortedExamples()
        containsExamples()
        forEachExamples()
        removeAllExamples()
    }
    
    
    /*____________Sorted________________*/
    
    private func sortedExamples(){
        //$0 and $1 for comparision
        
        //Sort in Asc
        let arrayOfInt = [1,4,7,2,7,3,9,4]
        let arr1 = arrayOfInt.sorted()
        print(arr1)
        
        //Sort in Desc
        let arr2 = arrayOfInt.sorted {$0 > $1}
        print(arr2)
        
        
        //Sort by name in model
        let employees: [User] = [
            User(name: "Sami", age: 35),
            User(name: "Amber", age: 30),
            User(name: "Khushi", age: 15),
            User(name: "Sam", age: 9)
        ]
        
        let arr3 = employees.sorted { $0.name.prefix(1) < $1.name.prefix(1)}
        print(arr3)
        
        
        //Sort by name in dict
        let dictOfNameAndSalary: [String:Int] = [
            "sam" : 400,
            "wasim" : 2300,
            "mona" : 1500,
            "funto" : 5400
        ]
        let arr4 = dictOfNameAndSalary.sorted{$0.key < $1.key}
        print(arr4)
    }
    
    /*____________Sorted________________*/
    
    
    
    /*____________ForEach________________*/
    
    private func forEachExamples(){
        //$0 is for iterating elements
        
        //Print number which is multiple of 2
        let arrayOfInt = [1,4,7,2,7,3,9,4]
        arrayOfInt.forEach {
            if $0 % 2 == 0 {
                print("\($0) is Multiple of 2")
            }
        }
        
        //Print number which is not nil
        let arrayOfInt1: [Int?] = [1,4,nil,7,2,7,nil,9,4]
        arrayOfInt1.forEach { numb in
            guard let num = numb  else {
                return //difference between for loop is this return only. we use continue/break in for loop
            }
            print("\(num) is not nil")
        }
        
        arrayOfInt1.enumerated().forEach { index, numb in //enumerated() returns pair of (index,number)
            guard numb == nil else {
                return
            }
            print("\(index) index is null")
        }
    }
    
    /*____________ForEach________________*/
    
    
    
    
    /*____________Contains________________*/
    
    private func containsExamples(){
        //$0 is for checking condition
        
        //is there any elements of the array > 8
        let arrayOfInt: [Int] = [1,4,7,2,7,3,9,4]
        let bool1 = arrayOfInt.contains {$0 > 8}
        print(bool1)
        
        //is there any elements of the array multiple of 2
        let bool2 = arrayOfInt.contains { $0.isMultiple(of: 2)}
        print(bool2)
        
        //is there any elements of the Dict salary < 1000
        let dictOfNameAndSalary: [String:Int] = [
            "sam" : 400,
            "wasim" : 2300,
            "mona" : 1500,
            "funto" : 5400
        ]
        
        let bool3 = dictOfNameAndSalary.contains{$1 < 1000}
        print(bool3)
        
        
        //is there any employee in the model age < 19
        let employees: [User] = [
            User(name: "amber", age: 30),
            User(name: "khushi", age: 15),
            User(name: "Sami", age: 35),
            User(name: "Sam", age: 9)
        ]
        let bool4 = employees.contains{$0.age < 19}
        print(bool4)
        
        let sentence = "hfg hgh hi hello bye okk cat dog hwy"
        let bool5 = sentence.lowercased().contains("bye")
        print(bool5)
        
        let isSuccess = (200...299).contains(205)
        print(isSuccess)
    }
    
    /*____________Contains________________*/
    
    
    
    /*____________RemoveAll________________*/
    
    private func removeAllExamples(){
        //Remove all elements of the array
        var arrayOfInt: [Int] = [1,4,7,2,7,3,9,4]
        arrayOfInt.removeAll()
        
        
        //Remove all elements of the array < 5
        var arrayOfInt1: [Int] = [1,4,7,2,7,3,9,4]
        arrayOfInt1.removeAll {$0 < 5}
        
        
        //Value < 19 from json dict
        var dictOfNameAndSalary: [String:Int] = [
            "sam" : 4,
            "wasim" : 23,
            "mona" : 15,
            "funto" : 54
        ]
        //dictOfNameAndSalary.removeAll{ //Not supported to remove with any specific condition < 19 }
        dictOfNameAndSalary.removeAll()
        
        
        
        //users model with age > 19
        //supported to remove with any specific condition form models
        var employees: [User] = [
            User(name: "amber", age: 30),
            User(name: "khushi", age: 15),
            User(name: "Sami", age: 35),
            User(name: "Sam", age: 9)
        ]
        employees.removeAll{$0.age < 19}
    }
    /*____________RemoveAll________________*/
    
    
    
    /*____________Filter________________*/
    
    private func filterExamples(){
        
        //Filter num < 5
        let arrayOfInt = [1,4,7,2,7,3,9,4]
        let outp1 = arrayOfInt.filter{$0 < 5}
        print(outp1)
        
        
        //Filter string starting with a
        let arrayOfIntStr = ["hello","amber","amm","sam","amu","7yhg"]
        let outp2 = arrayOfIntStr.filter{ $0.prefix(1) == "a"}
        let outp22 = arrayOfIntStr.filter{ $0.prefix(1) == "a"}.first
        print(outp2)
        print(outp22)// first person with name starting "a"
        
        
        //Sum of All < 11
        let setData: Set = [10, 1, 40, 30, 44, 4, 3]
        let outp3 = setData.filter{$0 < 11}.reduce(0){$0 + $1}
        print(outp3)
        
        
        
        //users with age > 19
        let employees: [User] = [
            User(name: "amber", age: 30),
            User(name: "khushi", age: 15),
            User(name: "Sami", age: 35),
            User(name: "Sam", age: 9)
        ]
        
        //Employee > 19
        let emp = employees.filter{$0.age > 19}
        print(emp)
        
        //Employee > 19 and name starting with S
        let emp1 = employees.filter{$0.age > 19}.filter{$0.name.prefix(1) == "S"}
        let emp11 = employees.filter{$0.age > 19 && $0.name.prefix(1) == "S"}
        print(emp1)
        print(emp11)
        
        //name of employees having age < 19
        let emp2 = employees.filter{$0.age < 19}.map{$0.name}
        print(emp2)
        
        
        //Value < 19 from json dict
        let dictOfNameAndSalary: [String:Int] = [
            "sam" : 4,
            "wasim" : 23,
            "mona" : 15,
            "funto" : 54
        ]
        let dict = dictOfNameAndSalary.filter{$1 < 19}
        print(dict)
        
    }
    /*____________Filter________________*/
    
    
    
    
    /*____________Reduce________________*/
    
    private func reduceExamples(){
        //Sum All
        let arrayOfInt = [1,4,7,2,7,3,9,4]
        let sum1 = arrayOfInt.reduce(0){$0 + $1}
        print(sum1)
        
        let arrayOfArrayM = [[3,9],[2,6,4,6],[5,7,3],[2,3]]
        let sum2 = arrayOfArrayM.flatMap{$0}.reduce(0){$0 + $1}
        print(sum2)
        
        //Product All
        let prod1 = arrayOfInt.reduce(1){$0 * $1}
        print(prod1)
        
        
        //Sum of Salary from model
        let employeesSalary: [UserSalary] = [
            UserSalary(name: "amber", salary: 3000),
            UserSalary(name: "khushi", salary: 2500),
            UserSalary(name: "Sam", salary: 3500)
        ]
        
        let arrayOfSalary = employeesSalary.map{$0.salary}
        let sumOfSalary = arrayOfSalary.reduce(0){$0 + $1}
        print(sumOfSalary)
        
        let sumS = employeesSalary.map{$0.salary}.reduce(0){$0 + $1}
        print(sumS)
        
        //other ways
        let sumS1 = employeesSalary.reduce(0){ $0 + $1.salary }
        print(sumS1)
        
        
        
        
        //Sum of Salary from json dict
        let dictOfNameAndSalary: [String:Int] = [
            "sam" : 200,
            "wasim" : 300,
            "mona" : 500,
            "funto" : 100
        ]
        
        let sum3 = dictOfNameAndSalary.reduce(0){ $0 + $1.value} //(condition on $1 not on $0 in reduce)
        //wheneverv $0 and $1 is required, we use $0.key and $0.value
        print(sum3)
        
        //All employee names separated by space
        let namesSeparatedByspace = dictOfNameAndSalary.reduce(""){$0 + " " + $1.key }
        print(namesSeparatedByspace)  //(condition on $1 not on $0 in reduce)
        
        
        
        
        //Sum of All
        let setData: Set = [10, 1, 40, 30, 44, 4, 3]
        let sum4 = setData.reduce(0){$0 + $1}
        print(sum4)
        
        //Sum of all < 11 (condition on $1 not on $0 in reduce)
        let sum5 = setData.reduce(0) { ($1 < 11) ? $0 + $1 : $0 }
        print(sum5)
        
    }
    /*____________Reduce________________*/
    
    
    
    
    
    /*____________FlatMAP________________*/
    
    private func flatMapExamples(){
        //Single array of collection like flat
        let arrayOfArrayM = [[3,9],[2,6,4,6],[5,7,3],[2,3]]
        let singleSequence = arrayOfArrayM.flatMap{$0}
        print(singleSequence)
        
    }
    /*____________FlatMAP________________*/
    
    
    
    
    /*____________CompactMAP________________*/
    
    private func compactMapExamples(){
        //Where ever we can apply map we can also apply compact map
        //Difference is compact map is always return only non-optional values
        //Convert string Values into Int if possible and output will be non nil values [Int]
        let arrayOfIntStr1 = ["hello","1","sam","5","7"]
        let convStrToInt1 = arrayOfIntStr1.compactMap {Int($0)}
        print(convStrToInt1)
        
    }
    
    /*____________CompactMAP________________*/
    
    
    
    /*____________MAP________________*/
    private func mapExamples(){
        //Double Each
        let arrayOfInt = [1,4,7,2,7,3,9,4]
        let doubleEachValue1 = arrayOfInt.map { (numb) in
            return numb * 2 //return kw is not mandatory
        }
        print(doubleEachValue1)
        let doubleEachValue2 = arrayOfInt.map{ $0 * 2 }
        print(doubleEachValue2)
        
        
        
        //Calculate Sum
        let arrayOfArrays = [[2,4,5],[2,8,7],[4,8,9]]
        let sumArray = arrayOfArrays.map{ $0[0] + $0[1] + $0[2] }
        print(sumArray)
        
        
        
        //Calculate Sum
        let arrayOfArraysM = [[3,9],[2,6,4,6],[5,7,3],[2,3]]
        let sumArrayM = arrayOfArraysM.map { array in
            var sum = 0
            for val in array {
                sum = sum + val
            }
            return sum
        }
        print(sumArrayM)
        
        
        
        //Convert string Values into Int if possible
        let arrayOfIntStr = ["hello","1","sam","5","7"]
        let convStrToInt = arrayOfIntStr.map { Int($0) }
        //Output is optional array of Int [Int?]
        print(convStrToInt)
        
        
        
        //Read only names of the users
        let employees: [User] = [
            User(name: "amber", age: 30),
            User(name: "khushi", age: 25),
            User(name: "Sam", age: 35)
        ]
        
        let employeeNames = employees.map { $0.name }
        print(employeeNames)
        
        
        //Convert Only Temp by 2
        let dictOfTemp: [String:Int] = [
            "s" : 20,
            "w" : 30,
            "m" : 50,
            "f" : 10
        ]
        let doubleTempValue = dictOfTemp.map { [$0.key : $0.value * 2] }
        let doubleTempValue1 = dictOfTemp.map { [$0 : $1 * 2] }
        print(doubleTempValue)
        print(doubleTempValue1)
        
        
        //Create Model of Users from Dict
        let dictOfNameAndAge: [String:Int] = [
            "sam" : 20,
            "wasim" : 30,
            "mona" : 50,
            "funto" : 10
        ]
        
        let newEmployees = dictOfNameAndAge.map { User(name: $0, age: $1)}
        let newEmployees1 = dictOfNameAndAge.map { User(name: $0.key, age: $0.value)}
        print(newEmployees)
        print(newEmployees1)
        
        
        //Convert values of the set as multiply by 2
        let setData: Set = [10, 40, 30, 44]
        let doublevalue = setData.map {$0 * 2}
        //it is array of Int not Set
        print(doublevalue)
        
        let newSet = Set(doublevalue)
        print(newSet)
    }
    
    /*____________MAP________________*/
    

}
