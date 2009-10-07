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


#import "QuartzCore/QuartzCore.h"
#import "CalculatorController.h"
#import "PreviewView.h"


@interface PreviewView ()
//- (UIImage*)reflectionImage:(CGContextRef)context;
- (UIImage*)reflectionImage;
- (CGImageRef)gradientMaskImage:(int)height;
@end


@implementation PreviewView


- (void)render:(SEL)selector
{
   UIGraphicsBeginImageContext( shapeView.bounds.size );
   CGContextRef context = UIGraphicsGetCurrentContext();

   //  Render the preview image in the background.
   [self performSelector:selector withObject:(id)context];
   shapeView.image = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();

   UIImage* image = [self reflectionImage];
   reflectionView.image = image;
   [image retain];
}


- (void)draw:(CGContextRef)context inside:(CGMutablePathRef)inside outside:(CGMutablePathRef)outside
{
   CGRect bounds = CGPathGetBoundingBox( outside );
   CGSize size = [self scaleToWindow:context width:bounds.size.width height:bounds.size.height];

   CGContextSetRGBStrokeColor( context, 1.0, 1.0, 1.0, 1.0 );
   CGContextSetRGBFillColor( context, 0.0, 0.0, 1.0, 1.0 );
   
   CGContextSetLineWidth( context, size.height );
   CGContextAddPath( context, outside );
   CGContextStrokePath( context );
   CGPathRelease( outside );

   CGContextSetLineWidth( context, size.width );
   CGContextAddPath( context, inside );
   CGContextStrokePath( context );
   CGPathRelease( inside );
}


- (void)drawForMail:(ContextRef)context inside:(CGMutablePathRef)inside outside:(CGMutablePathRef)outside
{
   CGRect bounds = CGPathGetBoundingBox( outside );
   CGSize size = [self scaleToWindow:context width:bounds.size.width height:bounds.size.height];
   
   CGContextSetRGBStrokeColor( context, 0.0, 0.0, 0.0, 1.0 );
   CGContextSetRGBFillColor( context, 0.0, 0.0, 1.0, 1.0 );
   
   CGContextSetLineWidth( context, size.height );
   CGContextAddPath( context, outside );
   CGContextStrokePath( context );
   CGPathRelease( outside );
   
   CGContextSetLineWidth( context, size.width );
   CGContextAddPath( context, inside );
   CGContextStrokePath( context );
   CGPathRelease( inside );
}


- (CGSize)scaleToWindow:(CGContextRef)context width:(double)width height:(double)height
{
   CGSize size = shapeView.bounds.size;
   CGSize pen = CGSizeMake( 2.0, 3.0 );
   double scale = MIN( (size.width - pen.width) / width, (size.height - pen.height) / height );

   CGContextTranslateCTM( context, size.width / 2, size.height / 2 );
   CGContextScaleCTM( context, scale, scale );

   return( CGContextConvertSizeToUserSpace( context, pen ) );
}


//- (UIImage*)reflectionImage:(CGContextRef)context
- (UIImage*)reflectionImage
{
	CGContextRef mainViewContentContext;
   CGColorSpaceRef colorSpace;
	
   colorSpace = CGColorSpaceCreateDeviceRGB();
	
	// create a bitmap graphics context the size of the image
   mainViewContentContext = CGBitmapContextCreate (NULL, reflectionView.bounds.size.width,
                                                   reflectionView.bounds.size.height, 8,0,
                                                   colorSpace, kCGImageAlphaPremultipliedLast);
	
	// free the rgb colorspace
   CGColorSpaceRelease(colorSpace);	
	
	if (mainViewContentContext==NULL)
		return NULL;
	
	// offset the context. This is necessary because, by default, the  layer created by a view for
	// caching its content is flipped. But when you actually access the layer content and have
	// it rendered it is inverted. Since we're only creating a context the size of our 
	// reflection view (a fraction of the size of the main view) we have to translate the context the
	// delta in size, render it, and then translate back (we could have saved/restored the graphics 
	// state
	
	CGFloat translateVertical = shapeView.bounds.size.height - reflectionView.bounds.size.height;
	CGContextTranslateCTM( mainViewContentContext, 0, -translateVertical );
	
	// render the layer into the bitmap context
	[shapeView.layer renderInContext:mainViewContentContext];

	// translate the context back
	CGContextTranslateCTM( mainViewContentContext, 0, translateVertical );
	
	// Create CGImageRef of the main view bitmap content, and then
	// release that bitmap context
	CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage( mainViewContentContext );
	CGContextRelease( mainViewContentContext );

	// create a 2 bit CGImage containing a gradient that will be used for masking the 
	// main view content to create the 'fade' of the reflection.  The CGImageCreateWithMask
	// function will stretch the bitmap image as required, so we can create a 1 pixel wide
	// gradient
	CGImageRef mask = [self gradientMaskImage:reflectionView.bounds.size.height];
	
	// Create an image by masking the bitmap of the mainView content with the gradient view
	// then release the  pre-masked content bitmap and the gradient bitmap
	CGImageRef reflectionImage = CGImageCreateWithMask( mainViewContentBitmapContext, mask );
	CGImageRelease( mainViewContentBitmapContext );
	CGImageRelease( mask );

	// convert the finished reflection image to a UIImage 
	UIImage* theImage = [UIImage imageWithCGImage:reflectionImage];
	
	// image is retained by the property setting above, so we can 
	// release the original
	CGImageRelease( reflectionImage );
	
	// return the image
	return( theImage );
}


- (CGImageRef)gradientMaskImage:(int)height
{
   if( nil == maskImage )
   {
      CGImageRef theCGImage = NULL;
      CGContextRef gradientBitmapContext = NULL;
      CGColorSpaceRef colorSpace;
      CGGradientRef grayScaleGradient;
      CGPoint gradientStartPoint, gradientEndPoint;
	
      // Our gradient is always black-white and the mask
      // must be in the gray colorspace
      colorSpace = CGColorSpaceCreateDeviceGray();
	
      // create the bitmap context
      gradientBitmapContext = CGBitmapContextCreate( NULL, 1, height, 8, 0, colorSpace, kCGImageAlphaNone );
	
      if( gradientBitmapContext )
      {
         // define the start and end grayscale values (with the alpha, even though
         // our bitmap context doesn't support alpha the gradient requires it)
         CGFloat colors[] = { 0.0, 1.0, 1.0, 1.0, };
		
         // create the CGGradient and then release the gray color space
         grayScaleGradient = CGGradientCreateWithColorComponents( colorSpace, colors, NULL, 2 );
		
         // create the start and end points for the gradient vector (straight down)
         gradientStartPoint = CGPointZero;
         gradientEndPoint = CGPointMake( 0, height );
		
         // draw the gradient into the gray bitmap context
         CGContextDrawLinearGradient( gradientBitmapContext, grayScaleGradient, gradientStartPoint, gradientEndPoint, kCGGradientDrawsAfterEndLocation );
		
         // clean up the gradient
         CGGradientRelease( grayScaleGradient );
		
         // convert the context into a CGImageRef and release the context
         theCGImage = CGBitmapContextCreateImage( gradientBitmapContext );
         CGContextRelease( gradientBitmapContext );
      }

      // clean up the colorspace
      CGColorSpaceRelease( colorSpace );
      maskImage = theCGImage;
   }

   return( maskImage );
}


#pragma mark Shape rendering methods

- (void)circleDraw:(CGContextRef)context
{
   double outsideDiameter = [controller getField:0];
   double insideDiameter = [controller getField:1];
   double border = (outsideDiameter - insideDiameter) / 2;

   CGAffineTransform xform = CGAffineTransformMakeTranslation( -outsideDiameter / 2.0, -outsideDiameter / 2.0 );
   CGMutablePathRef inside = CGPathCreateMutable();
   CGMutablePathRef outside = CGPathCreateMutable();

   CGPathAddEllipseInRect( inside, &xform, CGRectMake( border, border, insideDiameter, insideDiameter ) );
   CGPathAddEllipseInRect( outside, &xform, CGRectMake( 0.0, 0.0, outsideDiameter, outsideDiameter ) );
   [self draw:context inside:inside outside:outside];
}


- (void)ellipseDraw:(CGContextRef)context
{
   double outsideWidth = [controller getField:0];
   double insideWidth = [controller getField:2];
   double borderWidth = (outsideWidth - insideWidth) / 2;

   double outsideHeight = [controller getField:1];
   double insideHeight = [controller getField:3];
   double borderHeight = (outsideHeight - insideHeight) / 2;

   CGAffineTransform xform = CGAffineTransformMakeTranslation( -outsideWidth / 2.0, -outsideHeight / 2.0 );
   CGMutablePathRef inside = CGPathCreateMutable();
   CGMutablePathRef outside = CGPathCreateMutable();

   CGPathAddEllipseInRect( inside, &xform, CGRectMake( borderWidth, borderHeight, insideWidth, insideHeight ) );
   CGPathAddEllipseInRect( outside, &xform, CGRectMake( 0.0, 0.0, outsideWidth, outsideHeight ) );
   [self draw:context inside:inside outside:outside];
}


- (void)squareDraw:(CGContextRef)context
{
   double width = [controller getField:0];
   double border = [controller getField:1];

   CGAffineTransform xform = CGAffineTransformMakeTranslation( -width / 2.0, -width / 2.0 );
   CGMutablePathRef inside = CGPathCreateMutable();
   CGMutablePathRef outside = CGPathCreateMutable();

   CGPathAddRect( inside, &xform, CGRectMake( border, border, width - 2*border, width - 2*border ) );
   CGPathAddRect( outside, &xform, CGRectMake( 0.0, 0.0, width, width ) );
   [self draw:context inside:inside outside:outside];
}


- (void)rectangleDraw:(CGContextRef)context
{
   double width = [controller getField:0];
   double height = [controller getField:1];
   double border = [controller getField:2];
   
   CGAffineTransform xform = CGAffineTransformMakeTranslation( -width / 2.0, -height / 2.0 );
   CGMutablePathRef inside = CGPathCreateMutable();
   CGMutablePathRef outside = CGPathCreateMutable();

   CGPathAddRect( inside, &xform, CGRectMake( border, border, width - 2*border, height - 2*border ) );
   CGPathAddRect( outside, &xform, CGRectMake( 0.0, 0.0, width, height ) );
   [self draw:context inside:inside outside:outside];
}


- (void)cathedralDraw:(CGContextRef)context
{
   double width = [controller getField:0];
   double height = [controller getField:1];
   double border = [controller getField:2];

   CGAffineTransform xform = CGAffineTransformMakeTranslation( -width / 2.0, -height / 2.0 );
   CGMutablePathRef inside = CGPathCreateMutable();
   CGMutablePathRef outside = CGPathCreateMutable();
   double radius = width / 2;

   CGPathAddArc( inside, &xform, radius, radius, radius - border, M_PI, 0.0, FALSE );
   CGPathAddLineToPoint( inside, &xform, width - border, height - border );
   CGPathAddLineToPoint( inside, &xform, border, height - border );
   CGPathCloseSubpath( inside );

   CGPathAddArc( outside, &xform, radius, radius, radius, M_PI, 0.0, FALSE );
   CGPathAddLineToPoint( outside, &xform, width, height );
   CGPathAddLineToPoint( outside, &xform, 0.0, height );
   CGPathCloseSubpath( outside );
   
   [self draw:context inside:inside outside:outside];
}


- (void)baseCathedralDraw:(CGContextRef)context
{
   double width = [controller getField:0];
   double height = [controller getField:1];
   double border = [controller getField:2];
   double base = [controller getField:3];
   
   CGAffineTransform xform = CGAffineTransformMakeTranslation( -width / 2.0, -height / 2.0 );
   CGMutablePathRef inside = CGPathCreateMutable();
   CGMutablePathRef outside = CGPathCreateMutable();
   double radius = width / 2;
   
   CGPathAddArc( inside, &xform, radius, radius, radius - border, M_PI, 0.0, FALSE );
   CGPathAddLineToPoint( inside, &xform, width - border, height - base );
   CGPathAddLineToPoint( inside, &xform, border, height - base );
   CGPathCloseSubpath( inside );
   
   CGPathAddArc( outside, &xform, radius, radius, radius, M_PI, 0.0, FALSE );
   CGPathAddLineToPoint( outside, &xform, width, height );
   CGPathAddLineToPoint( outside, &xform, 0.0, height );
   CGPathCloseSubpath( outside );
   
   [self draw:context inside:inside outside:outside];
}


- (void)vesicaDraw:(CGContextRef)context
{
   double width = [controller getField:0];
   double height = [controller getField:1];
   double border = [controller getField:2];

   CGAffineTransform xform = CGAffineTransformMakeTranslation( -width / 2.0, -height / 2.0 );
   CGMutablePathRef inside = CGPathCreateMutable();
   CGMutablePathRef outside = CGPathCreateMutable();
   double adjust = asin( 0.5 * width / (width - border) ) - M_PI/6;

   CGPathAddArc( inside, &xform, width, height / 2, width - border, 2.0*M_PI/3.0 + adjust, 4.0*M_PI/3.0 - adjust, FALSE );
   CGPathAddArc( inside, &xform, 0.0, height / 2, width - border, 5.0*M_PI/3.0 + adjust, M_PI/3.0 - adjust, FALSE );

   CGPathAddArc( outside, &xform, width, height / 2, width, 2.0*M_PI/3.0, 4.0*M_PI/3.0, FALSE );
   CGPathAddArc( outside, &xform, 0.0, height / 2, width, 5.0*M_PI/3.0, M_PI/3.0, FALSE );

   [self draw:context inside:inside outside:outside];
}


@end
