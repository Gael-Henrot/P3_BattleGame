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
    var roundCounter = 0 // Count the number of round
    
    func start() { // Function that begin a game
        while player1.haveTeamAlive() && player2.haveTeamAlive() { // Loop that verified that all the players have an alive team
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
            case "heal":
                let characterToHeal = currentPlayer.chooseACharacterInTeam()
                currentCharacter.heal(characterHealed: characterToHeal)
                print("\(currentCharacter.name) has healed \(characterToHeal.name)")
            default :
                print("error")
            }
            
            roundCounter += 1
        }
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
    
    enum ActionType {
        case attack
        case heal
//        case specialPower   For later
    }
    
    func askForActionType() -> ActionType {
        print("Choose your action: 1. attack 2. heal")
        let action = nonOptionalReadLine()
        
        switch action {
        case "1": return .attack
        case "2": return .heal
        default:
            print("Wrong choice, choose a valid number.")
            return askForActionType()
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

let myGame = Game()
myGame.start()

//Definition of a player
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
    
    func haveTeamAlive() -> Bool { //function which verify if each character in a team is alive
        var alive = false
        for character in team {
            if character.life > 0 {
                alive = true
            }
        }
        return alive
    }
    
    /*func attackWithCharacter() {
        if activePlayer.playerName == aGame.player1.playerName {
            passivePlayer = aGame.player2
        } else {
            passivePlayer = aGame.player1
        }
        let characterAttacker = chooseATeamCharacter()
        activeCharacter = characterAttacker
        let characterAttacked = chooseAnEnemyCharacter()
        passiveCharacter = characterAttacked
        characterAttacker.attack(characterAttacked: characterAttacked)
        if characterAttacked.life < 0 {
            characterAttacked.life = 0
        }
        print("\(activePlayer.playerName), \(activeCharacter.name) attacked \(passiveCharacter.name)")
    }
    
    func healWithCharacter() {
        if activePlayer.playerName == aGame.player1.playerName {
            passivePlayer = aGame.player1
        } else {
            passivePlayer = aGame.player2
        }
        let characterHealer = chooseATeamCharacter()
        activeCharacter = characterHealer
        let characterHealed = chooseATeamCharacter()
        passiveCharacter = characterHealed
        characterHealer.heal(characterHealed: characterHealed)
        print("\(activePlayer.playerName), \(activeCharacter.name) healed \(passiveCharacter.name)")
    }*/
    
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
        print("This name is already used")
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
            print("\(characterAttacked.name) is dead!")
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
//MARK: Game progress
//===================
/*var aGame = Game()
print("\(aGame.player1.playerName), here your team \(aGame.player1.team)") // This line give the composition of player 1 team
print("\(aGame.player2.playerName), here your team \(aGame.player2.team)") // This line give the composition of player 2 team

var activePlayer:Player = aGame.player1
var passivePlayer = aGame.player2
var activeCharacter = aGame.player1.team[0]
var passiveCharacter = aGame.player2.team[0]

func chooseATeamCharacter() -> Character { //Allows to chose a character in the player team
    var characterChoosed: Character?
    print("\(activePlayer.playerName), choose a character in your team by selecting among the following numbers:"
            + "\n 1. \(activePlayer.team[0]) named \(activePlayer.team[0].name)  (\(activePlayer.team[0].life)LP and \(activePlayer.team[0].heal)HP)"
            + "\n 2. \(activePlayer.team[1]) named \(activePlayer.team[1].name)  (\(activePlayer.team[1].life)LP and \(activePlayer.team[1].heal)HP)"
            + "\n 3. \(activePlayer.team[2]) named \(activePlayer.team[2].name)  (\(activePlayer.team[2].life)LP and \(activePlayer.team[2].heal)HP)"
    )
    switch nonOptionalReadLine() {
    case "1":
        if activeCharacter.life != 0 || passiveCharacter.life != 0 {
            characterChoosed = activePlayer.team[0]
        } else {
            print("Character dead, please choose another one")
            return chooseATeamCharacter()
        }
    case "2":
        if activeCharacter.life != 0 || passiveCharacter.life != 0 {
            characterChoosed = activePlayer.team[1]
        } else {
            print("Character dead, please choose another one")
            return chooseATeamCharacter()
        }
    case "3":
        if activeCharacter.life != 0 || passiveCharacter.life != 0 {
            characterChoosed = activePlayer.team[2]
        } else {
            print("Character dead, please choose another one")
            return chooseATeamCharacter()
        }
    default:
        print("Wrong choice, choose a valid number.")
        return chooseATeamCharacter()
    }
    return characterChoosed!
}

func chooseAnEnemyCharacter() -> Character { // Allows to chose a character in the enemy team
    var characterChoosed: Character?
    print("\(activePlayer.playerName), choose an enemy character by selecting among the following numbers:"
            + "\n 1. \(passivePlayer.team[0]) named \(passivePlayer.team[0].name)  (\(passivePlayer.team[0].life)LP and \(passivePlayer.team[0].heal)HP)"
            + "\n 2. \(passivePlayer.team[1]) named \(passivePlayer.team[1].name)  (\(passivePlayer.team[1].life)LP and \(passivePlayer.team[1].heal)HP)"
            + "\n 3. \(passivePlayer.team[2]) named \(passivePlayer.team[2].name)  (\(passivePlayer.team[2].life)LP and \(passivePlayer.team[2].heal)HP)"
    )
    
    switch nonOptionalReadLine() {
    case "1":
        if passiveCharacter.life != 0 {
        characterChoosed = passivePlayer.team[0]
        } else {
            print("Character dead, please choose another one")
            return chooseAnEnemyCharacter()
        }
    case "2":
        if passiveCharacter.life != 0 {
        characterChoosed = passivePlayer.team[1]
        } else {
            print("Character dead, please choose another one")
            return chooseAnEnemyCharacter()
        }
    case "3":
        if passiveCharacter.life != 0 {
        characterChoosed = passivePlayer.team[2]
        } else {
            print("Character dead, please choose another one")
            return chooseAnEnemyCharacter()
        }
    default:
        print("Wrong choice, choose a valid number.")
        return chooseAnEnemyCharacter()
    }
    return characterChoosed!
}

}
while (aGame.player1.team[0].life + aGame.player1.team[1].life + aGame.player1.team[2].life) > 0 || (aGame.player2.team[0].life + aGame.player2.team[1].life + aGame.player2.team[2].life) > 0 {
    print ("Active player before round is \(activePlayer.playerName) and active character is \(activeCharacter.name). Passive player is \(passivePlayer.playerName) and passive Character is \(passiveCharacter.name)")
    chooseAnAction()
    print ("Active player after round is \(activePlayer.playerName) and active character is \(activeCharacter.name). Passive player is \(passivePlayer.playerName) and passive Character is \(passiveCharacter.name)")
    if activePlayer.playerName == aGame.player1.playerName {
        activePlayer = aGame.player2
    } else { activePlayer = aGame.player1}
    aGame.roundCounter += 1
}*/
