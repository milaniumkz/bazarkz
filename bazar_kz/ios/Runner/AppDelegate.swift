import Flutter
import FirebaseAuth
import FirebaseCore
import UIKit

private func handleFirebaseAuthURL(_ url: URL) -> Bool {
  let isAuthCallback = url.scheme == "app-1-541902317139-ios-25c1b201d95826002288a6"
    && url.host == "firebaseauth"
  if let apps = FirebaseApp.allApps {
    for app in apps.values {
      if Auth.auth(app: app).canHandle(url) { return true }
    }
  }
  // Firebase's delegate swizzling may already have consumed this callback.
  // Its return URL must never become a Flutter navigation request.
  return isAuthCallback
}

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  override func application(
    _ application: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    if handleFirebaseAuthURL(url) { return true }
    return super.application(application, open: url, options: options)
  }
}

@objc class SceneDelegate: FlutterSceneDelegate {
  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    // Firebase must consume its callback before Flutter treats it as an app link.
    let unhandled = Set(URLContexts.filter { !handleFirebaseAuthURL($0.url) })
    if !unhandled.isEmpty {
      super.scene(scene, openURLContexts: unhandled)
    }
  }
}
