#import "Cocoa/Cocoa.h"
#import "include/constants.h"

void adjustTextFieldRight(NSTextField *field, NSString *text, NSFont *font,
                          CGFloat padding) {
  NSDictionary *attributes = @{NSFontAttributeName : font};
  NSSize textSize = [text sizeWithAttributes:attributes];
  [field setStringValue:text];

  NSRect frame = [field frame];
  frame.size.width = textSize.width + padding;

  [field setFrame:frame];
}

void adjustTextFieldLeft(NSTextField *field, NSString *text, NSFont *font,
                         CGFloat padding) {
  NSDictionary *attributes = @{NSFontAttributeName : font};
  NSSize textSize = [text sizeWithAttributes:attributes];
  [field setStringValue:text];

  NSRect frame = [field frame];
  frame.size.width = textSize.width + 20;
  frame.origin.x = [[NSScreen mainScreen] frame].size.width - frame.size.width -
                   padding - 10;

  [field setFrame:frame];
}

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
  [text setLineBreakMode:NSLineBreakByTruncatingTail];
  [text.cell setUsesSingleLineMode:YES];
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
