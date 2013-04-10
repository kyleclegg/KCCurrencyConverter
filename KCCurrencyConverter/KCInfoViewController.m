//
//  KCInfoViewController.m
//  KCCurrencyConverter
//
//  Created by Kyle Clegg on 4/10/13.
//  Copyright (c) 2013 Kyle Clegg. All rights reserved.
//

#import "KCInfoViewController.h"
#import "KCConstants.h"

@interface KCInfoViewController ()

@property (strong, nonatomic) UITapGestureRecognizer *tap;

- (void)dismissModal;

@end

@implementation KCInfoViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *disclaimer = [defaults objectForKey:kNSUserDefaultsDisclaimer];
  NSString *license = [defaults objectForKey:kNSUserDefaultsLicense];
  
  if (disclaimer != nil) {
    self.disclaimerLabel.text = disclaimer;
  }
  if (license != nil) {
    self.licenseLabel.text = license;
  }
  
  // Add a tap gesture recognizer to recognize clicks and close the modal
  self.tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dismissModal)];
  [self.view addGestureRecognizer:self.tap];
}

- (void)dismissModal
{
  [self dismissViewControllerAnimated:YES completion:^{
    [self.view removeGestureRecognizer:self.tap];
  }];
}

@end
