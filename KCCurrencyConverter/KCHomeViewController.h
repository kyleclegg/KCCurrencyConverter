//
//  KCViewController.h
//  KCCurrencyConverter
//
//  Created by Kyle Clegg on 4/3/13.
//  Copyright (c) 2013 Kyle Clegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCCurrencySelectViewController.h"

@interface KCHomeViewController : UIViewController <CurrencySelectViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *fromCurrencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *toCurrencyLabel;

@property (weak, nonatomic) IBOutlet UITextField *fromCurrencyTextField;
@property (weak, nonatomic) IBOutlet UITextField *toCurrencyTextField;

@end
