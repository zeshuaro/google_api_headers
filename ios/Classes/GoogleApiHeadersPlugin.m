#import "GoogleApiHeadersPlugin.h"
#if __has_include(<google_api_headers/google_api_headers-Swift.h>)
#import <google_api_headers/google_api_headers-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "google_api_headers-Swift.h"
#endif

@implementation GoogleApiHeadersPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGoogleApiHeadersPlugin registerWithRegistrar:registrar];
}
@end
