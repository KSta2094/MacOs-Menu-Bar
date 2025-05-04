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

    NSTextField *current_song = [[BarUI alloc]
        createField:0
           function:^(NSClickGestureRecognizer *recognizer) {
             NSTextField *field = (NSTextField *)recognizer.view;

             // Create your custom view
             NSView *itemView =
                 [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 300, 60)];

             NSImageView *artwork =
                 [[NSImageView alloc] initWithFrame:NSMakeRect(10, 10, 40, 40)];
             [artwork setImage:[NSImage imageNamed:@"defaultArt"]];
             [artwork setImageScaling:NSImageScaleProportionallyUpOrDown];
             [itemView addSubview:artwork];

             NSTextField *titleField = [[NSTextField alloc]
                 initWithFrame:NSMakeRect(60, 30, 180, 20)];
             [titleField setStringValue:@"Modest"];
             [titleField setFont:[NSFont boldSystemFontOfSize:13]];
             [titleField setBordered:NO];
             [titleField setEditable:NO];
             [titleField setBezeled:NO];
             [titleField setDrawsBackground:NO];
             [itemView addSubview:titleField];

             NSTextField *subtitleField = [[NSTextField alloc]
                 initWithFrame:NSMakeRect(60, 12, 180, 16)];
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
           }];
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
