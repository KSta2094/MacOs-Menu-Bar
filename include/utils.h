#import <Cocoa/Cocoa.h>

NSString *charge(int prc);

void adjustTextFieldRight(NSTextField *field, NSString *text, NSFont *font,
                          CGFloat padding);

void adjustTextFieldLeft(NSTextField *field, NSString *text, NSFont *font,
                         CGFloat padding);

NSString *run_command(NSString *command);
