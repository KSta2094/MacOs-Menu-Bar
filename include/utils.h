#import <Cocoa/Cocoa.h>


void adjustTextFieldRight(NSTextField *field, NSString *text, NSFont *font,
                          CGFloat padding);

void adjustTextFieldLeft(NSTextField *field, NSString *text, NSFont *font,
                         CGFloat padding);

NSTextField *createField(CGFloat x) ;

NSString *run_command(NSString *command) ;

