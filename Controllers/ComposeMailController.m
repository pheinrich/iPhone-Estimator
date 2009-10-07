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


#import "ComposeMailController.h"


@implementation ComposeMailController


-(IBAction)showPicker:(id)sender
{
   Class mailClass = NSClassFromString( @"MFMailComposeViewController" );

	if( mailClass )
	{
		if( [mailClass canSendMail] )
			[self displayComposerSheet];
		else
			[self launchMailAppOnDevice];
	}
	else
		[self launchMailAppOnDevice];
}


-(void)displayComposerSheet
{
	MFMailComposeViewController* picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"Zetamari Estimate"];
   
	// Set up recipients
	NSArray* toRecipients = [NSArray arrayWithObject:@"peter.heinrich@gmail.com"]; 
	NSArray* bccRecipients = [NSArray arrayWithObject:@"angie@zetamari.com"]; 
	
	[picker setToRecipients:toRecipients];
	[picker setBccRecipients:bccRecipients];
	
	// Attach an image to the email
	NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
   NSData *myData = [NSData dataWithContentsOfFile:path];
	[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
	
	// Fill out the email body text
	NSString* emailBody = @"Estimate";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
   [picker release];
}


-(void)launchMailAppOnDevice
{
	NSString* recipients = @"mailto:peter.heinrich@gmail.com?subject=Zetamari Estimate&bcc=angie@zetamari.com";
	NSString* body = @"&body=Test text";
	
	NSString* email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


@end
