//
//  ViewController.swift
//  CatchTheKenny
//
//  Created by David Laczkovits on 24.09.23.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var kenny1: UIImageView!
    @IBOutlet weak var kenny2: UIImageView!
    @IBOutlet weak var kenny3: UIImageView!
    @IBOutlet weak var kenny4: UIImageView!
    @IBOutlet weak var kenny5: UIImageView!
    @IBOutlet weak var kenny6: UIImageView!
    @IBOutlet weak var kenny7: UIImageView!
    @IBOutlet weak var kenny8: UIImageView!
    @IBOutlet weak var kenny9: UIImageView!
    @IBOutlet weak var highscoreLabel: UILabel!
    
    var kennyArray = [UIImageView]()
    var timer = Timer()
    var kennyTimer = Timer()
    var counter = 0
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        highscoreLabel.text = "Highscore: \(UserDefaults.standard.object(forKey: "highscore") ?? 0)"
        
        kenny1.isUserInteractionEnabled = true
        kenny2.isUserInteractionEnabled = true
        kenny3.isUserInteractionEnabled = true
        kenny4.isUserInteractionEnabled = true
        kenny5.isUserInteractionEnabled = true
        kenny6.isUserInteractionEnabled = true
        kenny7.isUserInteractionEnabled = true
        kenny8.isUserInteractionEnabled = true
        kenny9.isUserInteractionEnabled = true
        
        let recognizer1 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer3 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer4 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer5 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer6 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer7 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer8 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer9 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        
        kenny1.addGestureRecognizer(recognizer1)
        kenny2.addGestureRecognizer(recognizer2)
        kenny3.addGestureRecognizer(recognizer3)
        kenny4.addGestureRecognizer(recognizer4)
        kenny5.addGestureRecognizer(recognizer5)
        kenny6.addGestureRecognizer(recognizer6)
        kenny7.addGestureRecognizer(recognizer7)
        kenny8.addGestureRecognizer(recognizer8)
        kenny9.addGestureRecognizer(recognizer9)
        
        kennyArray = [kenny1,kenny2,kenny3,kenny4,kenny5,kenny6,kenny7,kenny8,kenny9]
        
        //UserDefaults.standard.setValue(kennyArray, forKey: "kennyArray")
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: kennyArray, requiringSecureCoding: false)
            let userDefaults = UserDefaults.standard
            userDefaults.set(encodedData, forKey: "kennyArray")
        } catch {
            print(error)
        }
        
        startNewGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Kenny.sharedInstance.image != nil {
            kenny1.image = Kenny.sharedInstance.image
            kenny2.image = Kenny.sharedInstance.image
            kenny3.image = Kenny.sharedInstance.image
            kenny4.image = Kenny.sharedInstance.image
            kenny5.image = Kenny.sharedInstance.image
            kenny6.image = Kenny.sharedInstance.image
            kenny7.image = Kenny.sharedInstance.image
            kenny8.image = Kenny.sharedInstance.image
            kenny9.image = Kenny.sharedInstance.image
        } else {
            let imgAny = UserDefaults.standard.object(forKey: "image")
            
            if let imgData = imgAny as? Data {
                kenny1.image = UIImage(data: imgData)
                kenny2.image = UIImage(data: imgData)
                kenny3.image = UIImage(data: imgData)
                kenny4.image = UIImage(data: imgData)
                kenny5.image = UIImage(data: imgData)
                kenny6.image = UIImage(data: imgData)
                kenny7.image = UIImage(data: imgData)
                kenny8.image = UIImage(data: imgData)
                kenny9.image = UIImage(data: imgData)
            } else {
                kenny1.image = UIImage(named: "ball")
                kenny2.image = UIImage(named: "ball")
                kenny3.image = UIImage(named: "ball")
                kenny4.image = UIImage(named: "ball")
                kenny5.image = UIImage(named: "ball")
                kenny6.image = UIImage(named: "ball")
                kenny7.image = UIImage(named: "ball")
                kenny8.image = UIImage(named: "ball")
                kenny9.image = UIImage(named: "ball")
            }
        }
        
    }
    
    @objc func increaseScore() {
        score += 1
        scoreLabel.text = "Score: \(score)"
    }

    func startNewGame() {
        counter = 10
        score = 0
        scoreLabel.text = "Score: \(score)"
        timerLabel.text = "\(counter)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        kennyTimer = Timer.scheduledTimer(timeInterval: Double(slider.value), target: self, selector: #selector(kennyTimerFunction), userInfo: nil, repeats: true)
        
    }
    
    @objc func kennyTimerFunction() {
        for kenny in kennyArray {
            kenny.isHidden = true
        }
        
        let rand = Int(arc4random_uniform(UInt32(kennyArray.count-1)))
        kennyArray[rand].isHidden = false
    }
    
    @objc func timerFunction() {
        counter -= 1
        timerLabel.text = "\(counter)"
        
        if score > (UserDefaults.standard.object(forKey: "highscore") ?? 0) as! Int {
            UserDefaults.standard.setValue(score, forKey: "highscore")
            highscoreLabel.text = "Highscore: \(score)"
        }
            
        if counter == 0 {
            timer.invalidate()
            kennyTimer.invalidate()
            let alert = UIAlertController(title: "Game Over", message: "Time is over. Try again?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
                self.startNewGame()
            }
            alert.addAction(okButton)
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) { (UIAlertAction) in
                print("Cancel Button clicked")
            }
            alert.addAction(cancelButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func clearHighscore(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "highscore")
        highscoreLabel.text = "Highscore: 0"
    }
    
    @IBAction func start(_ sender: Any) {
        startNewGame()
    }
    
}

