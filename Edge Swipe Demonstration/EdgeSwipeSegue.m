//
//  EdgeSwipeSegue.m
//  Edge Swipe Demonstration
//
//  Created by Robert Ryan on 7/9/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import "EdgeSwipeSegue.h"
#import "ParentControllerDelegate.h"

@implementation EdgeSwipeSegue

- (void)perform
{
    UIViewController *source = self.sourceViewController;
    id <ParentControllerDelegate>parent = (id)source.parentViewController;
    NSAssert([parent conformsToProtocol:@protocol(ParentControllerDelegate)], @"Parent does not conform to ParentControllerDelegate; parent = %@", parent);
    
    [parent pushChildViewController:self.destinationViewController];
}

@end
