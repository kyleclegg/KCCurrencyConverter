//
//  KCCurrencySelectViewController.m
//  KCCurrencyConverter
//
//  Created by Kyle Clegg on 4/5/13.
//  Copyright (c) 2013 Kyle Clegg. All rights reserved.
//

#import "KCCurrencySelectViewController.h"

@interface KCCurrencySelectViewController ()

@property (strong, nonatomic) NSArray *currencyCodes;
@property (strong, nonatomic) NSArray *currencyNames;

@end

@implementation KCCurrencySelectViewController

- (void)viewDidLoad
{
  if (self.isFromCurrencyType) {
    NSLog(@"FROM");
  }
  else {
    NSLog(@"TO");
  }
  NSLog(@"%i", self.currencyTypes.count);

  // Store currency codes and names in private arrays for use within the controller
  NSMutableArray *mutableKeys = [[NSMutableArray alloc] init];
  NSMutableArray *mutableValues = [[NSMutableArray alloc] init];
  
  for (NSString *key in [[self.currencyTypes allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)]) {
    [mutableKeys addObject:key];
    [mutableValues addObject:[self.currencyTypes objectForKey:key]];
  }
  
  self.currencyCodes = mutableKeys.copy;
  self.currencyNames = mutableValues.copy;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  NSString *cellType = [tableView cellForRowAtIndexPath:indexPath].reuseIdentifier;
  NSLog(@"selected %@", cellType);
  
  // Tell parent which code was selected
  [self.delegate currencyCodeSelected:[self.currencyCodes objectAtIndex:indexPath.row] forFromCurrency:self.isFromCurrencyType];

  // Deselect row
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  // Pop view controller
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.currencyTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
	static NSString *CellIdentifier = @"CurrencyType";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    [self tableViewCellWithReuseIdentifier:CellIdentifier];
  }
  
  // Configure the cell
  [self configureCell:cell forIndexPath:indexPath];
  
	return cell;
}

- (UITableViewCell *)tableViewCellWithReuseIdentifier:(NSString *)identifier
{
	
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  
	return cell;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
  // Update the date
  UILabel *currencyLabel = (UILabel *)[cell viewWithTag:1];
  [currencyLabel setText:[NSString stringWithFormat:@"%@, %@", [self.currencyCodes objectAtIndex:indexPath.row], [self.currencyNames objectAtIndex:indexPath.row]]];
}

#pragma mark - TableView Single Letter Alphabet List

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  return[NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
  
  NSInteger newRow = [self indexForFirstChar:title inArray:self.currencyCodes];
  NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:0];
  [tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
  
  return index;
}

// Return the index for the location of the first item in an array that begins with a certain character
- (NSInteger)indexForFirstChar:(NSString *)character inArray:(NSArray *)array
{
  NSUInteger count = 0;
  for (NSString *str in array) {
    if ([str hasPrefix:character]) {
      return count;
    }
    count++;
  }
  return 0;
}

@end
