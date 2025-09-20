//
//  ViewController.swift
//  iOSDesignPatterns_Facade
//
//  Created by Ambreen Bano on 25/08/25.
//

import UIKit

/* Design Pattern  - Facade Pattern
 Provides a simplified interface to a complex subsystem.
 eg. A TV remote → you press a button to “watch Netflix” instead of turning on the TV, setting input, launching app manually. The remote is the Facade.
 Facade is 1-many classes and hides internal complexity to deal with multiple classes
 */

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let candidateDetails = FacadeManager(developer: Developer(), project: Projects(), skill: Skills())
        let result = candidateDetails.developerDetailsToHire()
        print(result)
    }
}

class Developer {
    func fetchDeveloper() -> String {
        "Amber"
    }
}

class Projects {
    func fetchProject() -> String  {
        "Paytm"
    }
}

class Skills {
    func fetchSkills()  -> String {
        "Swift"
    }
}

class FacadeManager {
    let developer: Developer
    let project: Projects
    let skill: Skills
    
    //Injecting subsystems as dependencies
    init(developer: Developer, project: Projects, skill: Skills) {
        self.developer = developer
        self.project = project
        self.skill = skill
    }
    
    func developerDetailsToHire() -> (String, String, String) {
        //All complexity is here. From outside only need to call this method.
        //Here we are performing operations related to subsystems
        //One-to-many classes
        //Provide high level interface
        let candidate = developer.fetchDeveloper()
        let candidateProject = project.fetchProject()
        let candidateSkill = skill.fetchSkills()
        return(candidate, candidateProject, candidateSkill)
    }
}
