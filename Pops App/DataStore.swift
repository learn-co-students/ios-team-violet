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
            ("Hey!", "Get your sweaty finger off of me or you'll be sorry!")
        ]
        let introStatements = [
            ("Make me proud today, sonny.", "How long are you looking to stay productive for?")
        ]
        let setSessionStatements = [
            [("Only an hour?", "Seems like you could do better.  That's really not a lot.")],
            [("Two hours...", "In my day, two hours of work didn't amount to jack squat.")],
            [("Hmmmmm...", "Three hours should be enough to get SOMETHING done at least.")],
            [("Four hours, huh?", "I'm almost impressed!  But almost isn't everything.")],
            [("Five hours!", "Maybe my friends at the bridge club were wrong about you...")],
            [("Really?", "You might actually EARN your breaks today with that much work to be done.")],
            [("Seven hours...", "Seems like a weird choice.  Why not six or eight?")],
            [("My garsh!", "Don't hurt yourself!  Even in my heyday I didn't push myself like that.")],
            ]
        let productivityStatements = [
            ("Place your phone face down now.", "I’ll tell you to take a break when the timer hits 0. Don’t even think about touching your phone before then.")
        ]
        let productivityReprimands = [
            ("Put your phone back down!", "I'm taking away 500 Props because you shouldn't be touching your phone right now!")
        ]
        let productivityNotificationStatements = [
            ("Time for a quick break!", "Wrap up your final thoughts and take a 5 minute 'phone break' when ready.")
        ]
        let breakStatements = [
            ("Take a breather", "If you're interested I dug up some of my favorite YouTube vids."),
            ("Think about it...", "Success in almost any field depends more on energy and drive than it does on intelligence. This explains why we have so many stupid leaders.")
        ]
        let breakNotificationStatements = [
            ("Break time is over!", "Head back to the app and get to work. Pops will start deducting props if you aren't back in 30 seconds.")
        ]
        let endSessionStatements = [
            ("You reached the end, sonny.", "If you want to make me REALLY proud you should put in just one more hour...")
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
            breakButtonText: "see pops picks",
            breakNotificationStatements: breakNotificationStatements,
            endSessionStatements: endSessionStatements,
            breakView: PopsBreakView())
        return pops
    }
    
    func generateBaba() -> Coach {
        let name = "Baba"
        let icon = UIImage(named: "IC_BABA")
        let difficulty = DifficultySetting.easy
        let tapStatements = [
            ("Ouch!", "Please be respectful of your elders, your Baba is fragile.")
        ]
        let introStatements = [
            ("I missed you, poopsik!", "Your Baba just knows you're going to do your best today.")
        ]
        let setSessionStatements = [
            [("A whole hour!", "Remember, poopsik.  All that matters is that you try hard.")],
            [("Two hours!!", "Your Baba is so proud of you already!")],
            [("Three hours!", "Poopsik, you are really ambitious today.")],
            [("Baba's so proud!!", "You can be anything you want if you put your mind to it!")],
            [("My Poopsik!", "You're really going for it today!  Your Baba is so happy!")],
            [("You are incredible!", "I'll make sure to give you plenty of breaks.")],
            [("Seven hours!", "Poopsik, don't overwork yourself.  That is a long time.")],
            [("Are you sure?", "Baba is so happy you're going to spend so long with her!")],
            ]
        let productivityStatements = [
            ("Poopsik, put your phone face down.", "Your Baba will make sure you get plenty of breaks, so don't worry!")
        ]
        let productivityReprimands = [
            ("Oh, you're supposed to be working...", "But that's okay, your Baba's so happy to see you!")
        ]
        let productivityNotificationStatements = [
            ("It's time for a break!", "Your Baba would be really happy if you spent some time with her.")
        ]
        let breakStatements = [
            ("How are you, Poopsik?", "I tried sending you some emails while you were working, let me know if you get them.")
        ]
        let breakNotificationStatements = [
            ("Oh, it's time to get to work", "Make sure you don't push yourself too hard.")
        ]
        let endSessionStatements = [
            ("Baba's so proud of her Poopsik!", "If you did another hour we could spend even more time together...")
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
            breakButtonText: "check email",
            breakNotificationStatements: breakNotificationStatements,
            endSessionStatements: endSessionStatements,
            breakView: BabaBreakView())
        return baba
    }
    
    
    func generateChad() -> Coach {
        let name = "Chad"
        let icon = UIImage(named: "IC_CHAD")
        let difficulty = DifficultySetting.hard
        let tapStatements = [
            ("Yo, bro!", "If you value your health you'd better stop that right now.")
        ]
        let introStatements = [
            ("Chad here.", "No chance in heck a wimp like you could impress me")
        ]
        let setSessionStatements = [
            [("LOL", "Why even bother!?  Your gains will be mad weak, bro.")],
            [("That's all?", "Bro, my kid sister works harder than that at her preschool.")],
            [("Bro...", "If you're not gonna go hard, why go at all?!  Pathetic...")],
            [("Wow.", "The bare minimum of respectable, you deserve a medal.")],
            [("Five whole hours.", "But what can be done in five that couldn't be done better in six?")],
            [("Yo.", "Six still isn't enough if you want to be like me, bro.  Like that's possible.")],
            [("Seven, eh?", "At least you're trying.  Give it all you've got.")],
            [("Eight Hours?", "Is that the limit?  Really?  This app is for weaklings.")],
            ]
        let productivityStatements = [
            ("Flip your phone over!", "Get to WORK!  Break is a long time away so don't even THINK about anything else.")
        ]
        let productivityReprimands = [
            ("The heck you doing here!?", "I'm docking you 5000 props for being a WIMP!")
        ]
        let productivityNotificationStatements = [
            ("Break!  Break!  Break!", "You only get five minutes so don't get comfortable.")
        ]
        let breakStatements = [
            ("Breaks are for wimps!", "Don't just sit there, hit that button for some tips on staying healthy!")
        ]
        let breakNotificationStatements = [
            ("Stop slacking off!", "Your dreams aren't going to make themselves come true!")
        ]
        let endSessionStatements = [
            ("So you actually made it.", "I could've gone twice as long.")
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
            breakButtonText: "get a tip",
            breakNotificationStatements: breakNotificationStatements,
            endSessionStatements: endSessionStatements,
            breakView: ChadBreakView())
        return chad
    }
}
