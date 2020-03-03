#import <Flutter/Flutter.h>

@interface MylibPlugin : NSObject<FlutterPlugin>
@end
// NOTE: Append the lines below to ios/Classes/<your>Plugin.h

char *rust_greeting(const char *to);

void rust_greeting_free(char *s);
