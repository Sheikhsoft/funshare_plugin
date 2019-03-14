#import "FunsharePlugin.h"
#import <funshare_plugin/funshare_plugin-Swift.h>

@implementation FunsharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFunsharePlugin registerWithRegistrar:registrar];
}
@end
