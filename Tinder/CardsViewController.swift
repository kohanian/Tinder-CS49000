//
//  ViewController.swift
//  Tinder
//
//  Created by Kyle Ohanian on 3/8/18.
//  Copyright © 2018 Kyle Ohanian. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {
    
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!

    @IBOutlet weak var imageContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var x = 0;
        while(x < 10) {
            print("CREATE")
            let image = UIImageView(image: #imageLiteral(resourceName: "ryan"))
            let panGest = UIPanGestureRecognizer(target: self, action: #selector(didPanTray(sender:)))
            image.addGestureRecognizer(panGest)
            
            image.isUserInteractionEnabled = true
            image.center = imageContainer.center
             let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
            tap.numberOfTapsRequired = 1;
            image.addGestureRecognizer(tap)
            view.addSubview(image)
            view.bringSubview(toFront: image)
            imageContainer.bringSubview(toFront: image)
            x += 1
            trayUp = image.center
            trayDownOffset = 160
            trayDown = image.center
            trayOriginalCenter = image.center
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "firstSegue") {
            let profileViewController = segue.destination as! ProfileViewController
            let imageView = sender as! UIImageView
            profileViewController.image = imageView.image
        }
    }
    
    @objc func didTap(sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        performSegue(withIdentifier: "firstSegue", sender: imageView)
    }
    
    @objc func didPanTray(sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: view)
        let loc = sender.location(in: view)
        let translation = sender.translation(in: view)
        print("translation \(translation)")
        let currentImageView = sender.view as! UIImageView
        print("\(loc.y)")
        if(translation.x > 0) {
            if(loc.y > currentImageView.center.y) {
                currentImageView.transform = CGAffineTransform(rotationAngle: CGFloat(-15 * Double.pi / 180))
            }
            else {
                currentImageView.transform = CGAffineTransform(rotationAngle: CGFloat(15 * Double.pi / 180))
            }
        }
        else {
            if(loc.y < currentImageView.center.y) {
                currentImageView.transform = CGAffineTransform(rotationAngle: CGFloat(-15 * Double.pi / 180))
            }
            else {
                currentImageView.transform = CGAffineTransform(rotationAngle: CGFloat(15 * Double.pi / 180))
            }
        }



        if sender.state == .began {
            print("Begin")
            trayOriginalCenter = currentImageView.center
        }
        else if sender.state == .changed {
            print("Changing")
            currentImageView.center = CGPoint(x: trayOriginalCenter.x + translation.x, y: trayOriginalCenter.y + translation.y)

        }
        else if sender.state == .ended {
            print("Ended")
            if velocity.y > 0 {
                UIView.animate(withDuration: 0.3) {
                    currentImageView.center = self.trayDown
                }
            } else {
                if(translation.x > 50 || translation.x < -50) {
                    currentImageView.alpha = 1
                    UIView.animate(withDuration:0.1, animations: {
                        currentImageView.alpha = 0
                    }, completion: {
                        (value: Bool) in
                    })
                }
            }
            currentImageView.transform = view.transform.rotated(by: CGFloat(0 * M_PI / 180))

        }

    }


}

