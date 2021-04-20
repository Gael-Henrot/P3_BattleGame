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

//Définition d'une partie
class Game {
    let player1 = Player (playerName: "Joueur 1")
    let player2 = Player (playerName: "Joueur 2")
    var gameTurn = 0
}

//Définition d'un joueur
class Player {
    let playerName: String
    let teamMaxNumber = 3 // Nombre maxi de personnages dans l'équipe
    var teamCounter = 1
    var team: [Character] = []
    
    init(playerName: String) {
        self.playerName = playerName
    }
}

//Fonction de lecture de la ligne de la console
func nonOptionalReadLine() -> String {
    if let line = readLine() {
        return line
    } else {
        return ""
    }
}

//Fonction qui permet de créer une équipe
func createATeam () {
    
}

//Fonction qui permet de demander un nom pour un personnage
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

//Définition d'un personnage standard
class Character {
    let name:String
    static var names: [String] = [] // Liste des noms de personnage déjà utilisés
    var life:Int
    var weapon:Weapon
    init (life:Int, weapon:Weapon) {
        self.weapon = weapon
        self.life = life
        self.name = askForCharacterName()
    }
}


//Problème de définition de l'arme (n'utilise pas les classes d'arme créées)
//Définition d'un chevalier
class Knight: Character {
    init() {
        super.init(life: 24, weapon: Weapon(damage: 4, weaponName: "Sword"))
    }
}

//Définition d'un nain
class Dwarf: Character {
    init() {
        super.init(life: 26, weapon: Weapon(damage: 3, weaponName: "Hammer"))
    }
}

//Définition d'un elfe
class Elv: Character {
    init() {
        super.init(life: 20, weapon: Weapon(damage: 5, weaponName: "Bow"))
    }
}

//===============================
//MARK: Weapon classes definition
//===============================

//Définition d'une arme standard
class Weapon {
    let damage: Int
    let weaponName: String
    
    init(damage: Int, weaponName: String) {
        self.damage = damage
        self.weaponName = weaponName
    }
}

//Définition d'une épée
class Sword: Weapon {
    init() {
        super.init(damage: 4 , weaponName: "Sword")
    }
}

//Définition d'un marteau
class Hammer: Weapon {
    init() {
        super.init(damage: 5 , weaponName: "Hammer")
    }
}

//Définition d'un arc
class Bow: Weapon {
    init() {
        super.init(damage: 6 , weaponName: "Bow")
    }
}

//===================
//MARK: GAME
//===================
var aGame = Game()
