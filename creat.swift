import UIKit
import FirebaseAuth

class ViewController : UIViewController {
	
	private let label: UILabel = {
		let label = UILabel()
		lebel.textAlignment = .center
		label.text = "log in"
		label.font = .systemFont(ofSize: 22, weight: .semibold)
		return label
	}()

	private let emailField: UITextField = {
		let label = UITextField()
		emailField.placeholder = "Email Address"
		emailField.layer.borderwidth = 2
		emailField.layer.borderColor = UIColor.black.cgColor
		emailField.leftViewMode = .always
		emailField. leftView = UIView(frame: CGRect(x:0, y:0, width: 5, height: 0))
		return emailField
	}()


	private let passwordField: UITextField = {
		let label = UITextField()
		passField.placeholder = "Password"
		passField.layer.borderwidth = 2
		passField.layer.borderColor = UIColor.black.cgColor
		passField.isSecureTextEntry = true
		passField.leftViewMode = .always
		passField. leftView = UIView(frame: CGRect(x:0, y:0, width: 5, height: 0))

		return passField
	}()


	private let button: UIButton = {
		let button = UIButton()
		button.backgrounfColor = .systemBlack
		button.setTitleColor(.white, for: .normal)
		button.setTitle("Continue", for: .normal)
		return button
	}()

		private let signOutButton: UIButton = {
		let signOutButton = UIButton()
		button.backgrounfColor = .systemBlack
		button.setTitleColor(.white, for: .normal)
		button.setTitle("Log out.", for: .normal)
		return button
	}()

	override func viewDidLoad(){
		super.viewDidLoad()
		view.addSubview(label)
		view.addSubview(emailField)
		view.addSubview(passwordField)
		view.addSubview(button)

		button addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

		if FirebaseAuth.Auth.auth().currentUser != nil {
			label.isHidden = true
			button.isHidden = true
			emailField.isHidden = true
			passwordField.isHidden = true

			view.addSubview(signOutButton)
			signOutButton.frame = CGRect(x:20, y:150, width: view.frame.size.width-40, height:52)
			signOutButton.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
		}
	}

	@objc private func logOutTapped(){
		do {
			try FirebaseAuth.Auth.auth().signOut()

			label.isHidden = false
			button.isHidden = false
			emailField.isHidden = false
			passwordField.isHidden = false

			signOutButton.removeFromSuperview()

		}
		catch{
			print("Unable to sign out.")
		}
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		label.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 80)

		emailField.frame = CGRect(x: 20, y: label.frame.origin.y+label.frame.size.height+10, width: view.frame.size.width-40, height: 50)

		passwordField.frame = CGRect(x: 20, y: emailField.frame.origin.y+emailField.frame.size.height+10, width: view.frame.size.width-40, height: 50)

		button.frame = CGRect(x: 20, y: passwordfield.frame.origin.y+passwordfield.frame.size.height+30, width: view.frame.size.width-40, height: 50)


	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if FirebaseAuth.Auth.auth().currentUser == nil{
		emailField.becomeFirstResponder()
		}
	}

	@objc private func didTapButton() {
		print("Continue button tapped")
		guard let email = emailField.text, !email.isEmpty,
			let password = passwordField.text, !password.isEmpty else {
				print("Missing field data")
				return
			}

			FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in 
				guard let strongSelf = self else {
					return
				}

				guard error ==nil else {
				strongSelf.showCreateAccount(email: email, password: password)
				return
			}

			print("You're signed in.")
			strongSelf.label.isHidden = true
			strongSelf.emailField.isHidden = true
			strongSelf.passwordField.isHidden = true
			strongSelf.button.isHidden = true

			strongSelf.emailField.resignFirstResponder()
			strongSelf.passwordField.resignFirstResponder()

		})

	}

	func showCreatAccount(email: String, password: String) {
		let alert = UIAlertController(title: "Create Account", message: "Would you like to create an account with this email and password?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Continue", style: default, handler: {_ in
			FirebaseAuth.Auth.auth().createUser(with Email: email, password: password, completion: { [weak self] result, error in

			guard let strongSelf = self else {
					return
				}

				guard error ==nil else {
				print("Cannot create account.")
				return
			}

			print("You're signed in.")
			strongSelf.label.isHidden = true
			strongSelf.emailField.isHidden = true
			strongSelf.passwordField.isHidden = true
			strongSelf.button.isHidden = true

			strongSelf.emailField.resignFirstResponder()
			strongSelf.passwordField.resignFirstResponder()
			})

		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: cancel, handler: {_ in
		}))

		present(alert, animated: true)
	}


}
