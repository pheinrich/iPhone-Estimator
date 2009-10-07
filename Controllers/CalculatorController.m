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


#import "CalculatorController.h"
#import "CalculatorView.h"
#import "ComposeMailController.h"
#import "EstimatorAppDelegate.h"
#import "PreviewView.h"


@implementation CalculatorController

@synthesize containerView;
@synthesize segmentedControl;
@synthesize barButtonItem;
@synthesize calculatorView;
@synthesize previewView;
@synthesize info;


- (void)viewDidLoad
{
   [super viewDidLoad];
   segmentedControl.tintColor = [UIColor darkGrayColor];
}


- (void)viewWillAppear:(BOOL)animated
{
   segmentedControl.selectedSegmentIndex = 0;
   [calculatorView setShape:info clear:0.0 == area];

   [previewView removeFromSuperview];
   [containerView addSubview:calculatorView];
}


- (void)setInfo:(NSDictionary*)value
{
   if( info != value )
   {
      info = value;
      area = 0.0;
      glass = 0.0;
   }
}


#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
   if( 0 == buttonIndex )
   {
      EstimatorAppDelegate* app = (EstimatorAppDelegate*)[[UIApplication sharedApplication] delegate];
      ComposeMailController* controller = [app composeMailController];

      [controller showPicker:self];
   }
}


#pragma mark Table view methods

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
   return( 2 );
}


- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
   static NSString* CellIdentifier = @"CalculatorCell";
   UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
   if( nil == cell )
   {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
      cell.textLabel.text = (0 == indexPath.row) ? @"Total area (sq. ft.):" : @"Base cost:";
   }

   if( 0 < area )
   {
      if( 0 == indexPath.row )
         cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2f", area / 144.0];
      else
      {
         NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
         double cost = [[userDefaults stringForKey:@"price"] doubleValue];

         cell.detailTextLabel.text = [NSString stringWithFormat:@"$%0.2f", (area * cost) / 144.0];
      }
   }
   else
      cell.detailTextLabel.text = @"Unknown";

   return( cell );
}


- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
   [self doCalculate:self];
   [textField resignFirstResponder];
	
	return( YES );
}


#pragma mark Utility methods

- (IBAction)doAction:(id)sender
{
   /*
   NSURL *url = [[NSURL alloc] initWithString:@"mailto:k@yahoo.com?subject=This is my subject&body=this is the body"];
   [[UIApplication sharedApplication] openURL:url];
   */

   UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                                       cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:nil
                                                       otherButtonTitles:@"Email", @"Save", nil];

   actionSheet.actionSheetStyle = [calculatorView isDescendantOfView:containerView]
                                     ? UIActionSheetStyleDefault : UIActionSheetStyleBlackTranslucent;

   [actionSheet showInView:self.view];
   [actionSheet release];
}


- (IBAction)doCalculate:(id)sender
{
   NSString* selector = [info objectForKey:@"selector"];

   [self performSelector:NSSelectorFromString( [NSString stringWithFormat:@"%@Calc", selector] )];
   [previewView render:NSSelectorFromString( [NSString stringWithFormat:@"%@Draw:", selector] )];
}


- (IBAction)doEditPreview:(id)sender
{
   [self flipView];
}


- (void)flipView
{
   containerView.userInteractionEnabled = NO;
   segmentedControl.userInteractionEnabled = NO;
   barButtonItem.enabled = NO;
   
   [UIView beginAnimations:nil context:nil];
   [UIView setAnimationDuration:0.75];
   [UIView setAnimationDelegate:self];
   [UIView setAnimationDidStopSelector:@selector( flipDidStop:finished:context: )];
   
   if( [calculatorView isDescendantOfView:containerView] )
   {
      [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:containerView cache:YES];
      [calculatorView removeFromSuperview];
      [containerView addSubview:previewView];
   }
   else
   {
      [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:containerView cache:YES];
      [previewView removeFromSuperview];
      [containerView addSubview:calculatorView];
   }
   [UIView commitAnimations];
}


- (void)flipDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context
{
   barButtonItem.enabled = YES;
   segmentedControl.userInteractionEnabled = YES;
   containerView.userInteractionEnabled = YES;
}


- (double)getField:(int)index
{
   return( [calculatorView getParam:index] );
}



- (void)setField:(int)index value:(double)value
{
   [calculatorView setParam:index value:round( 100.0 * value) / 100.0];
}


- (void)estimateGlass:(double)width height:(double)height
{
   //  Account for 5/16" rabbet on all four edges.
   width += 0.625;
   height += 0.625;

   //  Minimum charge is 1 sq. ft.
   glass = (144.0 > area ? 144.0 : area) * 3.0 / 144.0;
   double x = MIN( width, height );
   double y = MAX( width, height );

   if( 24.0 >= x )
   {
      if( 48.0 < y )
         glass += 100.0;    //  custom cut
      else
         glass += 0.0;      //  fits on our standard 24" x 48" sheet
   }
   else if( 30.0 >= x )
   {
      if( 36.0 >= y )
         glass += 30.0;     //  fits on Home Depot's largest bath mirror
      else
         glass += 100.0;    //  custom cut
   }
   else
      glass += 100.0;       //  custom cut
}


# pragma mark Shape calculation methods

- (void)circleCalc
{
   double od = [self getField:0];
   double id = [self getField:1];
   double border = [self getField:2];

   NSString* error = nil;

   if( 0.0 < od && 0.0 < id )
   {
      if( od <= id )
         error = @"The outside diameter must be larger than the inside diameter";
      else
         [self setField:2 value:(od - id) / 2.0];
   }
   else if( 0.0 < od && 0.0 < border )
   {
      if( od / 2.0 <= border )
         error = @"The border is too large to produce a valid shape";
      else
      {
         id = od - 2.0*border;
         [self setField:1 value:id];
      }
   }
   else if( 0.0 < id && 0.0 < border )
   {
      od = id + 2.0*border;
      [self setField:0 value:od];
   }
   else
      error = @"Please enter at least two positive values";

   if( nil == error )
   {
      area = M_PI * ((od / 2.0) * (od / 2.0));
      glass = M_PI * ((id / 2.0) * (id / 2.0));

      area -= glass;
      [self estimateGlass:id height:id];
      [calculatorView message:nil];
   }
   else
      [calculatorView message:error];
}


- (void)ellipseCalc
{
   double ow = [self getField:0];
   double oh = [self getField:1];
   double iw = [self getField:2];
   double ih = [self getField:3];
   double border = [self getField:4];

   NSString* error = nil;

   if( 0.0 < ow && 0.0 < oh && 0.0 < iw && 0.0 < ih )
   {
      if( ow <= iw )
         error = @"The outside width must be larger than the inside width";
      else if( oh <= ih )
         error = @"The outside height must be larger than the inside height";
      else if( ow - iw == oh - ih )
      {
         //  Update the border parameter if it's uniform.
         [self setField:4 value:(ow - iw) / 2.0];
      }
   }
   else if( 0.0 < ow && 0.0 < oh && 0.0 < border )
   {
      if( ow / 2.0 <= border || oh / 2.0 <= border )
         error = @"The border is too large to produce a valid shape";
      else
      {
         iw = ow - 2.0*border;
         [self setField:2 value:iw];

         ih = oh - 2.0*border;
         [self setField:3 value:ih];
      }
   }
   else if( 0.0 < iw && 0.0 < ih && 0.0 < border )
   {
      ow = iw + 2.0*border;
      [self setField:0 value:ow];

      oh = ih + 2.0*border;
      [self setField:1 value:oh];
   }
   else
      error = @"Please enter inside/outside dims or dims + border";

   if( nil == error )
   {
      area = M_PI * (ow * oh) / 4.0;
      glass = M_PI * (iw * ih) / 4.0;

      area -= glass;
      [self estimateGlass:iw height:ih];
      [calculatorView message:nil];
   }
   else
      [calculatorView message:error];
}


- (void)squareCalc
{
   double width = [self getField:0];
   double border = [self getField:1];

   NSString* error = nil;

   if( 0.0 < width && 0.0 < border )
   {
      if( width / 2.0 <= border )
         error = @"The border is too large to produce a valid shape";
   }
   else
      error = @"Please enter both width and border";

   if( nil == error )
   {
      double side = width - 2.0*border;
      area = width * width;
      glass = side * side;

      area -= glass;
      [self estimateGlass:side height:side];
      [calculatorView message:nil];
   }
   else
      [calculatorView message:error];
}


- (void)rectangleCalc
{
   double width = [self getField:0];
   double height = [self getField:1];
   double border = [self getField:2];

   NSString* error = nil;

   if( 0.0 < width && 0.0 < height && 0.0 < border )
   {
      if( width / 2.0 <= border || height / 2.0 <= border )
         error = @"The border is too large to produce a valid shape";
   }
   else
      error = @"Please enter width, height, and border";

   if( nil == error )
   {
      area = width * height;
      glass = (width - 2.0*border) * (height - 2.0*border);

      area -= glass;
      [self estimateGlass:width - 2.0*border height:height - 2.0*border];
      [calculatorView message:nil];
   }
   else
      [calculatorView message:error];
}


- (void)cathedralCalc
{
   double width = [self getField:0];
   double height = [self getField:1];
   double border = [self getField:2];

   NSString* error = nil;

   if( 0.0 < width && 0.0 < height && 0.0 < border )
   {
      if( width / 2.0 <= border || height / 2.0 <= border )
         error = @"The border is too large to produce a valid shape";
      else if( height <= (width / 2.0 + border) )
         error = @"The shape requested is too short to be valid";
   }
   else
      error = @"Please enter width, height, and border";

   if( nil == error )
   {
      double w = width - 2.0*border;
      double h = height - 2.0*border;

      area = (width * width) * (height / width + M_PI / 8.0 - 0.5);
      glass = (w * w) * (h / w + M_PI / 8.0 - 0.5);

      area -= glass;
      [self estimateGlass:w height:h];
      [calculatorView message:nil];
   }
   else
      [calculatorView message:error];
}


- (void)baseCathedralCalc
{
   double width = [self getField:0];
   double height = [self getField:1];
   double border = [self getField:2];
   double base = [self getField:3];

   NSString* error = nil;

   if( 0.0 < width && 0.0 < height && 0.0 < border && 0.0 < base )
   {
      if( width / 2.0 <= border || height / 2.0 <= border )
         error = @"The border and/or base are too large for a valid shape";
      else if( height <= (width / 2.0 + base) )
         error = @"The shape requested is too short to be valid";
   }
   else
      error = @"Please enter width, height, border, and base";

   if( nil == error )
   {
      double w = width - 2.0*border;
      double h = height - border - base;

      area = (width * width) * (height / width + M_PI / 8.0 - 0.5);
      glass = (w * w) * (h / w + M_PI / 8.0 - 0.5);

      area -= glass;
      [self estimateGlass:w height:h];
      [calculatorView message:nil];
   }
   else
      [calculatorView message:error];
}


- (void)vesicaCalc
{
   double width = [self getField:0];
   double height = [self getField:1];
   double border = [self getField:2];

   NSString* error = nil;

   if( 0.0 < width && 0.0 < border )
   {
      height = width * sqrt( 3.0 );
      [self setField:1 value:height];
   }
   else if( 0.0 < height && 0.0 < border )
   {
      width = height / sqrt( 3.0 );
      [self setField:0 value:width];
   }
   else
      error = @"Please enter a border and width or height";

   if( nil == error && width / 2.0 <= border )
      error = @"The border is too large to produce a valid shape";

   if( nil == error )
   {
      double constant = (4.0 * M_PI - 3.0 * sqrt( 3.0 )) / 6.0;
      double w = width - 2.0*border;

      area = (width * width) * constant;
      glass = (w * w) * constant;

      area -= glass;
      [self estimateGlass:w height:constant];
      [calculatorView message:nil];
   }
   else
      [calculatorView message:error];
}


@end
