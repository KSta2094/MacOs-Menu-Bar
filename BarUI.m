// BarUI.m
#import "include/BarUI.h"
#import "include/constants.h" // Make sure BOXWIDTH, BOXHEIGHT, fontSize, etc., are defined here

@implementation BarUI

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

  // Add click recognizer (optional)
  NSClickGestureRecognizer *clickRecognizer = [[NSClickGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(showMenuFromTextField:)];
  [text addGestureRecognizer:clickRecognizer];

  return text;
}

- (void)showMenuFromTextField:(NSClickGestureRecognizer *)recognizer {
  NSLog(@"Text field clicked — show menu here if desired.");
}

@end
