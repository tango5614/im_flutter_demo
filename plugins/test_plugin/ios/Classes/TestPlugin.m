#import "TestPlugin.h"
#import <test_plugin/test_plugin-Swift.h>

@implementation TestPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTestPlugin registerWithRegistrar:registrar];
}
@end
