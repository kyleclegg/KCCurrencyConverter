//
//  KCCurrencySelectViewController.h
//  KCCurrencyConverter
//
//  Created by Kyle Clegg on 4/5/13.
//  Copyright (c) 2013 Kyle Clegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KCCurrencySelectViewController : UITableViewController

@property (strong, nonatomic) NSDictionary *currencyTypes;
@property (assign, nonatomic) BOOL isFromCurrencyType;

@end
