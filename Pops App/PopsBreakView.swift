
import UIKit
import YouTubeiOSPlayerHelper

class PopsBreakView: UIView {

    let viewModel = PopsBreakViewModel()
    
    lazy var viewWidth: CGFloat = self.frame.width
    lazy var viewHeight: CGFloat = self.frame.height
    
    var player = YTPlayerView()
    var backButton = UIButton()
    var lineDividerView = UIView()
    var header = UILabel()
    var body = UILabel()
    var likeButton = UIButton()
    var dislikeButton = UIButton()
    var nextButton = UIButton()
        
    init(){
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .white
        setUpYouTubePlayerView()
        setUpLineDividerView()
        setUpHeader()
        setUpBody()
        setUpNextButton()
        setUpDislikeButton()
        setUpLikeButton()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpYouTubePlayerView(){
        let playerWidth = UIScreen.main.bounds.width
        let playerHeight = UIScreen.main.bounds.height / 3
        let playerFrame = CGRect(x: 0, y: 0, width: playerWidth, height: playerHeight)
        player = YTPlayerView(frame: playerFrame)
        
        viewModel.letPopsGetYouAVideo { (videoID) in
            DispatchQueue.main.async {
                self.player.load(withVideoId: videoID)
                let currentVideoIndex = self.viewModel.currentVideoIndex
                self.header.text = self.viewModel.manager.popsVideos[currentVideoIndex].title
                self.body.text = self.viewModel.manager.popsVideos[currentVideoIndex].description
            }
        }
        
        self.addSubview(self.player)
    }
    
    func setUpLineDividerView() {
        lineDividerView.backgroundColor = Palette.lightGrey.color
        lineDividerView.layer.cornerRadius = 2.0
        lineDividerView.layer.masksToBounds = true
        
        self.addSubview(lineDividerView)
        lineDividerView.translatesAutoresizingMaskIntoConstraints = false
        lineDividerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        lineDividerView.topAnchor.constraint(equalTo: player.bottomAnchor, constant: 20).isActive = true
        lineDividerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 269/viewWidth).isActive = true
        lineDividerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 3/viewHeight).isActive = true
    }
   
    func setUpHeader(){
        header.numberOfLines = 0
        header.textColor = UIColor.black
        header.textAlignment = .left
        header.font = UIFont(name: "Avenir-Black", size: 14.0)
        
        self.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.topAnchor.constraint(equalTo: lineDividerView.bottomAnchor, constant: 20).isActive = true
        header.leadingAnchor.constraint(equalTo: lineDividerView.leadingAnchor).isActive = true
        header.trailingAnchor.constraint(equalTo: lineDividerView.trailingAnchor).isActive = true
    }

    func setUpBody(){
        body.numberOfLines = 5
        body.textColor = Palette.grey.color
        body.textAlignment = .left
        body.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        
        self.addSubview(body)
        body.translatesAutoresizingMaskIntoConstraints = false
        body.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 20).isActive = true
        body.leadingAnchor.constraint(equalTo: lineDividerView.leadingAnchor).isActive = true
        body.trailingAnchor.constraint(equalTo: lineDividerView.trailingAnchor).isActive = true
    }
    
    func setUpNextButton() {
        nextButton.backgroundColor = Palette.aqua.color
        nextButton.alpha = 1
        nextButton.isEnabled = true
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        self.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.097).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setUpDislikeButton() {
        dislikeButton.backgroundColor = Palette.lightGrey.color
        dislikeButton.setTitleColor(.black, for: .normal)
        dislikeButton.alpha = 1
        dislikeButton.isEnabled = true
        dislikeButton.layer.cornerRadius = 2.0
        dislikeButton.layer.masksToBounds = true
        dislikeButton.setTitle("don't show this again", for: .normal)
        dislikeButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        dislikeButton.layer.borderColor = UIColor.black.cgColor
        dislikeButton.addTarget(self, action: #selector(dislikeButtonTapped), for: .touchUpInside)
        
        self.addSubview(dislikeButton)
        dislikeButton.translatesAutoresizingMaskIntoConstraints = false
        dislikeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dislikeButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 269/viewWidth).isActive = true
        dislikeButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 45/viewHeight).isActive = true
        dislikeButton.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20).isActive = true
    }
    
    func setUpLikeButton() {
        likeButton.backgroundColor = Palette.lightBlue.color
        likeButton.alpha = 1
        likeButton.isEnabled = true
        likeButton.layer.cornerRadius = 2.0
        likeButton.layer.masksToBounds = true
        likeButton.setTitle("add to faves", for: .normal)
        likeButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        likeButton.layer.borderColor = UIColor.black.cgColor
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        self.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        likeButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 269/viewWidth).isActive = true
        likeButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 45/viewHeight).isActive = true
        likeButton.bottomAnchor.constraint(equalTo: dislikeButton.topAnchor, constant: -8).isActive = true
    }

    func likeButtonTapped() {
        UIView.animate(withDuration: 0.1) {
            self.dislikeButton.layer.borderWidth = 0
            self.likeButton.layer.borderWidth = 1
        }
        
        viewModel.userLikedVideo()
    }
    
    func dislikeButtonTapped() {
        viewModel.userDislikedVideo()
        nextButtonTapped()
    }
    
    func nextButtonTapped() {
        let newVideoIndex = viewModel.letPopsGetYouADifferentVideo()
        let newVideo = viewModel.manager.popsVideos[newVideoIndex]
        self.player.load(withVideoId: newVideo.id)
        
        UIView.animate(withDuration: 0.2) {
            self.likeButton.layer.borderWidth = 0
            self.dislikeButton.layer.borderWidth = 0
            self.header.alpha = 0
            self.body.alpha = 0
        }
        
        self.header.text = newVideo.title
        self.body.text = newVideo.description
        
        UIView.animate(withDuration: 0.2) { 
            self.header.alpha = 1
            self.body.alpha = 1
        }
    }
}
