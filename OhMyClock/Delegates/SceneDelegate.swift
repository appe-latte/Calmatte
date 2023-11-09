//
//  SceneDelegate.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-19.
//

import UIKit
import SwiftUI
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        FirebaseApp.configure() // Configure Firebase just once at the entry point of your app
        
        // Create the SwiftUI view that provides the window contents
        let contentView = ContentView() // Replace with your main SwiftUI view
        
        // Use a UIHostingController as window root view controller
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Restart any tasks that were paused (or not yet started) while the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Pause any tasks that are running.
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    // MARK: - Handling URL Sessions
    private func handleURLSession(url: URL, options: UIScene.ConnectionOptions) {
        // Handle URL session, e.g., by passing the URL to a view controller or service that can handle it.
    }
    
    // MARK: - Configuring the window with a user activity
    private func configure(window: UIWindow?, with activity: NSUserActivity) -> Bool {
        // Handle user activities (handoff, universal links, etc.)
        // Return true if the activity was handled, false otherwise.
        return false
    }
}
