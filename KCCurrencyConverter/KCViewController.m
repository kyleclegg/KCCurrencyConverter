//
//  KCViewController.m
//  KCCurrencyConverter
//
//  Created by Kyle Clegg on 4/3/13.
//  Copyright (c) 2013 Kyle Clegg. All rights reserved.
//

#import "KCViewController.h"
#import "KCHelpers.h"
#import "AFNetworking/AFJSONRequestOperation.h"
#import "AFNetworking/AFHTTPRequestOperation.h"
#import "AFNetworking/AFHTTPClient.h"

@interface KCViewController ()

@end

@implementation KCViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  
  // Perform HTTP Request
  NSString *latestRatesURLString = [NSString stringWithFormat:@"%@%@?app_id=%@", kBaseURL, kLatestRates, kOpenExchangeRatesAppID];
  NSURL *latestRatesURL = [NSURL URLWithString:latestRatesURLString];
  NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:latestRatesURL];
  
  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:jsonRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // The following code will only be executed upon successful HTTP communication
    NSString *disclaimer = [JSON valueForKeyPath:@"disclaimer"];
    NSString *license = [JSON valueForKeyPath:@"license"];
    NSString *timestamp = [JSON valueForKeyPath:@"timestamp"];
    NSString *base = [JSON valueForKeyPath:@"base"];

    
    NSLog(@"Disclaimer: %@", disclaimer);
    NSLog(@"License: %@", license);
    NSLog(@"Timestamp: %@", timestamp);
    NSLog(@"Base: %@", base);
    
  } failure:^(NSURLRequest *request , NSURLResponse *response, NSError *error, id JSON){
    NSLog(@"JSON retrieval failed: %@",[error localizedDescription]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  }];
  
  [operation start];
}

@end
