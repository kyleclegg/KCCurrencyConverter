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

- (NSInteger)indexForFirstChar:(NSString *)character inArray:(NSArray *)array;
- (NSInteger)indexForCurrencyCode:(NSString *)currencyCode;

@end

@implementation KCCurrencySelectViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
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

// This code will be executed after the tableview is completely loaded, but before the view appears
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // Scroll to selected currency code by default
  if (self.selectedCurrencyCode != nil) {
    NSInteger newRow = [self indexForCurrencyCode:self.selectedCurrencyCode];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:0];
    [self.tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
  }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

  // Dynamically create an array of titles using the first letter of our row items. 
  // This will allow us to support however many rows we may have, as well as any missing rows.
  NSMutableArray *titles = [[NSMutableArray alloc] init];
  for (NSString *code in self.currencyCodes) {
    NSString *firstLetter = [code substringToIndex:1];
    if (![titles containsObject:firstLetter]) {
      [titles addObject:firstLetter];
    }
  }
  return titles.copy;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
  
  // Because our tableview is populated with a flat NSArray of strings, our table contains only a single section.
  // In an effort to preserve the advantages afforded us by the simplicity of having a single section, rather than create 
  // a section in our tableview for each letter of the alphabet solely for the purpose of the fast alphabetic scroll feature, 
  // we will inspect the current section index title (A, B, or C, etc.) and scroll to the row at that position.
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

- (NSInteger)indexForCurrencyCode:(NSString *)currencyCode
{
  NSInteger index = -1;
  NSInteger count = 0;
  for (NSString *code in self.currencyCodes) {
    if ([code isEqualToString:currencyCode]) {
      return count;
    }
    count ++;
  }
  return index;
}

@end
