
import Foundation

final class ChadBreakViewModel {
    
    lazy var dataStore = DataStore.singleton
    
    let chadBreakTasks: [(header: String, body: String)] = [
    ("Do 10 Push Ups!",  "No... make it 15!  Strength in your arms is strength in your mind, bro!"),
    ("Bend over and touch your toes.",  "Count to 20.  Flexibility, bro, flexibility."),
    ("Breathing exercises!",  "Inhale for seven seconds, exhale for eleven.  Get that heart rate down, bro!"),
    ("15 crunches pronto!", "Otherwise you'll never amount to anything!  Trust me on this one."),
    ("Stay hydrated.", "Go get a glass of water.  You'll thank me later."),
    ("20 Jumping Jacks!", "Get your blood pumping!  It'll make you that much more productive"),
    ("Promise me something.", "You'll go for a jog later.  Promise me or I'll MAKE you promise me."),
    ("Exercise those legs!", "Gimme 20 squats right this minute, bro!  Don't be lazy!"),
    ("Sitting is for wimps!",  "Stand up for your next session.  I NEVER SIT!"),
    ("Do some pliés!",  "Don't know what those are?  Look it up, then.  THEN DO SOME!"),
    ("Shadow boxing time.",  "Imagine you're swinging at your past, wimpy self.  I'd swing at you, too!"),
    ]

    init(){}
    
    //Not being used in current iteration of Chad's Break
    //let manager = ChadBreakManager()
}
