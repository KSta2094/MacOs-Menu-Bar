#import "Cocoa/Cocoa.h"
#import "include/BarUI.h"
#import "include/constants.h"
#import "include/utils.h"
@interface BarWindow : NSWindow
@end

@implementation BarWindow
- (BOOL)canBecomeKeyWindow {
  return YES;
}
@end
// I am in the work direcotry
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

    NSTextField *icon = [[BarUI alloc] createField:20];
    [icon setStringValue:@"􀪏"]; // SF Symbol character
                                   //
    NSTextField *curent_app = [[BarUI alloc] createField:160];
    NSString *arrow = @"􀯻 ";

    [curent_app
        setStringValue:[arrow
                           stringByAppendingString:
                               run_command(@"aerospace list-windows --focused "
                                           @"--format %{app-name}")]];

    // Setup workspace text
    NSTextField *crt_work = [[BarUI alloc] createField:90];
    [crt_work
        setStringValue:run_command(@"aerospace list-workspaces --focused")];

    NSTextField *time = [[BarUI alloc] createField:0];
    [time setStringValue:run_command(@"date '+%a %e %b %H:%M'")];

    NSTextField *current_song = [[BarUI alloc] createField:0];
    NSString *song = @"􀑪 ";
    [current_song
        setStringValue:run_command(
                           @"osascript -e 'tell application \"Spotify\" to if "
                           @"player state is playing then artist of current "
                           @"track & \" - \" & name of current track'")];

    NSString *empty = @"";

    NSTextField *battery = [[BarUI alloc] createField:0];
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
    [window setIgnoresMouseEvents:NO]; // If you want it to be clickable,
                                       // otherwise YES
    [window makeKeyAndOrderFront:nil];
    [[window contentView] addSubview:crt_work];
    [[window contentView] addSubview:icon];
    [[window contentView] addSubview:curent_app];
    [[window contentView] addSubview:time];
    [[window contentView] addSubview:current_song];
    [[window contentView] addSubview:battery];

    NSTimer *t = [NSTimer
        scheduledTimerWithTimeInterval:1.0
                               repeats:YES
                                 block:^(NSTimer *_Nonnull timer) {
                                   [crt_work
                                       setStringValue:
                                           run_command(
                                               @"aerospace list-workspaces "
                                               @"--focused")];
                                   adjustTextFieldLeft(
                                       battery,
                                       charge(run_command(
                                                  @"pmset -g batt | grep -Eo "
                                                  @"'[0-9]+%' | tr -d '%'")
                                                  .intValue),
                                       [NSFont systemFontOfSize:fontSize],
                                       time.frame.size.width + 20);
                                   adjustTextFieldLeft(
                                       current_song,
                                       [song stringByAppendingString:
                                                 run_command(
                                                     @"osascript -e 'tell "
                                                     @"application "
                                                     @"\"Spotify\" to if "
                                                     @"player state is "
                                                     @"playing then artist "
                                                     @"of current "
                                                     @"track & \" - \" & "
                                                     @"name of current "
                                                     @"track'")],
                                       [NSFont systemFontOfSize:fontSize],
                                       battery.frame.size.width +
                                           time.frame.size.width + 40);

                                   if ([empty
                                           isEqualToString:
                                               run_command(@"osascript -e "
                                                           @"'tell application "
                                                           @"\"Spotify\" to if "
                                                           @"player state is "
                                                           @"playing then "
                                                           @"artist of current "
                                                           @"track & \" - \" & "
                                                           @"name of current "
                                                           @"track'")]) {

                                     [current_song setHidden:YES];
                                   } else {
                                     [current_song setHidden:NO];
                                   };

                                   adjustTextFieldRight(
                                       curent_app,
                                       [arrow stringByAppendingString:
                                                  run_command(@"aerospace "
                                                              @"list-windows "
                                                              @"--focused "
                                                              @"--format "
                                                              @"%{app-name}")],
                                       [NSFont systemFontOfSize:fontSize], 15);

                                   adjustTextFieldLeft(
                                       time,
                                       run_command(@"date '+%a %e %b %H:%M'"),
                                       [NSFont systemFontOfSize:fontSize], 5);
                                 }];
    [NSApp run];
  }

  return 0;
}
