// ---------------------------------------------------------------------------
//
//  Zetamari Estimator
//  Copyright (c) 2009  Peter Heinrich
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Boston, MA  02110-1301, USA.
//
// ---------------------------------------------------------------------------


#import "SettingsController.h"



@implementation SettingsController

@synthesize price;
@synthesize estimateGlass;
@synthesize showPrice;
@synthesize showKey;


- (void)viewDidLoad
{
   [super viewDidLoad];
   [self loadSettings];
}


- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
	if( textField == price )
		[price resignFirstResponder];
	
	return( YES );
}


- (void)loadSettings
{
   NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
   
   [price setText:[userDefaults stringForKey:@"price"]];
   [estimateGlass setOn:[userDefaults boolForKey:@"estimateGlass"]];
   [showPrice setOn:[userDefaults boolForKey:@"showPrice"]];
   [showKey setOn:[userDefaults boolForKey:@"showKey"]];
}


- (IBAction)saveSettings:(id)sender
{
   NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
   
   [userDefaults setObject:(NSString*)price.text forKey:@"price"];
   [userDefaults setBool:[estimateGlass isOn] forKey:@"estimateGlass"];
   [userDefaults setBool:[showPrice isOn] forKey:@"showPrice"];
   [userDefaults setBool:[showKey isOn] forKey:@"showKey"];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
   return( 2 );
}


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
   NSInteger rows = 0;
   
   switch( section )
   {
      case 0:
         rows = 2;
         break;
         
      case 1:
         rows = 2;
         break;
         
      default:
         break;
   }
   
   return( rows );
}


- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
   NSString* title = nil;
   
   switch( section )
   {
      case 0:
         title = @"Price";
         break;
         
      case 1:
         title = @"Display";
         break;
         
      default:
         break;
   }
   
	return( title );
}


- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
   UITableViewCell* cell = nil;
   
   switch( indexPath.section )
   {
      case 0:
         switch( indexPath.row )
         {
            case 0:
               cell = priceCell;
               break;

            case 1:
               cell = estimateGlassCell;
               break;

            default:
               break;
         }
         break;

      case 1:
         switch( indexPath.row )
         {
            case 0:
               cell = showPriceCell;
               break;

            case 1:
               cell = showKeyCell;
               break;

            default:
               break;
         }
         break;

      default:
         break;
   }

   return( cell );
}


/*
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
   // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController* anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}
*/


@end
