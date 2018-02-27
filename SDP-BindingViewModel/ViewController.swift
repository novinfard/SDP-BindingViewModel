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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		user = User(name: Observable("Test"))
		username.bind(to: user.name)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.user.name.value = "Bilbo Baggins"
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

struct User {
   var name: Observable<String>
}

class Observable<ObservedType> {
	private var _value: ObservedType?
	
	var valueChanged: ((ObservedType?) -> ())?
	
	init(_ value: ObservedType) {
		_value = value
	}
	
	public var value: ObservedType? {
		get {
			return _value
		}
		set {
			_value = newValue
			valueChanged?(_value)
		}
	}
	
	func bindingChanged(to newValue: ObservedType) {
		_value = newValue
		print("Value is now \(newValue)")
	}
	
}

class BoundTextField: UITextField {
	var changedClosure: (() -> ())?
	
	@objc func valueChanged() {
		changedClosure?()
	}
	
	func bind(to observable: Observable<String>) {
		addTarget(self, action:
			#selector(BoundTextField.valueChanged), for: .editingChanged)
		changedClosure = { [weak self] in
			observable.bindingChanged(to: self?.text ?? "")
		}
		observable.valueChanged = { [weak self] newValue in
			self?.text = newValue
		}
	}
}


