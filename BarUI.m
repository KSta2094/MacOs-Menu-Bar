// BarUI.m
#import "include/BarUI.h"
#import "include/constants.h" // Make sure BOXWIDTH, BOXHEIGHT, fontSize, etc., are defined here

@implementation BarUI

- (NSTextField *)createField:(CGFloat)x menu:(Boolean)menu {
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

- (void)showMenuFromTextField:(NSClickGestureRecognizer *)recognizer {

  NSTextField *field = (NSTextField *)recognizer.view;

  // Create your custom view
  NSView *itemView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 300, 60)];

  NSImageView *artwork =
      [[NSImageView alloc] initWithFrame:NSMakeRect(10, 10, 40, 40)];
  [artwork setImage:[NSImage imageNamed:@"defaultArt"]];
  [artwork setImageScaling:NSImageScaleProportionallyUpOrDown];
  [itemView addSubview:artwork];

  NSTextField *titleField =
      [[NSTextField alloc] initWithFrame:NSMakeRect(60, 30, 180, 20)];
  [titleField setStringValue:@"Modest"];
  [titleField setFont:[NSFont boldSystemFontOfSize:13]];
  [titleField setBordered:NO];
  [titleField setEditable:NO];
  [titleField setBezeled:NO];
  [titleField setDrawsBackground:NO];
  [itemView addSubview:titleField];

  NSTextField *subtitleField =
      [[NSTextField alloc] initWithFrame:NSMakeRect(60, 12, 180, 16)];
  [subtitleField setStringValue:@"Isaiah Rashad – Cilvia Demo"];
  [subtitleField setFont:[NSFont systemFontOfSize:11]];
  [subtitleField setTextColor:[NSColor secondaryLabelColor]];
  [subtitleField setBordered:NO];
  [subtitleField setEditable:NO];
  [subtitleField setBezeled:NO];
  [subtitleField setDrawsBackground:NO];
  [itemView addSubview:subtitleField];

  NSButton *playButton =
      [[NSButton alloc] initWithFrame:NSMakeRect(250, 20, 20, 20)];
  [playButton setBezelStyle:NSBezelStyleShadowlessSquare];
  [playButton setTitle:@"▶︎"];
  [itemView addSubview:playButton];

  // Wrap your itemView in a view controller
  NSViewController *vc = [[NSViewController alloc] init];
  vc.view = itemView;

  // Create and configure popover
  NSPopover *popover = [[NSPopover alloc] init];
  popover.contentViewController = vc;
  popover.behavior = NSPopoverBehaviorTransient;
  popover.contentSize = itemView.frame.size;

  // Show the popover relative to the text field
  [popover showRelativeToRect:field.bounds
                       ofView:field
                preferredEdge:NSRectEdgeMaxY];
}

@end
