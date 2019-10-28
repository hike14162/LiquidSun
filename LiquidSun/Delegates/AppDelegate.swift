
import UIKit

var reachabilityStatus = 0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var iNetReach: Reachability?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: NSNotification.Name.reachabilityChanged, object: nil)
        
        iNetReach = Reachability.forInternetConnection()
        iNetReach?.startNotifier()
        if (iNetReach != nil) {
            self.statusChangedWithReachability(iNetReach!)
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "foregroundEntered"), object:nil)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.reachabilityChanged, object: nil)
    }

    @objc func reachabilityChanged(_ notification: Notification) {
        let reachability = notification.object as? Reachability
        self.statusChangedWithReachability(reachability!)
    }

    func statusChangedWithReachability (_ currentReachabilityStatus: Reachability) {
        let networkStatus: NetworkStatus = currentReachabilityStatus.currentReachabilityStatus()
        reachabilityStatus = networkStatus.rawValue
    }

    
}

