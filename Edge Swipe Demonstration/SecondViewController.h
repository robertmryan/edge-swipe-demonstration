//
//  SecondViewController.h
//  Edge Swipe Demonstration
//
//  Created by Robert Ryan on 7/9/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)touchUpInsideFirstButton:(id)sender;

@end
