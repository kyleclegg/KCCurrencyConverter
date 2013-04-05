//
//  KCViewController.m
//  KCCurrencyConverter
//
//  Created by Kyle Clegg on 4/3/13.
//  Copyright (c) 2013 Kyle Clegg. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "KCViewController.h"
#import "KCHelpers.h"


@interface KCViewController ()

@end

@implementation KCViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  
  // Prepare HTTP request to get latest conversion rates
  NSString *latestRatesURLString = [NSString stringWithFormat:@"%@%@?app_id=%@", kBaseURL, kLatestRates, kOpenExchangeRatesAppID];
  NSLog(@"url is %@", latestRatesURLString);
  
  NSURL *latestRatesURL = [NSURL URLWithString:latestRatesURLString];
  
  dispatch_async(kBgQueue, ^{
    NSData* data = [NSData dataWithContentsOfURL:
                    latestRatesURL];
    [self performSelectorOnMainThread:@selector(fetchedData:)
                           withObject:data waitUntilDone:YES];
  });

}

- (void)fetchedData:(NSData *)responseData {
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
    NSArray *rates = [jsonDict objectForKey:@"rates"];

    NSLog(@"Disclaimer: %@", disclaimer);
    NSLog(@"License: %@", license);
    NSLog(@"Timestamp: %@", timestamp);
    NSLog(@"Base: %@", base);
    NSLog(@"Rates: %@", rates);
  
}

@end
