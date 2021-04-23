//
//  main.swift
//  P3_BattleGame
//
//  Created by Gaël HENROT on 19/04/2021.
//

import Foundation

//======================
//MARK: Global functions
//======================

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
    print("Player, what is your name?")
    let nameChoosed = nonOptionalReadLine()
    if Player.names.contains(nameChoosed) {
        print("This name is already used.")
        return askForPlayerName()
    } else if nameChoosed == "" {
        print("The name can not be empty.")
        return askForPlayerName()
    }
    Player.names.append(nameChoosed)
    return nameChoosed
}

//This function ask a name for a character (can not be empty)
func askForCharacterName() -> String {
    print("Please choose a name for your character:")
    let nameChoosed = nonOptionalReadLine()
    if Character.names.contains(nameChoosed) || Player.names.contains(nameChoosed){ // if the name is already used or is empty, it ask another one.
        print("This name is already used.")
        return askForCharacterName()
    } else if nameChoosed == "" {
        print("The name can not be empty.")
        return askForCharacterName()
    }
    Character.names.append(nameChoosed)
    return nameChoosed
}

//========================
//MARK: Definition of a game
//========================

class Game {
    let player1 = Player ()
    let player2 = Player ()
    var roundCounter = 0 // Count the number of round
    
    func start() { // Function that start a game
        while player1.hasTeamAlive() && player2.hasTeamAlive() { // Loop that verified that all the players have an alive team
            let currentPlayer = playerTurn() // Define who is the current player
            let theOtherPlayer = otherPlayer() // Define who is the other player
            
            print("\(currentPlayer.playerName), choose a character in your team who will do the action:")
            let currentCharacter: Character = currentPlayer.chooseACharacterInTeam()
            
            let action = askForAction()
            switch action {
            case "attack":
                let characterToAttack = theOtherPlayer.chooseACharacterInTeam()
                currentCharacter.attack(characterAttacked: characterToAttack)
                print("\(currentCharacter.name) has attacked \(characterToAttack.name)")
                if characterToAttack.isAlive == false {
                    print("\(characterToAttack.name) is dead!")
                }
            case "heal":
                let characterToHeal = currentPlayer.chooseACharacterInTeam()
                currentCharacter.heal(characterHealed: characterToHeal)
                print("\(currentCharacter.name) has healed \(characterToHeal.name)")
            default :
                print("")
            }
            roundCounter += 1
        }
        if player1.hasTeamAlive() == true {
            print("Well done \(player1.playerName)! You win the game")
        } else {
            print("Well done \(player2.playerName)! You win the game")
        }
        print("The game lasted \(roundCounter) rounds."
                + "\nHere the \(player1.playerName)'s team:"
                + "\n\(player1.team[0].name) with \(player1.team[0].life) LP."
                + "\n\(player1.team[1].name) with \(player1.team[1].life) LP."
                + "\n\(player1.team[2].name) with \(player1.team[2].life) LP."
                + "\nHere the \(player2.playerName)'s team:"
                + "\n\(player2.team[0].name) with \(player2.team[0].life) LP."
                + "\n\(player2.team[1].name) with \(player2.team[1].life) LP."
                + "\n\(player2.team[2].name) with \(player2.team[2].life) LP."
        
        
        )
    }
    
    func playerTurn() -> Player { // Define which player is the current character
        if roundCounter % 2 == 0 {
            return player1
        } else {
            return player2
        }
    }
    
    func otherPlayer() -> Player { // Define which player is the other player (not current)
        if roundCounter % 2 == 0 {
            return player2
        } else {
            return player1
        }
    }
    
    func askForAction() -> String {
        print("What do you want to do?"
        + "\n1. Attack an enemy character?"
        + "\n2. Heal a character in your team?")
        let action = nonOptionalReadLine()
        
        switch action {
        case "1": return "attack"
        case "2": return "heal"
        default:
            print("Wrong choice, choose a valid number.")
            return askForAction()
        }
        
    }
}
/*
enum ActionType {
    case attack
    case heal
    case specialPower
    
    func description() -> String {
        switch self {
        case .attack:
            return "Action d'attaque sur un adversaire"
        case .heal:
            return "Action de soin sur un personnage de son equipe"
        case .specialPower:
            return "Attaque speciale !!"
        }
    }
}

func askForActionType() -> ActionType {
    print("choose: 1. attack 2. heal")
    let value = nonOptionalReadLine()
    
    switch value {
    case "1": return .attack
    case "2": return .heal
    default:
        print("incorrect choice")
        return askForActionType()
    }
    
    if value == "1" {
        return ActionType.attack
    } else if value == "2" {
        return ActionType.heal
    } else {
        print("incorrect choice")
        return askForActionType()
    }
}

let myChoice = askForActionType()
print("Vous venez de choisir \(myChoice), voici sa description: \(myChoice.description())")
switch myChoice {
case .attack:
    print("ok je fais une attacke")
case .heal:
    print("ok je fais un soin")
case .specialPower:
    print("Oula c'est une attaque speciale")
}
*/
//==============================
// MARK: Definition of a player
//==============================

class Player {
    let playerName: String
    var team: [Character] = []
    let teamMaxNumber = 3 // Maximal number of characters in one team
    static var names: [String] = []
    init() {
        self.playerName = askForPlayerName()
        while team.count < teamMaxNumber { // Execute this loop until all the team is complete
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
        print("\(playerName), your team is complete !")
    }
    
    func hasTeamAlive() -> Bool { //function which verify if each character in a team is alive
        var alive = false
        for character in team {
            if character.life > 0 {
                alive = true
            }
        }
        return alive
    }
    
    func chooseACharacterInTeam() -> Character {
        var characterChoosed:Character
        print("Please choose a character:"
            + "\n 1. \(team[0].name) with \(team[0].life)LP, \(team[0].weapon.damage) DP and \(team[0].heal) HP"
            + "\n 2. \(team[1].name) with \(team[1].life)LP, \(team[1].weapon.damage) DP and \(team[1].heal) HP"
            + "\n 3. \(team[2].name) with \(team[2].life)LP, \(team[2].weapon.damage) DP and \(team[2].heal) HP"
        + "\n Informations: If a character is dead, you can not choose him (LP = 0).\n LP = Life Points, DP = Damage Points, HP = Heal Points")
        switch nonOptionalReadLine() {
        case "1":
            if team[0].isAlive == true { // If the character is dead, the player can not select the character
                characterChoosed = team[0]
            } else {
                print("The character choosed is dead, please choose another one")
                return chooseACharacterInTeam()
            }
        case "2":
            if team[1].isAlive == true {
                characterChoosed = team[1]
            } else {
                print("The character choosed is dead, please choose another one")
                return chooseACharacterInTeam()
            }
        case "3":
            if team[2].isAlive == true {
                characterChoosed = team[2]
            } else {
                print("The character choosed is dead, please choose another one")
                return chooseACharacterInTeam()
            }
        default:
            print("Wrong choice, choose a valid number.")
            return chooseACharacterInTeam()
        }
        return characterChoosed
    }
}

//=================================
//MARK: Character classes definition
//=================================

//Definition of a standard character
class Character {
    let name:String
    static var names: [String] = [] // List of character names already used
    var life:Int
    let lifeMax:Int
    var weapon:Weapon
    var heal:Int
    var isAlive: Bool = true
    init (life:Int, weapon:Weapon, heal:Int) {
        self.name = askForCharacterName()
        self.weapon = weapon
        self.life = life
        self.heal = heal
        self.lifeMax = life
    }
    
    func attack(characterAttacked: Character) {
        characterAttacked.life -= weapon.damage
        if characterAttacked.life < 0 { // This IF set the life of attacked character to 0 if it becomes less than 0
            characterAttacked.life = 0
        }
        if characterAttacked.life == 0 { //This IF define that is the life of the character is 0, the character is dead
            characterAttacked.isAlive = false
        }
    }
    
    func heal(characterHealed: Character) {
        characterHealed.life += heal
        if characterHealed.life > characterHealed.lifeMax { // This IF set the life of healed character to his max value if it becomes more than this value
            characterHealed.life = characterHealed.lifeMax
        }
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
//MARK: Game program
//===================

let myGame = Game()
myGame.start()

/*var aGame = Game()
print("\(aGame.player1.playerName), here your team \(aGame.player1.team)") // This line give the composition of player 1 team
print("\(aGame.player2.playerName), here your team \(aGame.player2.team)") // This line give the composition of player 2 team
*/
