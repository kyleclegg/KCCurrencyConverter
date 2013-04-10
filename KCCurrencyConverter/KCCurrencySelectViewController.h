//
//  KCCurrencySelectViewController.h
//  KCCurrencyConverter
//
//  Created by Kyle Clegg on 4/5/13.
//  Copyright (c) 2013 Kyle Clegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CurrencySelectViewControllerDelegate;

@interface KCCurrencySelectViewController : UITableViewController

@property (nonatomic, weak) id <CurrencySelectViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *currencyTypes;
@property (strong, nonatomic) NSString *selectedCurrencyCode;
@property (assign, nonatomic) BOOL isFromCurrencyType;

@end

@protocol CurrencySelectViewControllerDelegate <NSObject>

- (void)currencyCodeSelected:(NSString *)countryCode forFromCurrency:(BOOL)isFromCurrency;

@end