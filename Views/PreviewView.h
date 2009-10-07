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


@class CalculatorController;

@interface PreviewView : UIView
{
   IBOutlet CalculatorController* controller;
   IBOutlet UIImageView* shapeView;
   IBOutlet UIImageView* reflectionView;
   CGImageRef maskImage;
}

- (void)render:(SEL)selector;
- (void)draw:(CGContextRef)context inside:(CGMutablePathRef)inside outside:(CGMutablePathRef)outside;
- (void)drawForMail:(ContextRef)context inside:(CGMutablePathRef)inside outside:(CGMutablePathRef)outside
- (CGSize)scaleToWindow:(CGContextRef)context width:(double)width height:(double)height;

- (void)circleDraw:(CGContextRef)context;
- (void)ellipseDraw:(CGContextRef)context;
- (void)squareDraw:(CGContextRef)context;
- (void)rectangleDraw:(CGContextRef)context;
- (void)cathedralDraw:(CGContextRef)context;
- (void)baseCathedralDraw:(CGContextRef)context;
- (void)vesicaDraw:(CGContextRef)context;


@end
