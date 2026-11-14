import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene, willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    // iPhones with iOS 26+ get the system's own tab bar (Liquid Glass); on the iPhone Duo
    // it is the vertical bar beside the app, which covers anything the app draws there.
    // Older iOS, iPad and Android keep the plain Flutter view and the app's own menu.
    guard #available(iOS 26, *), UIDevice.current.userInterfaceIdiom == .phone, let window,
      let flutter = window.rootViewController as? FlutterViewController
    else { return }
    var vertical = false
    if #available(iOS 27.1, *) { vertical = window.traitCollection.verticalBarEdge != .unspecified }
    window.rootViewController = NativeTabs(flutter: flutter, vertical: vertical)
  }
}

/// The app's five tabs as a system tab bar around the one Flutter view. Flutter tells it
/// the titles, the selected tab and whether a screen is open (back button); it tells
/// Flutter what was tapped.
@available(iOS 26, *)
final class NativeTabs: UITabBarController, UITabBarControllerDelegate {
  let flutter: FlutterViewController
  private let channel: FlutterMethodChannel
  private var hosts: [TabHost] = []
  private var lastInset: CGFloat = -1
  var flutterShown = false  // the Flutter view was told it is on screen (once)

  /// The Duo's vertical bar (system back button in it) rather than a bottom bar.
  private let vertical: Bool

  init(flutter: FlutterViewController, vertical: Bool) {
    self.flutter = flutter
    self.vertical = vertical
    channel = FlutterMethodChannel(
      name: "digiwitch/tabs", binaryMessenger: flutter.binaryMessenger)
    super.init(nibName: nil, bundle: nil)
    let symbols = [
      "sparkles", "rectangle.portrait.on.rectangle.portrait", "sun.max", "number", "moon.zzz",
    ]
    hosts = symbols.map { _ in TabHost(tabs: self) }
    viewControllers = zip(hosts, symbols).map { host, symbol in
      let nav = UINavigationController(rootViewController: host)
      nav.setNavigationBarHidden(true, animated: false)  // Flutter draws its own top bar
      nav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: symbol), tag: 0)
      return nav
    }
    // Today is a gold button with a dark sun, as on the app's own bar, selected or not.
    let gold = UIColor(red: 0.79, green: 0.64, blue: 0.30, alpha: 1)
    let ink = UIColor(red: 0.17, green: 0.13, blue: 0.25, alpha: 1)
    let side: CGFloat = vertical ? 36 : 30
    let sun = UIGraphicsImageRenderer(size: CGSize(width: side, height: side)).image { _ in
      gold.setFill()
      UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: side, height: side)).fill()
      let symbol = UIImage(
        systemName: "sun.max.fill",
        withConfiguration: UIImage.SymbolConfiguration(pointSize: side / 2, weight: .semibold))?
        .withTintColor(ink, renderingMode: .alwaysOriginal)
      if let symbol {
        symbol.draw(
          at: CGPoint(x: (side - symbol.size.width) / 2, y: (side - symbol.size.height) / 2))
      }
    }.withRenderingMode(.alwaysOriginal)
    viewControllers?[2].tabBarItem.image = sun
    viewControllers?[2].tabBarItem.selectedImage = sun
    selectedIndex = 2  // Today, as in the app
    // The app's violet instead of the system blue on the selected tab and bar items.
    view.tintColor = UIColor { t in
      t.userInterfaceStyle == .dark
        ? UIColor(red: 0.84, green: 0.78, blue: 1, alpha: 1)
        : UIColor(red: 0.30, green: 0.24, blue: 0.43, alpha: 1)
    }
    delegate = self
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self else { return result(nil) }
      switch call.method {
      case "attach":
        // Flutter is listening now: say again what it may have missed during start-up.
        self.lastInset = -1
        result(true)
        DispatchQueue.main.async { self.reportInset() }
      case "hide":
        // Before the first start there is nothing to switch to; the Duo's bar stays.
        if !self.vertical {
          self.setTabBarHidden(true, animated: false)
          self.reportInset()
        }
        result(nil)
      case "update":
        let a = call.arguments as? [String: Any] ?? [:]
        self.update(
          index: a["index"] as? Int ?? self.selectedIndex,
          titles: a["titles"] as? [String] ?? [],
          canGoBack: a["canGoBack"] as? Bool ?? false,
          back: a["back"] as? String ?? "")
        result(nil)
      default: result(FlutterMethodNotImplemented)
      }
    }
  }

  required init?(coder: NSCoder) { fatalError("not used") }

  // The bottom bar floats over the page and is not part of the safe area Flutter sees,
  // so Flutter is told how tall it is and keeps its content clear of it.
  private func reportInset() {
    let inset: CGFloat =
      vertical || isTabBarHidden ? 0 : max(0, view.bounds.height - tabBar.frame.minY)
    guard inset != lastInset else { return }
    lastInset = inset
    channel.invokeMethod("inset", arguments: Double(inset))
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    reportInset()
  }

  private func update(index: Int, titles: [String], canGoBack: Bool, back: String) {
    for (i, title) in titles.enumerated() where i < hosts.count {
      hosts[i].navigationController?.tabBarItem.title = title
    }
    if index != selectedIndex, hosts.indices.contains(index) { selectedIndex = index }
    if vertical {
      for host in hosts {
        if canGoBack {
          let item = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            primaryAction: UIAction { [weak self] _ in
              self?.channel.invokeMethod("back", arguments: nil)
            })
          item.accessibilityLabel = back
          if #available(iOS 27.1, *) { item.axisBehavior = .verticalPreferred }
          host.toolbarItems = [item]
          host.navigationController?.setToolbarHidden(false, animated: false)
        } else {
          host.toolbarItems = nil
          host.navigationController?.setToolbarHidden(true, animated: false)
        }
      }
    } else {
      // A pushed screen has its own back arrow and covers the tabs, as it did with the
      // app's own bar.
      setTabBarHidden(canGoBack, animated: true)
      reportInset()
    }
  }

  func tabBarController(
    _ tabBarController: UITabBarController, didSelect viewController: UIViewController
  ) {
    channel.invokeMethod("select", arguments: selectedIndex)
  }
}

/// One tab's page: takes the shared Flutter view when it comes on screen.
@available(iOS 26, *)
final class TabHost: UIViewController {
  private unowned let tabs: NativeTabs
  init(tabs: NativeTabs) {
    self.tabs = tabs
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) { fatalError("not used") }

  // The Flutter view moves between the tabs' pages. Left to UIKit, every move tells it
  // "disappeared" (Flutter pauses and drops its surface) and the matching "appeared" does
  // not always follow, which froze the picture on the tab it came back to. So the pages
  // forward nothing, and the view is told once that it is on screen.
  override var shouldAutomaticallyForwardAppearanceMethods: Bool { false }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let flutter = tabs.flutter
    guard flutter.parent !== self else { return }
    flutter.willMove(toParent: nil)
    flutter.view.removeFromSuperview()
    flutter.removeFromParent()
    addChild(flutter)
    flutter.view.frame = view.bounds
    flutter.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(flutter.view)
    flutter.didMove(toParent: self)
    if !tabs.flutterShown {
      tabs.flutterShown = true
      flutter.beginAppearanceTransition(true, animated: false)
      flutter.endAppearanceTransition()
    }
  }
}
