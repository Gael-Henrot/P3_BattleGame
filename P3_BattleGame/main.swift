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

//========================
//MARK: Definition of a game
//========================

class Game {
    let player1 = Player ()
    let player2 = Player ()
    var roundCounter = 0 // Count the number of round
    let beginNumber = Int(arc4random_uniform(2)) // Allows to define the first player randomly
    
    func start() { // Function that start a game
        
        while player1.hasTeamAlive() && player2.hasTeamAlive() { // Loop that verified that all the players have an alive team
            let currentPlayer = playerTurn() // Define who is the current player
            let theOtherPlayer = otherPlayer() // Define who is the other player
            
            print("\(currentPlayer.playerName), choose the character in your team who will do the action by selecting among these numbers:")
            let currentCharacter: Character = currentPlayer.chooseACharacterInTeam() // Let do the current player choose a character in his team
            
            let action = askForAction()
            switch action {
            case "attack":
                currentCharacter.weapon = chest(currentCharacter: currentCharacter) // Activate the chest (can be a random weapon or let the current weapon)
                print("\(currentPlayer.playerName), choose the enemy character who will suffer the attack (by selecting number):")
                let characterToAttack = theOtherPlayer.chooseACharacterInTeam()
                currentCharacter.attack(characterAttacked: characterToAttack)
                print("\(currentCharacter.name) has attacked \(characterToAttack.name)")
                if characterToAttack.isAlive == false {
                    print("\(characterToAttack.name) is dead!")
                    }
            case "heal":
                print("\(currentPlayer.playerName), choose the character in your team who will be healed (by selecting number):")
                let characterToHeal = currentPlayer.chooseACharacterInTeam()
                currentCharacter.heal(characterHealed: characterToHeal)
                print("\(currentCharacter.name) has healed \(characterToHeal.name)")
            default: print("")
            }
            roundCounter += 1
        }
        
        // Endgame characteritics (it print the winner name and the state of each character (dead or alive or its LP))
        if player1.hasTeamAlive() == true {
            print("Well done \(player1.playerName)! You win the game !")
        } else {
            print("Well done \(player2.playerName)! You win the game !")
        }
        print("The game lasted \(roundCounter) rounds.")
        showEndCharacteristic(player: player1)
        showEndCharacteristic(player: player2)
    }
    
    func playerTurn() -> Player { // Define which player is the current character, beginNumber allows to choose the first player randomly
        if (roundCounter + beginNumber) % 2 == 0 {
            return player1
        } else {
            return player2
        }
    }
    
    func otherPlayer() -> Player { // Define which player is the other player (not current)
        if (roundCounter + beginNumber) % 2 == 0 {
            return player2
        } else {
            return player1
        }
    }
    
    func askForAction() -> String { // Allows the player to choose between to attack a character in the enemy team or to heal a character in his team
        print("What do you want to do?"
                + "\na. Attack an enemy character?"
                + "\nh. Heal a character in your team?")
        let action = nonOptionalReadLine()
        
        switch action {
        case "a": return "attack"
        case "h": return "heal"
        default:
            print("Wrong choice, choose a valid one.")
            return askForAction()
        }
    }
    
    func chest(currentCharacter:Character) -> Weapon { // this function decided if the chest appear or not
        let rightNumber:Int = 5 // define the number to do with the virtual dice to find the chest
        let dice:Int = Int(arc4random_uniform(6)) // represent the dice between 0 and 5
        let randomDamage:Int = Int(arc4random_uniform(15)) // define the random damage for the weapon in the chest (between 0 and 14)
        let randomWeapon:Weapon = Weapon(damage: randomDamage, weaponName: "Magic Wand") // define the random weapon as a magic wand with random damage
        var theWeaponSelected:Weapon
        if dice == rightNumber { // If the virtual dice do a 5, the current character weapon is replaced by the random weapon else the current character keep his current weapon.
            print("You found a chest !"
                    + "\nYou open it and now \(currentCharacter.name) have a \(randomWeapon.weaponName) with \(randomWeapon.damage) DP!")
            theWeaponSelected = randomWeapon
        } else {
            theWeaponSelected = currentCharacter.weapon
        }
        return theWeaponSelected
    }
    
    func showEndCharacteristic(player : Player) { // show the endgame characteritics for each character of one player: dead or alive with his remaining life points.
        print("Here the \(player.playerName)'s team:")
        for eachCharacter in player.team {
            if eachCharacter.isAlive == false {
                print("\(eachCharacter.name) is dead...")
            } else {
                print("\(eachCharacter.name) is still alive with \(eachCharacter.life) LP.")
            }
        }
    }
}

//==============================
// MARK: Definition of a player
//==============================

class Player {
    let playerName: String
    var team: [Character] = [] // List of character in the player team
    let teamMaxNumber = 3 // Maximal number of characters in one team
    static var names: [String] = [] // List of player names already used
    init() {
        func askForPlayerName() -> String { // Ask a player name, the player provide a name. If the name is already in the list of player names or if the name is empty, the fucntion ask for another name
            print("Player, what is your name?")
            let nameChoosed = nonOptionalReadLine()
            if Player.names.contains(nameChoosed) {
                print("This name is already used.")
                return askForPlayerName()
            } else if nameChoosed == "" {
                print("The name can not be empty.")
                return askForPlayerName()
            }
            Player.names.append(nameChoosed) // If the name is good, it added to the list of player names.
            return nameChoosed
        }
        
        self.playerName = askForPlayerName()
        while team.count < teamMaxNumber { // Execute this loop until all the team is complete (define by teamMaxNumber)
            print("\(playerName), choose your character number \(team.count + 1) by selecting among the following numbers:" // This give the characteristics of each possible character
                    + "\n0. A knight with 24 Life Points, a sword with 4 damages and who heal 3 LP."
                    + "\n1. A dwarf with 26 Life Points, a hammer with 5 damages and who heal 2 LP."
                    + "\n2. A elf with 22 Life Points, a bow with 3 damages and who heal 4 LP."
                    + "\n3. A magician with 15 Life Points, a stick with 2 damages and who heal 5 LP."
            )
            switch nonOptionalReadLine() { // The switch allows to add the character choosed to the team array.
            case "0":
                team.append(Knight())
            case "1":
                team.append(Dwarf())
            case "2":
                team.append(Elf())
            case "3":
                team.append(Magician())
            default:
                print("Wrong choice, choose a valid number.")
            }
        }
        print("\(playerName), your team is complete !" // Describes the choosed team by the player
                + "\nYour team is composed by a \(team[0].type) named \(team[0].name), a \(team[1].type) named \(team[1].name) and a \(team[2].type) named \(team[2].name).")
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
    
    func chooseACharacterInTeam() -> Character { // This function allows the player to choose a character in his team or in the other player team.
        var characterChoosed:Character
        if team[0].isAlive == true { // If the character is alive, his chacrateristics are displayed
            print("1. \(team[0].name) with \(team[0].life) LP, \(team[0].weapon.damage) DP and \(team[0].heal) HP")
        }
        if team[1].isAlive == true {
            print("2. \(team[1].name) with \(team[1].life) LP, \(team[1].weapon.damage) DP and \(team[1].heal) HP")
        }
        if team[2].isAlive == true {
            print("3. \(team[2].name) with \(team[2].life) LP, \(team[2].weapon.damage) DP and \(team[2].heal) HP")
        }
        print("Informations: LP = Life Points, DP = Damage Points, HP = Heal Points")
        
        switch nonOptionalReadLine() {
        case "1":
            if team[0].isAlive == true { // If the character is dead, the player can not select the character
                characterChoosed = team[0]
            } else {
                print("The character choosed is dead, please choose another one.")
                return chooseACharacterInTeam()
            }
        case "2":
            if team[1].isAlive == true {
                characterChoosed = team[1]
            } else {
                print("The character choosed is dead, please choose another one.")
                return chooseACharacterInTeam()
            }
        case "3":
            if team[2].isAlive == true {
                characterChoosed = team[2]
            } else {
                print("The character choosed is dead, please choose another one.")
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
    var life:Int // Life points
    let lifeMax:Int // Maximal life points that the character can have
    var weapon:Weapon
    var heal:Int // Heal points
    var isAlive: Bool = true // Verify if the character is alive or not
    var type:String // type of character (only used in description)
    init (type: String, life:Int, weapon:Weapon, heal:Int) {
        
        //This function ask a name for a character (can not be empty, same operation as askForPlayerName())
        func askForCharacterName() -> String {
            print("Please choose a name for your character:")
            let nameChoosed = nonOptionalReadLine()
            if Character.names.contains(nameChoosed) || Player.names.contains(nameChoosed){ // if the name is already used by an other player or a character or is empty, it ask another one.
                print("This name is already used.")
                return askForCharacterName()
            } else if nameChoosed == "" {
                print("The name can not be empty.")
                return askForCharacterName()
            }
            Character.names.append(nameChoosed)
            return nameChoosed
        }
        self.name = askForCharacterName()
        self.weapon = weapon
        self.life = life
        self.heal = heal
        self.lifeMax = life
        self.type = type
    }
    
    func attack(characterAttacked: Character) { // Allows a character to attack an other character
        characterAttacked.life -= weapon.damage
        if characterAttacked.life < 0 { // Set the life of attacked character to 0 if it becomes less than 0
            characterAttacked.life = 0
        }
        if characterAttacked.life == 0 { // if the life of the character is 0, the character is dead
            characterAttacked.isAlive = false
        }
    }
    
    func heal(characterHealed: Character) { // Allows a character to heal an other character
        characterHealed.life += heal
        if characterHealed.life > characterHealed.lifeMax { // Set the life of healed character to his max value if it becomes more than this value
            characterHealed.life = characterHealed.lifeMax
        }
    }
}

//Definition of a knight
class Knight: Character {
    init() {
        super.init(type: "knight", life: 24, weapon: Sword(), heal: 3)
    }
}

//Definition of a dwarf
class Dwarf: Character {
    init() {
        super.init(type: "dwarf", life: 26, weapon: Hammer(), heal: 2)
    }
}

//Definition of a elf
class Elf: Character {
    init() {
        super.init(type: "elf", life: 20, weapon: Bow(), heal: 4)
    }
}

//Definition of a magician
class Magician: Character {
    init() {
        super.init(type: "magician", life: 15, weapon: Stick(), heal: 5)
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
        super.init(damage: 4 , weaponName: "sword")
    }
}

//Definition of a warhammer
class Hammer: Weapon {
    init() {
        super.init(damage: 5 , weaponName: "hammer")
    }
}

//Definition of a bow
class Bow: Weapon {
    init() {
        super.init(damage: 3 , weaponName: "bow")
    }
}

//Definition of a fighting stick
class Stick: Weapon {
    init() {
        super.init(damage: 2 , weaponName: "stick")
    }
}

//===================
//MARK: Game program
//===================
var restartGame:Bool = true
func restartAGame() -> Bool { // Function that restart a game
    print ("Would you like to start a new game? Type y to start a new game.")
    Player.names.removeAll() // Clear the list of player names
    Character.names.removeAll() // Clear the list of character names
    let answer = nonOptionalReadLine()
    if answer == "y" {
        return true
    } else {
        return false
    }
}
// Display the instructions of the game
print("This game is a turn by turn two players game."
        + "\nThe first player will choose his 3 fighters team and the second player will do the same just after the first."
        + "\nWhen all teams are complete, the game can begin!"
        + "\nThe player will choose a character in his team, will choose an action (attack or heal) then choose a character which will suffer the action."
        + "\nThe last player with at least one character alive in his team win!"
        + "\nLet the game begin!")

while restartGame == true {
    let myGame = Game()
    myGame.start()
    restartGame = restartAGame()
}
