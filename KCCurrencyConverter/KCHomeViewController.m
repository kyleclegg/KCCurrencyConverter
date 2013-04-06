//
//  KCViewController.m
//  KCCurrencyConverter
//
//  Created by Kyle Clegg on 4/3/13.
//  Copyright (c) 2013 Kyle Clegg. All rights reserved.
//

#define kBackgroundQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "KCHomeViewController.h"
#import "KCHelpers.h"

@interface KCHomeViewController ()

@property (strong, nonatomic) NSDictionary *currencyTypes;
@property (strong, nonatomic) NSDictionary *latestCurrencyRates;

- (void)dismissKeyboard;

@end

@implementation KCHomeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Add a tap gesture recognizer to recognize clicks outside the keyboard and hide it appropriately
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dismissKeyboard)];
  
  [self.view addGestureRecognizer:tap];

  // Prepare HTTP request to get country codes and currency names
  NSString *countriesURLString = [NSString stringWithFormat:@"%@%@?app_id=%@", kBaseURL, kCountryCurrencies, kOpenExchangeRatesAppID];
  NSURL *countriesURL = [NSURL URLWithString:countriesURLString];
  
  // Send HTTP request using GCD
  dispatch_async(kBackgroundQueue, ^{
    NSData* data = [NSData dataWithContentsOfURL:
                    countriesURL];
    [self performSelectorOnMainThread:@selector(fetchedCurrencies:)
                           withObject:data waitUntilDone:YES];
  });
  
  // Prepare HTTP request to get latest conversion rates
  NSString *latestRatesURLString = [NSString stringWithFormat:@"%@%@?app_id=%@", kBaseURL, kLatestRates, kOpenExchangeRatesAppID];
  NSLog(@"url is %@", latestRatesURLString);
  
  NSURL *latestRatesURL = [NSURL URLWithString:latestRatesURLString];

  // Send HTTP request using GCD
  dispatch_async(kBackgroundQueue, ^{
    NSData* data = [NSData dataWithContentsOfURL:
                    latestRatesURL];
    [self performSelectorOnMainThread:@selector(fetchedLatestRates:)
                           withObject:data waitUntilDone:YES];
  });
  
}

#pragma mark - API Calls

- (void)fetchedCurrencies:(NSData *)responseData
{
  // Parse JSON using NSJSONSerialization
  NSError* error;
  self.currencyTypes = [NSJSONSerialization JSONObjectWithData:responseData
                                                           options:kNilOptions
                                                             error:&error];
  
  if (error == nil) {
    NSLog(@"successfully retrieved currencies");
//    NSLog(@"currency keys are %@", [self.currencyTypes allKeys]);
//    NSLog(@"currency values are %@", [self.currencyTypes allValues]);
  }
  else {
    NSLog(@"error parsing currency types");
  }
}

- (void)fetchedLatestRates:(NSData *)responseData
{
  // Parse JSON using NSJSONSerialization
  NSError* error;
  NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:responseData
                                                           options:kNilOptions
                                                             error:&error];
  
  // Save our data
  NSString *disclaimer = [jsonDict valueForKeyPath:@"disclaimer"];
  NSString *license = [jsonDict valueForKeyPath:@"license"];
  NSString *timestamp = [jsonDict valueForKeyPath:@"timestamp"];
  NSString *base = [jsonDict valueForKeyPath:@"base"];
  NSDictionary *rates = [jsonDict objectForKey:@"rates"];
  
  NSLog(@"Disclaimer: %@", disclaimer);
  NSLog(@"License: %@", license);
  NSLog(@"Timestamp: %@", timestamp);
  NSLog(@"Base: %@", base);
//  NSLog(@"Rates: %@", rates);
  
  NSDecimalNumber *AEDRate = [rates valueForKeyPath:@"AED"];
  NSLog(@"their rate is %@", AEDRate);
  
//  NSLog(@"rate keys are %@", [rates allKeys]);
//  NSLog(@"rate values are %@", [rates allValues]);
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"FromCurrencySelect"])
  {
    // Get reference to the destination view controller and set data to be passed forward
    KCCurrencySelectViewController *viewController = [segue destinationViewController];
    [viewController setDelegate:self];
    [viewController setCurrencyTypes:self.currencyTypes];
    [viewController setIsFromCurrencyType:YES];
  }
  else if ([[segue identifier] isEqualToString:@"ToCurrencySelect"])
  {
    // Get reference to the destination view controller and set data to be passed forward
    KCCurrencySelectViewController *viewController = [segue destinationViewController];
    [viewController setDelegate:self];
    [viewController setCurrencyTypes:self.currencyTypes];
    [viewController setIsFromCurrencyType:NO];
  }
}

#pragma mark - CurrencySelectViewControllerDelegate

- (void)currencyCodeSelected:(NSString *)countryCode forFromCurrency:(BOOL)isFromCurrency
{
  // Retrieve data from child view controller
  NSLog(@"user selected %@", countryCode);
  
  if (isFromCurrency) {
    [self.fromCurrencyLabel setText:[NSString stringWithFormat:NSLocalizedString(@"FROM_CURRENCY", nil), countryCode, [self.currencyTypes objectForKey:countryCode]]];
  }
  else {
    [self.toCurrencyLabel setText:[NSString stringWithFormat:NSLocalizedString(@"TO_CURRENCY", nil), countryCode, [self.currencyTypes objectForKey:countryCode]]];
  }
}

#pragma mark - Private Helper Methods

- (void)dismissKeyboard
{
  [self.view endEditing:YES];
}

@end
