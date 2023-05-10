//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Toni Mijatovic on 10/05/2023.
//

import SwiftUI

struct WeaponButton: View {
    var weapon: String
    var buttonHandler: (String) -> (Void)
    
    var body: some View {
        Button {
            buttonHandler(weapon)
        } label: {
            switch weapon {
                case "rock":
                    Text("🪨")
                case "paper":
                    Text("📄")
                case "scissors":
                    Text("✂️")
                default:
                    Text("🪨")
            }
        }.font(.system(size: 75))
    }
}

enum Weapon: String {
    case rock, paper, scissors
}

struct ContentView: View {
    @State private var weapons = ["rock", "paper", "scissors"]
    @State private var computerChoice = Int.random(in: 0...2)
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var computerScore = 0
    @State private var roundCounter = 0
    @State private var showScoreAlert = false
    @State private var showingEnd = false
    
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Spacer()
                Text("Pick rock, paper of scissors")
                    .foregroundStyle(.secondary)
                    .font(.subheadline.weight(.heavy))
                Spacer()
                ForEach(0..<3) { number in
                    WeaponButton(weapon: weapons[number], buttonHandler: pickedWeapon)
                }
                Spacer()
                Text("Score: \(score)")
                    .foregroundStyle(.secondary)
                    .font(.subheadline.weight(.heavy))
                Spacer()
            }
            .alert(scoreTitle, isPresented: $showScoreAlert) {
                Button("Continue", action: nextRound)
            } message: {
                Text("Your score is \(score)")
            }
            .alert("You have reached the end of the game.", isPresented: $showingEnd) {
                Button("Restart", action: restart)
            } message: {
                Text("Your final score is \(score), the computer's score is \(score). \n You have \(score > computerScore ? "won" : "lost") from the computer.")
            }
        }
    }
    
    func nextRound(){
        computerChoice = Int.random(in: 0...2)
    }
    
    func restart(){
        computerChoice = Int.random(in: 0...2)
        score = 0
        computerScore = 0
        roundCounter = 0
    }
    
    func pickedWeapon(weapon: String) {
        let computer = weapons[computerChoice]
        
        let tieMessage = "It is a tie! Your opponent also chose"
        let winMessage = "You won this round by choosing"
        let loseMessage = "You lost this round, your opponent chose"

        switch weapon {
            case computer:
                scoreTitle = "\(tieMessage) \(computer)"
            case Weapon.rock.rawValue:
                scoreTitle = computer == Weapon.scissors.rawValue ? "\(winMessage) \(weapon)!" : "\(loseMessage) \(computer)"
            case Weapon.paper.rawValue:
                scoreTitle = computer == Weapon.rock.rawValue ? "\(winMessage) \(weapon)!" : "\(loseMessage) \(computer)"
            case Weapon.scissors.rawValue:
                scoreTitle = computer == Weapon.paper.rawValue ? "\(winMessage) \(weapon)!" : "\(loseMessage) \(computer)"
            default:
                scoreTitle = "Invalid weapon"
        }
        
        if(scoreTitle.contains(winMessage)){
            score+=1
            computerScore = (computerScore > 0) ? (computerScore - 1) : 0
        } else if(scoreTitle.contains(loseMessage)){
            score = (score > 0) ? (score - 1) : 0
            computerScore+=1
        }
    
        roundCounter+=1
        showScoreAlert = true
        
        if(roundCounter == 10){
            showingEnd = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
