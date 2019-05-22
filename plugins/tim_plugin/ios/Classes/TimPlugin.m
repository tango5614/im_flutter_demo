#import "TimPlugin.h"
#import <tim_plugin/tim_plugin-Swift.h>

@implementation TimPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTimPlugin registerWithRegistrar:registrar];
}
@end
