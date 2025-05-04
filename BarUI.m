// BarUI.m
#import "include/BarUI.h"
#import "include/constants.h" // Make sure BOXWIDTH, BOXHEIGHT, fontSize, etc., are defined here
#import <objc/runtime.h> // Required for associated objects
@implementation BarUI

// Key for associated block
static const void *ClickHandlerKey = &ClickHandlerKey;

// Internal method to call the stored block
- (void)handleClick:(NSClickGestureRecognizer *)recognizer {
  void (^handler)(NSClickGestureRecognizer *) =
      objc_getAssociatedObject(recognizer, ClickHandlerKey);
  if (handler) {
    handler(recognizer);
  }
}

// Main method that accepts a click handler
- (NSTextField *)createField:(CGFloat)x
                    function:
                        (void (^)(NSClickGestureRecognizer *recognizer))func {
  NSTextField *text =
      [[NSTextField alloc] initWithFrame:NSMakeRect(x, 5, BOXWIDTH, BOXHEIGHT)];

  [text setFont:[NSFont systemFontOfSize:fontSize]];
  [text setAlignment:NSTextAlignmentCenter];
  [text setEditable:NO];
  [text setBordered:NO];
  [text setBezeled:NO];
  [text setDrawsBackground:YES];
  [text setBackgroundColor:[[NSColor COLOR] colorWithAlphaComponent:OPACITY]];
  [text setSelectable:NO];
  [text setWantsLayer:YES];
  text.layer.cornerRadius = radius;
  text.layer.masksToBounds = YES;
  [text setLineBreakMode:NSLineBreakByTruncatingTail];
  [text.cell setUsesSingleLineMode:YES];

  // Create and assign click recognizer
  NSClickGestureRecognizer *clickRecognizer =
      [[NSClickGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleClick:)];
  [text addGestureRecognizer:clickRecognizer];

  // Store the block as associated object
  if (func) {
    objc_setAssociatedObject(clickRecognizer, ClickHandlerKey, func,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
  }

  return text;
}

- (NSTextField *)createField:(CGFloat)x {
  NSTextField *text =
      [[NSTextField alloc] initWithFrame:NSMakeRect(x, 5, BOXWIDTH, BOXHEIGHT)];

  [text setFont:[NSFont systemFontOfSize:fontSize]];
  [text setAlignment:NSTextAlignmentCenter];
  [text setEditable:NO];
  [text setBordered:NO];
  [text setBezeled:NO];
  [text setDrawsBackground:YES];
  [text setBackgroundColor:[[NSColor COLOR] colorWithAlphaComponent:OPACITY]];
  [text setSelectable:NO];
  [text setWantsLayer:YES];
  text.layer.cornerRadius = radius;
  text.layer.masksToBounds = YES;
  [text setLineBreakMode:NSLineBreakByTruncatingTail];
  [text.cell setUsesSingleLineMode:YES];

  return text;
}

@end
