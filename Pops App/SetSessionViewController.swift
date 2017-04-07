
import UIKit

class SetSessionViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    let viewModel = SetSessionViewModel()
    
    //Selected time for collection view
    var selectedTime: Time!
    
    //Helper properties
    lazy var viewWidth: CGFloat = self.view.frame.width
    lazy var viewHeight: CGFloat = self.view.frame.height
    lazy var itemWidth: CGFloat = self.view.frame.width * (269/self.view.frame.width)
    lazy var itemHeight: CGFloat = self.view.frame.height * (45/self.view.frame.height)
    lazy var collectionViewYAnchor: CGFloat = self.view.frame.height * (403/self.view.frame.height)
    
    //General view properties
    let startButton = UIButton()
    let selectHourCollectionViewLayout = UICollectionViewFlowLayout()
    lazy var selectHourCollectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.selectHourCollectionViewLayout)
    let lineDividerView = UIView()
    let characterMessageBody = UILabel()
    let characterMessageHeader = UILabel()
    let popsWindowView = UIView()
    let popsIcon = UIImageView()
    let headerView = UIView()
    let settingsButton = UIButton()
    let leaderBoardButton = UIButton()
    
    //Needed to animate pops
    var popsBottomAnchorConstraint: NSLayoutConstraint!
    
    //Transition View Properties
    let coachImageView = UIImageView()
    let coachTransitionView = CoachTransitionView()
    var sessionStarted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupStartButton()
        setupCollectionViewLayout()
        setupCollectionView()
        setupLineDividerView()
        setupCharacterMessageBody()
        setupCharacterMessageHeader()
        setupPopsWindow()
        setupPopsIcon()
        setupHeaderView()
        setupSettingsButton()
        setupLeaderBoardButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animatePopsPopup()
        view.insertSubview(coachTransitionView, aboveSubview: self.view)
        coachTransitionView.isHidden = !sessionStarted
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func presentProductiveTimeVC() {
        animatePopsDown()
        if let indexPath = selectHourCollectionView.indexPathsForSelectedItems?[0] {
        viewModel.startSessionOfLength((indexPath.row) + 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewWidth * (10/viewWidth)
    }
    
}

extension SetSessionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.timesForCollectionView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourTimeCell", for: indexPath) as! HourCollectionViewCell
        
        if cell.layer.cornerRadius != 2.0 {
            cell.layer.cornerRadius = 2.0
            cell.layer.masksToBounds = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let currentCell = cell as! HourCollectionViewCell
        currentCell.time = viewModel.timesForCollectionView[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HourCollectionViewCell
        
        guard !cell.timeIsSelected else { return }
        
        selectedTime?.isSelected = false
        let visibleCells = collectionView.visibleCells as! [HourCollectionViewCell]
        visibleCells.forEach { $0.resetBackground() }

        selectedTime = cell.time
        
        cell.timeIsSelected = !cell.timeIsSelected
        UIView.animate(withDuration: 0.3, animations: {
            self.startButton.alpha = cell.timeIsSelected ? 1.0 : 0.3
            self.startButton.isEnabled = cell.timeIsSelected ? true : false
        })
        
    }
    
}

//View Setups
extension SetSessionViewController {
    
    func setupStartButton() {
        startButton.backgroundColor = Palette.aqua.color
        startButton.alpha = 0.3
        startButton.isEnabled = false
        startButton.layer.cornerRadius = 2.0
        startButton.layer.masksToBounds = true
        startButton.setTitle("start", for: .normal)
        startButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        startButton.addTarget(self, action: #selector(presentProductiveTimeVC), for: .touchUpInside)
        
        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 269/viewWidth).isActive = true
        startButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 45/viewHeight).isActive = true
        startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -viewHeight * (149.0/667.0)).isActive = true
    }
    
    func setupCollectionViewLayout() {
        let leftInset = viewWidth * (53/viewWidth)
        let itemWidth = viewWidth * (83/viewWidth)
        let itemHeight = viewHeight * (45/viewHeight)
        selectHourCollectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: leftInset)
        selectHourCollectionViewLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        selectHourCollectionViewLayout.scrollDirection = .horizontal
    }
    
    func setupCollectionView() {
        selectHourCollectionView.backgroundColor = UIColor.white
        selectHourCollectionView.allowsMultipleSelection = false
        selectHourCollectionView.showsHorizontalScrollIndicator = false
        selectHourCollectionView.delegate = self
        selectHourCollectionView.dataSource = self
        selectHourCollectionView.register(HourCollectionViewCell.self, forCellWithReuseIdentifier: "HourTimeCell")
        
        view.addSubview(selectHourCollectionView)
        selectHourCollectionView.translatesAutoresizingMaskIntoConstraints = false
        selectHourCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        selectHourCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        selectHourCollectionView.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -viewHeight * (25/viewHeight)).isActive = true
        selectHourCollectionView.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
    }
    
    func setupLineDividerView() {
        lineDividerView.backgroundColor = Palette.lightGrey.color
        lineDividerView.layer.cornerRadius = 2.0
        lineDividerView.layer.masksToBounds = true
        
        view.addSubview(lineDividerView)
        lineDividerView.translatesAutoresizingMaskIntoConstraints = false
        lineDividerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lineDividerView.bottomAnchor.constraint(equalTo: selectHourCollectionView.topAnchor, constant: -viewHeight * (25/viewHeight)).isActive = true
        lineDividerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 269/viewWidth).isActive = true
        lineDividerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 3/viewHeight).isActive = true
    }
    
    func setupCharacterMessageBody() {
        characterMessageBody.numberOfLines = 0
        characterMessageBody.textColor = Palette.grey.color
        characterMessageBody.textAlignment = .left
        characterMessageBody.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        characterMessageBody.text = "I’ll make sure you’re super productive today. How long do you want to productive for?"
        
        view.addSubview(characterMessageBody)
        characterMessageBody.translatesAutoresizingMaskIntoConstraints = false
        characterMessageBody.bottomAnchor.constraint(equalTo: lineDividerView.topAnchor, constant: -viewHeight * (20/viewHeight)).isActive = true
        characterMessageBody.leadingAnchor.constraint(equalTo: lineDividerView.leadingAnchor).isActive = true
        characterMessageBody.trailingAnchor.constraint(equalTo: lineDividerView.trailingAnchor).isActive = true
    }
    
    func setupCharacterMessageHeader() {
        characterMessageHeader.numberOfLines = 0
        characterMessageHeader.textColor = UIColor.black
        characterMessageHeader.textAlignment = .left
        characterMessageHeader.font = UIFont(name: "Avenir-Black", size: 14.0)
        characterMessageHeader.text = "Hey there, I'm Pops!"
        
        view.addSubview(characterMessageHeader)
        characterMessageHeader.translatesAutoresizingMaskIntoConstraints = false
        characterMessageHeader.bottomAnchor.constraint(equalTo: characterMessageBody.topAnchor, constant: -viewHeight * (5/viewHeight)).isActive = true
        characterMessageHeader.leadingAnchor.constraint(equalTo: characterMessageBody.leadingAnchor).isActive = true
        characterMessageHeader.trailingAnchor.constraint(equalTo: characterMessageBody.trailingAnchor).isActive = true
    }
    
    func setupPopsWindow() {
        view.addSubview(popsWindowView)
        popsWindowView.translatesAutoresizingMaskIntoConstraints = false
        popsWindowView.backgroundColor = Palette.salmon.color
        popsWindowView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popsWindowView.bottomAnchor.constraint(equalTo: characterMessageHeader.topAnchor, constant: -viewHeight * (40/667)).isActive = true
        popsWindowView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        popsWindowView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        popsWindowView.layer.cornerRadius = 50.0
        popsWindowView.layer.masksToBounds = true
    }
    
    func setupPopsIcon() {
        popsIcon.image = UIImage(named: "IC_POPS")
        popsIcon.contentMode = .scaleAspectFit
        
        popsWindowView.addSubview(popsIcon)
        popsIcon.translatesAutoresizingMaskIntoConstraints = false
        popsIcon.backgroundColor = UIColor.clear
        
        popsBottomAnchorConstraint = popsIcon.bottomAnchor.constraint(equalTo: popsWindowView.bottomAnchor, constant: 100)
        popsBottomAnchorConstraint.isActive = true
        popsIcon.centerXAnchor.constraint(equalTo: popsWindowView.centerXAnchor, constant: 0).isActive = true
        popsIcon.heightAnchor.constraint(equalToConstant: 80).isActive = true
        popsIcon.widthAnchor.constraint(equalToConstant: 52).isActive = true
        popsIcon.layer.masksToBounds = true
    }

    func setupHeaderView() {
        headerView.backgroundColor = Palette.salmon.color
        
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: viewHeight * (5/viewHeight)).isActive = true
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    func setupSettingsButton() {
        settingsButton.setBackgroundImage(#imageLiteral(resourceName: "IC_Settings-1"), for: .normal)
        
        headerView.addSubview(settingsButton)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.0).isActive = true
        settingsButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 21.0).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 21.0).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 21.0).isActive = true
    }
    
    func setupLeaderBoardButton() {
        leaderBoardButton.setBackgroundImage(#imageLiteral(resourceName: "IC_Leaderboard"), for: .normal)
        
        headerView.addSubview(leaderBoardButton)
        leaderBoardButton.translatesAutoresizingMaskIntoConstraints = false
        leaderBoardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.0).isActive = true
        leaderBoardButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 21.0).isActive = true
        leaderBoardButton.heightAnchor.constraint(equalToConstant: 21.0).isActive = true
        leaderBoardButton.widthAnchor.constraint(equalToConstant: 23.0).isActive = true
    }
    
    func animatePopsPopup() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            self.popsBottomAnchorConstraint.constant = 10
            self.view.layoutIfNeeded()
        }
    }
    
    func animatePopsDown() {
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.7, animations: {
            self.popsBottomAnchorConstraint.constant = 100
            self.view.layoutIfNeeded()

        }) { _ in
            let productiveTimeVC = ProductiveTimeViewController()
            productiveTimeVC.delegate = self
            self.present(productiveTimeVC, animated: true, completion: {
                self.sessionStarted = true
            })
            
        }

    }
    
}

extension SetSessionViewController: InstantiateViewControllerDelegate {
    
    func instantiateBreakTimeVC() {
        let breakTimeVC = BreakTimeViewController()
        present(breakTimeVC, animated: true, completion: nil)
    }
    
}


