//
//  AlertMessage.swift
//  test_exomind_weather
//
//  Created by zhizi yuan on 28/07/2021.
//

import Foundation
struct AlertMessage: Equatable {
    let title: String
    let message: String

    static let unKown = AlertMessage(title: "Erreur", message: "Oups, un problème inconnu est survenu... veuillez réessayer ultérieurement.")
    static let internet = AlertMessage(title: "Erreur", message: "Oups, pas d'accès internet... Veuillez vérifier votre connexion Internet et réessayer.")
    static let serveur = AlertMessage(title: "Erreur", message: "Oups, un problème de serveur est survenu... veuillez réessayer ultérieurement.")
}
