
import Foundation

final class ChadBreakViewModel {
    
    lazy var dataStore = DataStore.singleton
    
    let chadBreakTasks: [(header: String, body: String)] = [
    ("Do 10 Push Ups!",  "No... make it 15!  Strength in your arms is strength in your mind, bro!"),
    ("Bend over and touch your toes.",  "Count to 20.  Flexibility, bro, flexibility."),
    ("Breathing exercises!",  "Inhale for seven seconds, exhale for eleven.  Get that heart rate down, bro!"),
    ("15 crunches pronto!", "Otherwise you'll never amount to anything!  Trust me on this one."),
    ("Stay hydrated.", "Go get a glass of water.  You'll thank me later."),
    ("20 Jumping Jacks!", "Get your blood pumping!  It'll make you that much more productive."),
    ("Promise me something.", "You'll go for a jog later.  Promise me or I'll MAKE you promise me."),
    ("Exercise those legs!", "Gimme 20 squats right this minute, bro!  Don't be lazy!"),
    ("Sitting is for wimps!",  "Stand up for your next session.  I NEVER SIT!"),
    ("Do some pliés!",  "Don't know what those are?  Look it up, then.  THEN DO SOME!"),
    ("Shadow boxing time.",  "Imagine you're swinging at your past, wimpy self.  I'd swing at you, too!"),
    ("You getting enough nutrition?",  "Maybe you should order some protein powder or something."),
    ("Sleep is NOT for wimps.",  "Awesome people sleep a ton.  I'm awesome, so I sleep ALL THE TIME."),
    ("Calf stretch time!",  "Push yourself up onto your tiptoes 20 times.  Feel the burn, bro!"),
    ("You got any weights?",  "Well go lift them, then!  If not, then BUY SOME YOU WIMP."),
    ("Go get some fresh air.",  "And while you're out there why don't you jog around the block?"),
    ("You know what's fun?",  "Team sports.  You should look online for one to join."),
    ("Control your calories!",  "Split restaurant meal portions in half.  Two meals for the price of one!"),
    ("Fried Foods?",  "That stuff will clog your brain, bro.  That's the last thing YOU need."),
    ("Drinks with calories?",  "What are you, silly?  Stick to water, seltzer, coffee, and tea!"),
    ("Sit up straight!",  "How are you gonna lift later if your posture's all bent outta shape?"),
    ("Feeling stiff?",  "Sit on the floor with the bottoms of your feet pressed together.  That's the stuff, bro!"),
    ("Bored?",  "You should go rock climbing later this week.  That'll perk you right up!"),
    ("Bro...",  "Whatever excuse you're cooking up to get out of doing what you really should be doing.  STOP."),
    ("40 High Knees!",  "Jog in place while you count to 40.  Get those knees up!  HIGHER!!"),
    ("Clean your room!",  "A healthy environment reflects a healthy body and mind.  Didn't you know that?"),
    ("Had a massage lately?",  "Well, get one!  I've never felt so limber in my life.  Heck yeah, Bro!"),
    ("Check your heart rate.",  "Stress can mess with it.  Make sure you're taking care of yourself, bro."),
    ("Arm stretches!",  "Hold your arms straight out and rotate them forward 20 times then backwards 20 times."),
    ("No zero days!",  "You should move closer to one of your lifetime ambitions every day.  EVERY DAY, BRO!")
    ]

    init(){}
    
    //Not being used in current iteration of Chad's Break
    //let manager = ChadBreakManager()
}
