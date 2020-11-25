#import "TrayMenu.h"
#import "Controller.h"
#import <Cocoa/Cocoa.h>

@implementation TrayMenu

- (id)initWithController:(Controller*)ctrl
{
  [super init];
  myController = ctrl;
  [self setChecks];
  return self;
}

- (void)openWebsite:(id)sender
{
  NSURL* url = [NSURL
                URLWithString:@"https://github.com/DaFuqtor/MiddleClick"];
  [[NSWorkspace sharedWorkspace] openURL:url];
}

- (void)setClick:(id)sender
{
  [myController setMode:YES];
  [self setChecks];
}

- (void)setTap:(id)sender
{
  [myController setMode:NO];
  [self setChecks];
}

- (void)restart:(id)sender
{
    [myController scheduleRestart:2];
}

- (void)setChecks
{
  if ([myController getClickMode]) {
    [clickItem setState:NSControlStateValueOn];
    [tapItem setState:NSControlStateValueOff];
  } else {
    [clickItem setState:NSControlStateValueOff];
    [tapItem setState:NSControlStateValueOn];
  }
}

- (void)actionQuit:(id)sender
{
  [NSApp terminate:sender];
}

- (NSMenu*)createMenu
{
  NSMenu* menu = [NSMenu new];
  NSMenuItem* menuItem;
  
  
  
  int fingersQua = [[NSUserDefaults standardUserDefaults] integerForKey:@"fingers"];
  
  // Add About
  menuItem = [menu addItemWithTitle:@"About MiddleClick"
                             action:@selector(openWebsite:)
                      keyEquivalent:@""];
  [menuItem setTarget:self];
  
  [menu addItem:[NSMenuItem separatorItem]];
  
  clickItem = [menu addItemWithTitle:[NSString stringWithFormat: @"%d Finger Click", fingersQua]
                              action:@selector(setClick:)
                       keyEquivalent:@""];
  [clickItem setTarget:self];
  
  tapItem = [menu addItemWithTitle:[NSString stringWithFormat: @"%d Finger Tap", fingersQua]
                            action:@selector(setTap:)
                     keyEquivalent:@""];
  [tapItem setTarget:self];
  
  [self setChecks];
  
  // Add Separator
  [menu addItem:[NSMenuItem separatorItem]];
    
    restartItem = [menu addItemWithTitle:@"Restart" action:@selector(restart:) keyEquivalent:@"r"];
    [restartItem setTarget:self];
  // Add Quit Action
  menuItem = [menu addItemWithTitle:@"Quit"
                             action:@selector(actionQuit:)
                      keyEquivalent:@"q"];
  [menuItem setTarget:self];
  
  return menu;
}

- (void)applicationDidFinishLaunching:(NSNotification*)notification
{
  NSMenu* menu = [self createMenu];
  
  NSImage* icon = [NSImage imageNamed:(@"StatusIcon")];
  [icon setSize:CGSizeMake(24, 24)];
  
  // Check if Darkmode menubar is supported and enable templating of the icon in
  // that case.
  
  BOOL oldBusted = (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_9);
  if (!oldBusted) {
    // 10.10 or higher, so setTemplate: is safe
    [icon setTemplate:YES];
  }
  
  _statusItem = [[[NSStatusBar systemStatusBar]
                  statusItemWithLength:24] retain];
  _statusItem.behavior = NSStatusItemBehaviorRemovalAllowed;
  _statusItem.menu = menu;
  _statusItem.button.toolTip = @"MiddleClick";
  _statusItem.button.image = icon;
  
  [menu release];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender
                    hasVisibleWindows:(BOOL)flag
{
  _statusItem.visible = true;
  return 1;
}

@end
