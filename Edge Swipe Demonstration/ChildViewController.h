//
//  ChildViewController.h
//  deleteme4
//
//  Created by Robert Ryan on 6/13/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildViewController : UIViewController

- (IBAction)touchUpInsidePreviousButton:(id)sender;

- (IBAction)touchUpInsideNextButton:(id)sender;

@property (nonatomic) NSInteger childNumber;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
