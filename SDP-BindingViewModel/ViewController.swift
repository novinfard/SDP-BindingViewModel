//
//  ViewController.swift
//  SDP-BindingViewModel
//
//  Created by Soheil on 27/02/2018.
//  Copyright © 2018 Soheil Novinfard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var username: BoundTextField!
	var user: User!
	var observers = [NSKeyValueObservation]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		user = User(name: "Soheil")
		let observer = user.observe(\User.name, options: .new) { [weak
			self] user, change in
			self?.username.text = change.newValue ?? ""
		}
		
		observers.append(observer)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.user.name = "Bilbo Baggins"
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

class User: NSObject {
	@objc dynamic var name: String
	init(name: String) {
		self.name = name
	}
}

class BoundTextField: UITextField {

}


