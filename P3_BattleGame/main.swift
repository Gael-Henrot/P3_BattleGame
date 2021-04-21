//
//  main.swift
//  P3_BattleGame
//
//  Created by Gaël HENROT on 19/04/2021.
//

import Foundation

//========================
//MARK: Initialization
//========================

//Definition of a game
class Game {
    let player1 = Player ()
    let player2 = Player ()
    var gameRound = 0
}

//Definition of a player
class Player {
    let playerName: String
    var team: [Character] = []
    let teamMaxNumber = 3 // Maximal number of characters in one team
    static var names: [String] = []
    init() {
        self.playerName = askForPlayerName()
        while team.count < teamMaxNumber {
            print("\(playerName), choose your character number \(team.count + 1) by selecting among the following numbers:"
            + "\n 0. A knight with X Life Points, a X with X damages and who heal X LP"
            + "\n 1. A dwarf with X Life Points, a X with X damages and who heal X LP"
            + "\n 2. A elf with X Life Points, a X with X damages and who heal X LP"
            )
            switch nonOptionalReadLine() {
            case "0":
                team.append(Knight())
            case "1":
                team.append(Dwarf())
            case "2":
                team.append(Elf())
            default:
                print("Wrong choice, choose a valid number.")
            }
        }
        print("your team is complete !")
    }
}

//This function read the console line (avoid optional)
func nonOptionalReadLine() -> String {
    if let line = readLine() {
        return line
    } else {
        return ""
    }
}
//This function ask a name for a player (can not be empty)
func askForPlayerName() -> String {
    print("Player, please choose a name:")
    let nameChoosed = nonOptionalReadLine()
    if Player.names.contains(nameChoosed) || nameChoosed == ""{
        print("This name is already used.")
        return askForPlayerName()
    }
    Player.names.append(nameChoosed)
    return nameChoosed
}

//This function ask a name for a character (can not be empty)
func askForCharacterName() -> String {
    print("Please choose a name for your character:")
    let nameChoosed = nonOptionalReadLine()
    if Character.names.contains(nameChoosed) || nameChoosed == "" || Player.names.contains(nameChoosed){ // if the name is already used or is empty, it ask another one.
        print("This name is already used.")
        return askForCharacterName()
    }
    Character.names.append(nameChoosed)
    return nameChoosed
}

//=================================
//MARK: Character classes definition
//=================================

//Definition of a standard character
class Character {
    let name:String
    static var names: [String] = [] // List of character names already used
    var life:Int
    var weapon:Weapon
    var heal:Int
    init (life:Int, weapon:Weapon, heal:Int) {
        self.name = askForCharacterName()
        self.weapon = weapon
        self.life = life
        self.heal = heal
        
    }
}


//Trouble: these classes are not using the weapon classes!!
//Definition of a knight
class Knight: Character {
    init() {
        super.init(life: 24, weapon: Weapon(damage: 4, weaponName: "Sword"), heal: 2)
    }
}

//Definition of a dwarf
class Dwarf: Character {
    init() {
        super.init(life: 26, weapon: Weapon(damage: 3, weaponName: "Hammer"), heal: 2)
    }
}

//Definition of a elf
class Elf: Character {
    init() {
        super.init(life: 20, weapon: Weapon(damage: 5, weaponName: "Bow"), heal: 3)
    }
}

//===============================
//MARK: Weapon classes definition
//===============================

//Definition of a standard weapon
class Weapon {
    let damage: Int
    let weaponName: String
    
    init(damage: Int, weaponName: String) {
        self.damage = damage
        self.weaponName = weaponName
    }
}

//Definition of a sword
class Sword: Weapon {
    init() {
        super.init(damage: 4 , weaponName: "Sword")
    }
}

//Definition of a warhammer
class Hammer: Weapon {
    init() {
        super.init(damage: 5 , weaponName: "Hammer")
    }
}

//Definition of a bow
class Bow: Weapon {
    init() {
        super.init(damage: 6 , weaponName: "Bow")
    }
}

//===================
//MARK: GAME
//===================
var aGame = Game()
print("\(aGame.player1.playerName), here your team \(aGame.player1.team)") // This line give the composition of player 1 team
print("\(aGame.player2.playerName), here your team \(aGame.player2.team)") // This line give the composition of player 2 team
