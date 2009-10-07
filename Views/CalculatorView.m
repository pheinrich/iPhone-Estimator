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


#import "CalculatorView.h"



@implementation CalculatorView


- (void)dealloc
{
   [texts release];
   [labels release];
   [super dealloc];
}


- (void)message:(NSString*)text
{
   messageView.text = text;
   [valuesView reloadData];
}


- (void)setShape:(NSDictionary*)info clear:(BOOL)clear
{
   if( !labels )
   {
      labels = [NSArray arrayWithObjects:param1Label, param2Label, param3Label, param4Label, param5Label, nil];
      texts = [NSArray arrayWithObjects:param1Text, param2Text, param3Text, param4Text, param5Text, nil];

      [labels retain];
      [texts retain];
   }

   NSArray* parameters = [info objectForKey:@"parameters"];
   int count = [parameters count];

   //  Turn data controls and labels on or off, depending on shape.
   for( int i = 0; i < [labels count]; i++ )
   {
      [[labels objectAtIndex:i] setHidden:(i >= count)];
      [[texts objectAtIndex:i] setHidden:(i >= count)];
   }

   //  Set parameter labels to match key.
   for( int i = 0; i < count; i++ )
   {
      [[labels objectAtIndex:i] setText:[parameters objectAtIndex:i]];
      if( clear )
         [[texts objectAtIndex:i] setText:nil];
   }

   keyView.image = [UIImage imageNamed:[info objectForKey:@"figure"]];
   [self message:nil];
}


- (double)getParam:(int)index
{
   double result = 0.0;

   if( 0 <= index && [texts count] > index )
   {
      UITextField* text = [texts objectAtIndex:index];

      if( ![text isHidden] )
      result = [[text text] doubleValue];
   }

   return( result );
}


- (void)setParam:(int)index value:(double)value
{
   if( 0 <= index && [texts count] > index )
   {
      UITextField* text = [texts objectAtIndex:index];

      if( ![text isHidden] )
         text.text = [NSString stringWithFormat:@"%0.2f", value];
   }
}


@end
