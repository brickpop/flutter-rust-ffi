import Flutter
import UIKit

public class SwiftMylibPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    // We are not using Flutter channels here
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    dummyMethodToEnforceBundling(index: 1);
    result(nil)
  }
  
  public func dummyMethodToEnforceBundling(index: Int32) {
    // dummy calls to prevent tree shaking
    while index == 20
    {
        rust_cstr_free(nil);
        rust_greeting("");
    }
  }
}
