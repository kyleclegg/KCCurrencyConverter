//
//  KCViewController.m
//  KCCurrencyConverter
//
//  Created by Kyle Clegg on 4/3/13.
//  Copyright (c) 2013 Kyle Clegg. All rights reserved.
//

#define kBackgroundQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "KCViewController.h"
#import "KCHelpers.h"


@interface KCViewController ()

- (void)dismissKeyboard;

@end

@implementation KCViewController

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
  //parse out the json data
  NSError* error;
  NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:responseData //1
                            
                                                           options:kNilOptions
                                                             error:&error];
  
  NSLog(@"currency keys are %@", [jsonDict allKeys]);
  NSLog(@"currency values are %@", [jsonDict allValues]);
}

- (void)fetchedLatestRates:(NSData *)responseData
{
  //parse out the json data
  NSError* error;
  NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:responseData //1
                            
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
  NSLog(@"Rates: %@", rates);
  
  NSDecimalNumber *AEDRate = [rates valueForKeyPath:@"AED"];
  NSLog(@"their rate is %@", AEDRate);
  
  NSLog(@"rate keys are 3%@", [rates allKeys]);
  NSLog(@"rate values are 3%@", [rates allValues]);
}

#pragma mark - Private Helper Methods

- (void)dismissKeyboard
{
  [self.view endEditing:YES];
}

@end
