#import "MylibPlugin.h"
#if __has_include(<mylib/mylib-Swift.h>)
#import <mylib/mylib-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "mylib-Swift.h"
#endif

@implementation MylibPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMylibPlugin registerWithRegistrar:registrar];
}
@end
