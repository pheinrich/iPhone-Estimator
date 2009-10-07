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


#import <UIKit/UIKit.h>


@class CalculatorView;
@class PreviewView;

@interface CalculatorController : UIViewController <UIActionSheetDelegate, UITableViewDataSource, UITextFieldDelegate>
{
   IBOutlet UIView* containerView;
   IBOutlet UISegmentedControl* segmentedControl;
   IBOutlet UIBarButtonItem* barButtonItem;

   IBOutlet CalculatorView* calculatorView;
   IBOutlet PreviewView* previewView;

   NSDictionary* info;
   double area;
   double glass;
}

@property (nonatomic, retain, readonly) IBOutlet UIView* containerView;
@property (nonatomic, retain, readonly) IBOutlet UISegmentedControl* segmentedControl;
@property (nonatomic, retain, readonly) IBOutlet UIBarButtonItem* barButtonItem;
@property (nonatomic, retain, readonly) IBOutlet CalculatorView* calculatorView;
@property (nonatomic, retain, readonly) IBOutlet PreviewView* previewView;
@property (nonatomic, retain) NSDictionary* info;

- (IBAction)doAction:(id)sender;
- (IBAction)doCalculate:(id)sender;
- (IBAction)doEditPreview:(id)sender;

- (void)flipView;
- (void)flipDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context;

- (double)getField:(int)index;
- (void)setField:(int)index value:(double)value;
- (void)estimateGlass:(double)width height:(double)height;

- (void)circleCalc;
- (void)ellipseCalc;
- (void)squareCalc;
- (void)rectangleCalc;
- (void)cathedralCalc;
- (void)baseCathedralCalc;
- (void)vesicaCalc;


@end
