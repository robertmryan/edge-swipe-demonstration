//
//  ParentViewController.h
//  Edge Swipe Demonstration
//
//  Created by Robert Ryan on 7/9/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentControllerDelegate.h"

@interface ParentViewController : UIViewController <ParentControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
