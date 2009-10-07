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


@interface CalculatorView : UIView
{
   IBOutlet UILabel* param1Label;
   IBOutlet UITextField* param1Text;
   IBOutlet UILabel* param2Label;
   IBOutlet UITextField* param2Text;
   IBOutlet UILabel* param3Label;
   IBOutlet UITextField* param3Text;
   IBOutlet UILabel* param4Label;
   IBOutlet UITextField* param4Text;
   IBOutlet UILabel* param5Label;
   IBOutlet UITextField* param5Text;

   IBOutlet UIImageView* keyView;
   IBOutlet UITextView* messageView;
   IBOutlet UITableView* valuesView;

   NSArray* labels;
   NSArray* texts;
}

- (void)message:(NSString*)text;
- (void)setShape:(NSDictionary*)info clear:(BOOL)clear;

- (double)getParam:(int)index;
- (void)setParam:(int)index value:(double)value;


@end
