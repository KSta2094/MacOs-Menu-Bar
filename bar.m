#import <Cocoa/Cocoa.h>

#define BOXWIDTH 60.0  // make a little wider for nice fit
#define BOXHEIGHT 30.0 // taller
#define radius 15.0    // half height for nice rounding
#define fontSize 14.0  // matching font size
#define HEIGHT 40
@interface BarWindow : NSWindow
@end

@implementation BarWindow
- (BOOL)canBecomeKeyWindow {
  return YES;
}
@end

// TODO
// create function to make a text filed so that i have uniform way of making
// thme

NSTextField *createField() {
  return [[NSTextField alloc]
      initWithFrame:NSMakeRect(20, 5, BOXWIDTH, BOXHEIGHT)];
}

NSString *run_command(NSString *command) {
  FILE *fp;
  char buffer[4096];
  NSMutableString *result = [NSMutableString string];

  // Open the command for reading
  fp = popen([command UTF8String], "r");
  if (fp == NULL) {
    NSLog(@"Failed to run command");
    return nil;
  }

  // Read the output a chunk at a time and append to result
  while (fgets(buffer, sizeof(buffer), fp) != NULL) {
    NSString *line = [NSString stringWithUTF8String:buffer];
    if (line) {
      [result appendString:line];
    }
  }

  // Close
  pclose(fp);

  return result;
}

int main(int argc, const char *argv[]) {
  @autoreleasepool {
    // Start the app
    [NSApplication sharedApplication];

    // Get screen size
    NSScreen *screen = [NSScreen mainScreen];
    NSRect screenFrame = [screen frame];

    // Define bar height
    CGFloat barHeight = HEIGHT;

    // Create a frame at the top of the screen
    NSRect barFrame =
        NSMakeRect(screenFrame.origin.x,
                   screenFrame.origin.y + screenFrame.size.height - barHeight,
                   screenFrame.size.width, barHeight);

    NSTextView *icon = [[NSTextView alloc]
        initWithFrame:NSMakeRect(20, 5, BOXWIDTH, BOXHEIGHT)];

    // Setup icon text
    [icon setString:@"􀪏"]; // SF Symbol character
    [icon setFont:[NSFont systemFontOfSize:fontSize + 6]];
    [icon setAlignment:NSTextAlignmentCenter]; // Center the text
    [icon setEditable:NO];
    [icon setDrawsBackground:YES];
    [icon setSelectable:NO];
    [icon setWantsLayer:YES];
    [icon setBackgroundColor:[[NSColor systemGreenColor]
                                 colorWithAlphaComponent:0.6]];
    icon.layer.cornerRadius = radius;
    icon.layer.masksToBounds = YES;

    NSTextField *curent_app = [[NSTextField alloc]
        initWithFrame:NSMakeRect(90, 5, BOXWIDTH, BOXHEIGHT)];

    [curent_app
        setFont:[NSFont systemFontOfSize:12]]; // Slightly smaller than icon
    [curent_app setAlignment:NSTextAlignmentCenter];
    [curent_app setEditable:NO];
    [curent_app setBordered:NO];
    [curent_app setBezeled:NO];
    [curent_app setDrawsBackground:YES];
    [curent_app setBackgroundColor:[[NSColor systemGreenColor]
                                       colorWithAlphaComponent:0.6]];
    [curent_app setSelectable:NO];
    [curent_app setWantsLayer:YES];
    curent_app.layer.cornerRadius = 15.0; // Half height = perfect pill
    curent_app.layer.masksToBounds = YES;
    NSString *arrow = @"􀯻 ";
    [curent_app
        setStringValue:[arrow
                           stringByAppendingString:
                               run_command(@"aerospace list-windows --focused "
                                           @"--format %{app-name}")]];

    // Setup workspace text
    NSTextField *crt_work = [[NSTextField alloc]
        initWithFrame:NSMakeRect(160, 5, BOXWIDTH, BOXHEIGHT)];
    [crt_work
        setFont:[NSFont systemFontOfSize:16]]; // Slightly smaller than icon
    [crt_work setAlignment:NSTextAlignmentCenter];
    [crt_work setEditable:NO];
    [crt_work setBordered:NO];
    [crt_work setBezeled:NO];
    [crt_work setDrawsBackground:YES];
    [crt_work setBackgroundColor:[[NSColor systemGreenColor]
                                     colorWithAlphaComponent:0.6]];
    [crt_work setSelectable:NO];
    [crt_work setWantsLayer:YES];
    crt_work.layer.cornerRadius = 15.0; // Half height = perfect pill
    crt_work.layer.masksToBounds = YES;
    [crt_work
        setStringValue:run_command(@"aerospace list-workspaces --focused")];

    // Create window
    BarWindow *window =
        [[BarWindow alloc] initWithContentRect:barFrame
                                     styleMask:NSWindowStyleMaskBorderless
                                       backing:NSBackingStoreBuffered
                                         defer:NO];

    [window setLevel:NSStatusWindowLevel]; // Always on top
    [window setOpaque:NO];
    [window setBackgroundColor:[[NSColor systemPurpleColor]
                                   colorWithAlphaComponent:0.0]];
    [window setIgnoresMouseEvents:YES]; // If you want it to be clickable,
                                        // otherwise YES
    [window makeKeyAndOrderFront:nil];
    [[window contentView] addSubview:crt_work];
    [[window contentView] addSubview:icon];
    [[window contentView] addSubview:curent_app];

    NSTimer *t = [NSTimer
        scheduledTimerWithTimeInterval:1.0
                               repeats:YES
                                 block:^(NSTimer *_Nonnull timer) {
                                   [crt_work
                                       setStringValue:
                                           run_command(
                                               @"aerospace list-workspaces "
                                               @"--focused")];

                                   [curent_app
                                       setStringValue:
                                           [arrow stringByAppendingString:
                                                      run_command(
                                                          @"aerospace "
                                                          @"list-windows "
                                                          @"--focused "
                                                          @"--format "
                                                          @"%{app-name}")]];
                                 }];
    [NSApp run];
  }

  return 0;
}
