
import UIKit
import YouTubeiOSPlayerHelper

class PopsBreakView: UIView {

    let viewModel = PopsBreakViewModel.singleton
    let player: YTPlayerView
    
    init(){
        let playerWidth = UIScreen.main.bounds.width
        let playerHeight = UIScreen.main.bounds.height / 3
        let playerFrame = CGRect(x: 0, y: 0, width: playerWidth, height: playerHeight)
        player = YTPlayerView(frame: playerFrame)
        player.load(withVideoId: "IWrKM_zLskQ")
        
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .white
        self.addSubview(player)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
