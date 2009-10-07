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


@interface SettingsController : UITableViewController
{
   IBOutlet id priceCell;
   IBOutlet id estimateGlassCell;
   IBOutlet id showPriceCell;
   IBOutlet id showKeyCell;

   IBOutlet UITextField* price;
   IBOutlet UISwitch* estimateGlass;
   IBOutlet UISwitch* showPrice;
   IBOutlet UISwitch* showKey;
}

@property (nonatomic, retain) IBOutlet UITextField* price;
@property (nonatomic, retain) IBOutlet UISwitch* estimateGlass;
@property (nonatomic, retain) IBOutlet UISwitch* showPrice;
@property (nonatomic, retain) IBOutlet UISwitch* showKey;

- (void)loadSettings;
- (IBAction)saveSettings:(id)sender;

@end
