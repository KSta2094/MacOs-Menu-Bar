#import "Cocoa/Cocoa.h"
#import "include/constants.h"

NSString *charge(int prc) {

  NSString *charge = @"[";
  int iter = round(prc / 10);
  for (int i = 0; i != iter; i++) {
    charge = [charge stringByAppendingString:@":"];
  }
  for (int i = 0; i != 10 - iter; i++) {

    charge = [charge stringByAppendingString:@" "];
  }

  charge = [charge stringByAppendingString:@"]"];
  return charge;
}

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
                   padding - 20;

  [field setFrame:frame];
}
void showMenuFromTextField() { NSLog(@"clicked"); }
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
