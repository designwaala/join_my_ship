import UIKit
import Flutter
import Firebase
import FirebaseAuth
import flutter_downloader
import StoreKit



@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private var productIDs = [
//    "test"
    "goldplan", "silverplan", "platinumplan"
  ]
    
    
    @Published private(set) var activeTransactions: Set<StoreKit.Transaction> = []
    var products = [Product]()
    
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    FlutterDownloaderPlugin.setPluginRegistrantCallback({ registry in
       if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
         FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
       }
    })
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let deviceChannel = FlutterMethodChannel(name: "com.joinmyship.ios/iOS",  binaryMessenger: controller.binaryMessenger)
      prepareMethodHandler(deviceChannel: deviceChannel)
      let chargingChannel = FlutterEventChannel(name: "com.joinmyship.ios/event",
                                                binaryMessenger: controller.binaryMessenger)
      chargingChannel.setStreamHandler(PurchaseHandler())
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func prepareMethodHandler(deviceChannel: FlutterMethodChannel) {
            deviceChannel.setMethodCallHandler({
                (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                do {
                    if call.method == "getProducts", #available(iOS 15.0, *) {
                        Task {
                            await self.getProducts(result: result)
                        }
                    }
                    else if call.method == "purchase", #available(iOS 15.0, *) {
                        let productId = call.arguments as? String
                        Task {
                            await self.purchase(productId: productId!, result:result)
                        }
                    }
                    else if call.method == "finishTransaction", #available(iOS 15.0, *) {
                        let arguments = call.arguments as? Dictionary<String, Any>
                        let transactionId = arguments?["transaction_id"]
                        let productId = arguments?["product_id"]
                        if transactionId is UInt64, productId is String {
                            Task {
                                await self.finishTransaction(transactionId: transactionId as! UInt64, productId: productId  as! String, result:result)
                            }
                        }
                    }
                    else {
                        result(FlutterMethodNotImplemented)
                        return
                    }
                }catch {
                    
                }
            })
    }

    private func registerPlugins(registry: FlutterPluginRegistry) {
        if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
           FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
        }
    }

    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
        let firebaseAuth = Auth.auth()
        firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.unknown)
    }
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let firebaseAuth = Auth.auth()
        if (firebaseAuth.canHandleNotification(userInfo)){
            print(userInfo)
            return
        }
    }
    
    
    
    @MainActor
    @available(iOS 15.0, *)
    func getProducts(result: FlutterResult) async {
        do {
            print(productIDs)
            products = try await Product.products(for: productIDs)
            print("native line 74")
            print("\(products)")
        } catch {
            print(error)
        }
        var productsDictionary : Array<Dictionary<String, String>> = []
        products.forEach { product in
            productsDictionary.append([
                "id": product.id,
                "price": "\(product.price)",
                "display_name": product.displayName,
                "description": product.description,
                "display_price": product.displayPrice,
                "currency": product.priceFormatStyle.currencyCode
            ])
        }
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(productsDictionary)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            result(json)
        } catch {
            print("Error converting to json")
        }
  }
    
    
    @available(iOS 15.0, *)
    func purchase(productId: String, result: FlutterResult) async {
        do {
            var productToBuy: Product? = products.first(where: { $0.id == productId })
            let purchaseResult = try await productToBuy?.purchase()
            switch purchaseResult {
            case .success(let verificationResult):
                if let transaction = try? verificationResult.payloadValue {
                    activeTransactions.insert(transaction)
//                    await transaction.finish()
                    result([
                        "id": transaction.id,
                        "product_id": transaction.productID
                    ])
                    break
                }
            case .userCancelled:
                result("user_cancelled")
                break
            case .pending:
                result("pending")
                break
            @unknown default:
                break
            }
        } catch {
            
        }
    }
    
    func finishTransaction(transactionId: UInt64, productId: String, result: FlutterResult) async {
        do {
            print(transactionId)
            var transactionToFinish: StoreKit.Transaction? = activeTransactions.first(where: { $0.id == transactionId })
            if transactionToFinish == nil {
                let product = products.first(where: {$0.id == productId})
    //            let transactions: VerificationResult<Transaction>? = await product?.
                let transaction = await product?.latestTransaction
                print(try transaction?.payloadValue)
                if try transaction?.payloadValue.id == transactionId {
                    transactionToFinish = try transaction?.payloadValue
                }
    //            transactionToFinish = transactions.first(where: { $0.id == transactionId })
            }
            print(transactionToFinish)
            await transactionToFinish?.finish()
            result(transactionToFinish != nil)
        }catch {
            print("There was an issue in completing the transaction")
        }
    }
    
    class PurchaseHandler: NSObject, FlutterStreamHandler {
           
        private var updates: Task<Void, Never>?
        private var eventSink: FlutterEventSink?
        
        func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
            print("onListen......")
            self.eventSink = eventSink
    
            updates = Task {
                for await update in StoreKit.Transaction.updates {
                    if let transaction = try? update.payloadValue {
                        print(transaction)
                        eventSink(["id": transaction.id,
                                   "product_id": transaction.productID
                                  ])
                    }
                }
            }
            return nil
        }
        
        func onCancel(withArguments arguments: Any?) -> FlutterError? {
            eventSink = nil
            updates?.cancel()
            return nil
        }
       }
}


