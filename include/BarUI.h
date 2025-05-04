// BarUI.h
#import <Cocoa/Cocoa.h>

@interface BarUI : NSObject

- (NSTextField *)createField:(CGFloat)x;
- (NSTextField *)createField:(CGFloat)x
                    function:
                        (void (^)(NSClickGestureRecognizer *recognizer))func;
@end
