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
#import <math.h>

@interface KCHomeViewController ()

@property (strong, nonatomic) NSDictionary *currencyTypes;
@property (strong, nonatomic) NSDictionary *latestCurrencyRates;
@property (strong, nonatomic) NSString *fromCurrencyCode;
@property (strong, nonatomic) NSString *toCurrencyCode;

- (void)dismissKeyboard;
- (void)convertCurrencyWithBaseFrom;
- (void)toCurrencyTextFieldChanged:(id)sender;

@end

@implementation KCHomeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Default to USD and CAD
  self.fromCurrencyCode = @"USD";
  self.toCurrencyCode = @"EUR";
  
  // Add a tap gesture recognizer to recognize clicks outside the keyboard and hide it appropriately
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  // Setup observers to monitor when textfields are changed
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(convertCurrencyWithBaseFrom)
                                               name:UITextFieldTextDidChangeNotification
                                             object:self.fromCurrencyTextField];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(toCurrencyTextFieldChanged:)
                                               name:UITextFieldTextDidChangeNotification
                                             object:self.toCurrencyTextField];

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
//  NSString *disclaimer = [jsonDict valueForKeyPath:@"disclaimer"];
//  NSString *license = [jsonDict valueForKeyPath:@"license"];
  NSString *timestamp = [jsonDict valueForKeyPath:@"timestamp"];
  NSString *base = [jsonDict valueForKeyPath:@"base"];
  self.latestCurrencyRates = [jsonDict objectForKey:@"rates"];
  
//  NSLog(@"Disclaimer: %@", disclaimer);
//  NSLog(@"License: %@", license);
  NSLog(@"Timestamp: %@", timestamp);
  NSLog(@"Base: %@", base);
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  NSLog(@"from: %@", self.fromCurrencyCode);
  NSLog(@"to: %@", self.toCurrencyCode);
  
  // Only permit a single decimal point in the text field
  if ([string isEqualToString:@"."] &&[textField.text rangeOfString:@"."].location != NSNotFound) {
    return NO;
  }
  return YES;
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
  if (isFromCurrency) {
    self.fromCurrencyCode = countryCode;
    [self.fromCurrencyLabel setText:[NSString stringWithFormat:NSLocalizedString(@"FROM_CURRENCY", nil), countryCode, [self.currencyTypes objectForKey:countryCode]]];
    [self convertCurrencyWithBaseFrom];
  }
  else {
    self.toCurrencyCode = countryCode;
    [self.toCurrencyLabel setText:[NSString stringWithFormat:NSLocalizedString(@"TO_CURRENCY", nil), countryCode, [self.currencyTypes objectForKey:countryCode]]];
    [self convertCurrencyWithBaseFrom];
  }
}

#pragma mark - Private Helper Methods

- (void)dismissKeyboard
{
  [self.view endEditing:YES];
}

- (void)convertCurrencyWithBaseFrom
{
  NSDecimalNumber *fromRate = [self.latestCurrencyRates valueForKeyPath:self.fromCurrencyCode];
  NSDecimalNumber *toRate = [self.latestCurrencyRates valueForKeyPath:self.toCurrencyCode];
  NSDecimalNumber *fromValue = [NSDecimalNumber decimalNumberWithString:self.fromCurrencyTextField.text];
  
  NSLog(@"about to %@ * %@", toRate, fromValue);
  float result = [toRate floatValue] * [fromValue floatValue] / [fromRate floatValue];
  
  if (isnan(result)) {
    [self.toCurrencyTextField setText:[NSString stringWithFormat:@""]];
  }
  else {
    [self.toCurrencyTextField setText:[NSString stringWithFormat:@"%.02f", result]];
  }
}

- (void)toCurrencyTextFieldChanged:(id)sender
{
  
}

@end
