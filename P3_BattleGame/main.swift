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
    let player1 = Player (playerName: "Joueur 1")
    let player2 = Player (playerName: "Joueur 2")
    var gameRound = 0
}

//Definition of a player
class Player {
    let playerName: String
    var team: [Character]
    
    init(playerName: String) {
        self.playerName = playerName
        self.team = createATeam()
    }
}

//This function create a team
func createATeam () -> [Character] {
    let teamMaxNumber = 3 // Maximal number of characters in one team
    var team: [Character] = []
    while team.count < teamMaxNumber {
        print("Choose your character number \(team.count + 1):"
        + "\n 0. A knight with X Life Points, a X with X damages and who heal X LP"
        + "\n 1. A dwarf with X Life Points, a X with X damages and who heal X LP"
        + "\n 2. A elf with X Life Points, a X with X damages and who heal X LP"
        )
        switch nonOptionalReadLine() {
        case "0":
            let characterChoosed = Knight()
            team.append(characterChoosed)
        case "1":
            let characterChoosed = Dwarf()
            team.append(characterChoosed)
        case "2":
            let characterChoosed = Elf()
            team.append(characterChoosed)
        default:
            print("Wrong choice")
        }
    }
    print("The team is complete.")
    return team
}


//This function read the console line (avoid optional)
func nonOptionalReadLine() -> String {
    if let line = readLine() {
        return line
    } else {
        return ""
    }
}

//This function ask a name for a character (can not be empty)
func askForCharacterName() -> String {
    let nameChoosed = nonOptionalReadLine()
    print("Veuillez choisir un nom:")
    if Character.names.contains(nameChoosed) || nameChoosed == "" { // si le nom est déjà utilisé ou s'il ne remplit rien, cela redemande un nom
        print("Ce nom est déjà utilisé.")
        return askForCharacterName()
    }
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
