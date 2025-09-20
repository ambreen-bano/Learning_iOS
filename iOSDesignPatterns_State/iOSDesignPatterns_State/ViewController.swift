//
//  ViewController.swift
//  iOSDesignPatterns_State
//
//  Created by user2 on 20/09/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        callStates()
    }
}


/* Design Pattern - State Pattern
 Object changes depending on current state of the object at run time. Behavior changes automatically when state changes. Used in UI state management,  game states. eg. Media Player - play/pause states
 */

protocol PlayerStates {
    func play(states: StatesManager)
    func pause(states: StatesManager)
}

//Play State Object
class PlayState: PlayerStates {
    func play(states: StatesManager) {
        print("Same State - PlayState")
    }
    
    func pause(states: StatesManager) {
        //It was in Play state, now need to change state to pause.
        print("Change State - Pause")
        states.state = PauseState()
    }
}

//Pause State Object
class PauseState: PlayerStates {
    func play(states: StatesManager) {
        print("Change State - Play")
        states.state = PlayState()
    }
    
    func pause(states: StatesManager) {
        print("Same State - PauseState")
    }
}

class StatesManager {
    var state : PlayerStates
    init(state: PlayerStates) {
        self.state = state //First initial state injected
    }
    
    func playClicked() { //Some action happend, now need to change object state
        state.play(states: self)
    }
    
    func pauseClicked() { //Some action happend, now need to change object state
        state.pause(states: self)
    }
}

func callStates() {
    let object = StatesManager(state: PauseState())
    object.playClicked()
    object.playClicked()
}
