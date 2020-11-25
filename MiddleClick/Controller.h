#import <Cocoa/Cocoa.h>

@interface Controller : NSObject {
}

- (void)start;
- (void)setMode:(BOOL)click;
- (BOOL)getClickMode;
- (void)scheduleRestart:(NSTimeInterval)delay;

@end
