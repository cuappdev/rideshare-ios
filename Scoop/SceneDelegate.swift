//
//  SceneDelegate.swift
//  Scoop
//
//  Created by Reade Plunkett on 1/27/22.
//

import GoogleSignIn
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
    var window: UIWindow?
  
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        self.window = window
        window.makeKeyAndVisible()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didCompleteLogin), name: NSNotification.Name("didCompleteLogin"), object: nil)
        
        configureNavBar()
        restoreSignIn()
    }
    
    private func restoreSignIn() {
        guard GIDSignIn.sharedInstance.hasPreviousSignIn() else {
            self.window?.rootViewController = LoginViewController()
            return
        }
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                self.window?.rootViewController = LoginViewController()
                print(error.localizedDescription)
                return
            }
            
            guard let user = user else {
                self.window?.rootViewController = LoginViewController()
                return
            }
            
            guard let email = user.profile?.email else { return }
            
            guard let userID = user.userID,
                  let firstName = user.profile?.givenName,
                  let familyName = user.profile?.familyName,
                  let idtoken = user.idToken?.tokenString else {
                GIDSignIn.sharedInstance.signOut()
                return
            }
            
            NetworkManager.shared.authenticateUser(googleID: userID, email: email, firstName: firstName, lastName: familyName, id_token: idtoken) { result in
                switch result {
                case .success(let user):
                    self.setNetID(email: email)
                    NetworkManager.shared.currentUser.firstName = firstName
                    NetworkManager.shared.currentUser.lastName = familyName
                    NetworkManager.userToken = user.accessToken
                    self.didCompleteLogin()
                case .failure:
                    print("Unable to Authorize")
                }
            }
        }
    }
    
    @objc
    private func didCompleteLogin() {
        self.window?.rootViewController = self.createTabBarController()
    }
    
    private func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .scoopGreen
        
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        let homeNavController = UINavigationController(rootViewController: homeViewController)
        homeNavController.navigationBar.prefersLargeTitles = false
        
        let searchViewController = SearchViewController()
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))

        let searchNavController = UINavigationController(rootViewController: searchViewController)
        searchNavController.navigationBar.prefersLargeTitles = true
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        let profileNavController = UINavigationController(rootViewController: profileViewController)
        profileNavController.navigationBar.prefersLargeTitles = true
        
        tabBarController.setViewControllers([homeNavController, searchNavController, profileNavController], animated: false)
        
        return tabBarController
    }
    
    // MARK: Configure Nav Bar
    private func configureNavBar() {
        let backArrowImage = UIImage(named: "BackArrow")
        let transparentImage = UIImage(named: "Transparent") // Hides "Back" text
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().backIndicatorImage = backArrowImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backArrowImage
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(transparentImage, for: .normal, barMetrics: .default)
    }
    
    private func setNetID(email: String) {
        guard let strIndex = email.firstIndex(of: "@") else{
            print("Not a valid Cornell email")
            return
        }
        let index = email.index(strIndex, offsetBy: -1)
        let netID = String(email[...index])
        NetworkManager.shared.currentUser.netid = netID
    }
    
}
