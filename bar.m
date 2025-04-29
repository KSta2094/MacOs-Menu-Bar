#import <Cocoa/Cocoa.h>

#define BOXWIDTH 55.0  // make a little wider for nice fit
#define BOXHEIGHT 25.0 // taller
#define radius 15.0    // half height for nice rounding
#define fontSize 12.0  // matching font size
#define HEIGHT 35
#define COLOR systemPurpleColor
#define OPACITY 0.1
@interface BarWindow : NSWindow
@end

@implementation BarWindow
- (BOOL)canBecomeKeyWindow {
  return YES;
}
@end

// TODO
void test() {}

NSTextField *createField(CGFloat x) {

  NSTextField *text =
      [[NSTextField alloc] initWithFrame:NSMakeRect(x, 5, BOXWIDTH, BOXHEIGHT)];
  [text
      setFont:[NSFont systemFontOfSize:fontSize]]; // Slightly smaller than icon
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
  return text;
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
    NSRect barFrame = NSMakeRect(screenFrame.origin.x + 2,
                                 screenFrame.origin.y - 4 +
                                     screenFrame.size.height - barHeight,
                                 screenFrame.size.width, barHeight);

    NSTextField *icon = createField(20);
    [icon setStringValue:@"􀪏"]; // SF Symbol character
                                   //
    NSTextField *curent_app = createField(90);
    NSString *arrow = @"􀯻 ";
    [curent_app
        setStringValue:[arrow
                           stringByAppendingString:
                               run_command(@"aerospace list-windows --focused "
                                           @"--format %{app-name}")]];

    // Setup workspace text
    NSTextField *crt_work = createField(160);
    [crt_work
        setStringValue:run_command(@"aerospace list-workspaces --focused")];

    NSButton *btn = [[NSButton alloc]
        initWithFrame:NSMakeRect(300, 5, BOXWIDTH, BOXHEIGHT)];
    [btn setTitle:@"CONF"];
    // Create window
    BarWindow *window =
        [[BarWindow alloc] initWithContentRect:barFrame
                                     styleMask:NSWindowStyleMaskBorderless
                                       backing:NSBackingStoreBuffered
                                         defer:NO];

    [window setLevel:NSStatusWindowLevel]; // Always on top
    [window setOpaque:NO];
    [window setBackgroundColor:[[NSColor systemPurpleColor]
                                   colorWithAlphaComponent:0.05]];
    [window setIgnoresMouseEvents:YES]; // If you want it to be clickable,
                                        // otherwise YES
    [window makeKeyAndOrderFront:nil];
    [[window contentView] addSubview:crt_work];
    [[window contentView] addSubview:icon];
    [[window contentView] addSubview:curent_app];
    [[window contentView] addSubview:btn];

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
