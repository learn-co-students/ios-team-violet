import Foundation
import UIKit

final class DataStore {
    
    static let singleton = DataStore()
    
    let defaults = UserDefaults.standard
    var user: User!
    
    private init(){
        let userName = defaults.value(forKey: "username") as? String ?? nil
        let totalProps = defaults.value(forKey: "totalProps") as? Int ?? 0
        let unlockedCoaches = defaults.value(forKey: "unlockedCoaches") as? [String] ?? ["Pops"]
        let appNames = defaults.value(forKey: "appNames") as? [String] ?? ["Messages", "Email", "Facebook"]
        self.user = User(userName: userName, totalProps: totalProps, unlockedCoachNames: unlockedCoaches, appNames: appNames, currentCoach: getCurrentCoach(), currentSession: nil)
    }
    
    func getCurrentCoach() -> Coach {
        let coachName = defaults.value(forKey: "coachName") as? String ?? "Pops"
        let currentCoach = generateCoachFrom(name: coachName)
        return currentCoach
    }
    
    private func generateCoachFrom(name coachName: String) -> Coach {
        switch coachName {
        case "Pops":
            return generatePops()
        case "Baba":
            return generateBaba()
        case "Chad":
            return generateChad()
        default:
            return generatePops()
        }
    }
}

private extension DataStore {
    func generatePops() -> Coach {
        let name = "Pops"
        let icon = UIImage(named: "IC_POPS")
        let difficulty = DifficultySetting.standard
        let tapStatements = [
            ("Hey!", "Hands off, buddy!")
        ]
        let introStatements = [
            ("Ready to make me proud today?", "How long are you looking to stay productive for?")
        ]
        let setSessionStatements = [
            [("Only an hour?", "Seems like you could do better.")],
            [("Two hours.", "That's respectable.")],
            [("Three hours!", "Good for you!")],
            [("Four hours, huh?", "I'm Impressive!")],
            [("Five hours?", "You're really going for it today!")],
            [("Hmmmmm...", "As long as you take your breaks, this should be okay.")],
            [("Seven hours!", "What an odd choice!")],
            [("Dear lord!", "Don't hurt yourself, sonny!")],
            ]
        let productivityStatements = [
            ("Place your phone FACE DOWN on a FLAT SURFACE (like a table).", "I’ll tell you to take a break when the timer hits 0. Don’t even think about touching your phone before then.")
        ]
        let productivityReprimands = [
            ("Put your phone face down!", "You just lost 100 Props because you shouldn't be touching your phone right now!")
        ]
        let productivityNotificationStatements = [
            ("Notification Title", "Notification Body")
        ]
        let breakStatements = [
            ("Think about it...", "Success in almost any field depends more on energy and drive than it does on intelligence. This explains why we have so many stupid leaders.")
        ]
        let breakNotificationStatements = [
            ("Notification Title", "Notification Body")
        ]
        let endSessionStatements = [
            ("2 hours already went by!", "I'd be super proud if you stayed productive for at least one more hour.")
        ]
        let pops = Coach(
            name: name,
            icon: icon,
            difficulty: difficulty,
            tapStatements: tapStatements,
            introStatements: introStatements,
            setSessionStatements: setSessionStatements,
            productivityStatements: productivityStatements,
            productivityReprimands: productivityReprimands,
            productivityNotificationStatements: productivityNotificationStatements,
            breakStatements: breakStatements,
            breakNotificationStatements: breakNotificationStatements,
            endSessionStatements: endSessionStatements,
            breakView: PopsBreakView())
        return pops
    }
    
    func generateBaba() -> Coach {
        let name = "Baba"
        let icon: UIImage? = nil
        let difficulty = DifficultySetting.easy
        let tapStatements = [
            ("Hey!", "Hands off, buddy!")
        ]
        let introStatements = [
            ("Hey there, I'm Pops!", "Make me proud by putting in a hard day's work!")
        ]
        let setSessionStatements = [
            [("Only an hour?", "Seems like you could do better.")],
            [("Two hours.", "That's respectable.")],
            [("Three hours!", "Good for you!")],
            [("Four hours, huh?", "I'm Impressive!")],
            [("Five hours?", "You're really going for it today!")],
            [("Hmmmmm...", "As long as you take your breaks, this should be okay.")],
            [("Seven hours!", "What an odd choice!")],
            [("Dear lord!", "Don't hurt yourself, sonny!")],
            ]
        let productivityStatements = [
            ("Lock your phone now.", "I’ll tell you to take a break when the timer hits 0. Don’t even think about touching your phone before then.")
        ]
        let productivityReprimands = [
            ("You just lost 100 props", "Get back to work!")
        ]
        let productivityNotificationStatements = [
            ("Notification Title", "Notification Body")
        ]
        let breakStatements = [
            ("Congrats on your first 5 minute break!", "Do whatever! I thought you may want to catch up on texts, email, and Facebook, so I gave you easy access to those apps below. If you have nothing else to do, I can entertain you."),
            ("Congrats!", "Enjoy your break!")
        ]
        let breakNotificationStatements = [
            ("Notification Title", "Notification Body")
        ]
        let endSessionStatements = [
            ("Congrats!", "See you soon!")
        ]
        let baba = Coach(
            name: name,
            icon: icon,
            difficulty: difficulty,
            tapStatements: tapStatements,
            introStatements: introStatements,
            setSessionStatements: setSessionStatements,
            productivityStatements: productivityStatements,
            productivityReprimands: productivityReprimands,
            productivityNotificationStatements: productivityNotificationStatements,
            breakStatements: breakStatements,
            breakNotificationStatements: breakNotificationStatements,
            endSessionStatements: endSessionStatements,
            breakView: BabaBreakView())
        return baba
    }
    
    
    func generateChad() -> Coach {
        let name = "Chad"
        let icon: UIImage? = nil
        let difficulty = DifficultySetting.hard
        let tapStatements = [
            ("Hey!", "Hands off, buddy!")
        ]
        let introStatements = [
            ("Hey there, I'm Pops!", "Make me proud by putting in a hard day's work!")
        ]
        let setSessionStatements = [
            [("Only an hour?", "Seems like you could do better.")],
            [("Two hours.", "That's respectable.")],
            [("Three hours!", "Good for you!")],
            [("Four hours, huh?", "I'm Impressive!")],
            [("Five hours?", "You're really going for it today!")],
            [("Hmmmmm...", "As long as you take your breaks, this should be okay.")],
            [("Seven hours!", "What an odd choice!")],
            [("Dear lord!", "Don't hurt yourself, sonny!")],
            ]
        let productivityStatements = [
            ("Lock your phone now.", "I’ll tell you to take a break when the timer hits 0. Don’t even think about touching your phone before then.")
        ]
        let productivityReprimands = [
            ("You just lost 100 props", "Get back to work!")
        ]
        let productivityNotificationStatements = [
            ("Notification Title", "Notification Body")
        ]
        let breakStatements = [
            ("Congrats on your first 5 minute break!", "Do whatever! I thought you may want to catch up on texts, email, and Facebook, so I gave you easy access to those apps below. If you have nothing else to do, I can entertain you."),
            ("Quote of the day...", "Success in almost any field depends more on energy and drive than it does on intelligence. This explains why we have so many stupid leaders. - Sloan Wilson")
        ]
        let breakNotificationStatements = [
            ("Notification Title", "Notification Body")
        ]
        let endSessionStatements = [
            ("Congrats!", "See you soon!")
        ]
        let chad = Coach(
            name: name,
            icon: icon,
            difficulty: difficulty,
            tapStatements: tapStatements,
            introStatements: introStatements,
            setSessionStatements: setSessionStatements,
            productivityStatements: productivityStatements,
            productivityReprimands: productivityReprimands,
            productivityNotificationStatements: productivityNotificationStatements,
            breakStatements: breakStatements,
            breakNotificationStatements: breakNotificationStatements,
            endSessionStatements: endSessionStatements,
            breakView: ChadBreakView())
        return chad
    }
}
