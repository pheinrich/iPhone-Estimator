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


#import "EstimateController.h"


@implementation EstimateController

@synthesize calculatorController;
@synthesize calculatorInfos;


- (void)loadView
{
   [super loadView];

   self.title = @"Shapes";
   self.navigationController.title = @"Estimate";

   calculatorController.hidesBottomBarWhenPushed = YES;
}


- (void)viewDidLoad
{
   [super viewDidLoad];
 
   //  Load property list describing shape types and their associated characteristics.
   NSString* path = [[NSBundle mainBundle] pathForResource:@"Calculators" ofType:@"plist"];
   self.calculatorInfos = [NSArray arrayWithContentsOfFile:path];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
   //  Just one section.
   return( 1 );
}


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
   return( [calculatorInfos count] );
}


/*
- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
   return( @"Shapes" );
}
*/


- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
   static NSString* CellIdentifier = @"CalculatorCell";
   UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   NSDictionary* info = [calculatorInfos objectAtIndex:indexPath.row];
   
   if( nil == cell )
      cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
   
   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   cell.text = NSLocalizedString( [info objectForKey:@"name"], @"Shape handled by calculator" );
   
   return( cell );
}


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
   calculatorController.info = [calculatorInfos objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:calculatorController animated:YES];
}


@end
