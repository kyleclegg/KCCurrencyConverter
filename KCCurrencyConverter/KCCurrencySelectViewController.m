//
//  KCCurrencySelectViewController.m
//  KCCurrencyConverter
//
//  Created by Kyle Clegg on 4/5/13.
//  Copyright (c) 2013 Kyle Clegg. All rights reserved.
//

#import "KCCurrencySelectViewController.h"

@interface KCCurrencySelectViewController ()

@end

@implementation KCCurrencySelectViewController

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  NSString *cellType = [tableView cellForRowAtIndexPath:indexPath].reuseIdentifier;
  NSLog(@"selected %@", cellType);
  
  // Must do this last so that prepareForSegue:sender: can access indexPath
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 3;
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
  [currencyLabel setText:[NSString stringWithFormat:@"hey %i", indexPath.row]];
  
//  
//  // Round the corners on the white background
//  UIView *whiteBackground = (UIView *)[cell viewWithTag:6];
//  whiteBackground.layer.cornerRadius = 5.0;
//  whiteBackground.layer.masksToBounds = YES;
//  
//  // Set the timeline marker
//  UIImageView *timelineMarker = (UIImageView *)[cell viewWithTag:7];
//  UIImage *timelineDot = [UIImage imageNamed:@"timeline_dot.png"];
//  UIImage *timelineDotTop = [UIImage imageNamed:@"timeline_dot_top.png"];
//  UIImage *timelineDotBottom = [UIImage imageNamed:@"timeline_dot_bottom.png"];
//  UIImage *timelineDotMiddle = [UIImage imageNamed:@"timeline_dot_middle.png"];
//  
//  if (self.entriesFromServer.count == 1) {
//    timelineMarker.image = timelineDot;
//  }
//  else if (indexPath.row == 0) {
//    timelineMarker.image = timelineDotTop;
//  }
//  else if (self.entriesFromServer.count == indexPath.row + 1) {
//    timelineMarker.image = timelineDotBottom;
//  }
//  else {
//    timelineMarker.image = timelineDotMiddle;
//  }
}

@end
