//
//  ParentViewController.h
//  Edge Swipe Demonstration
//
//  Created by Robert Ryan on 7/9/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentControllerDelegate.h"

/** Sample custom container controller. This is the "parent" controller in the custom container pattern.
 
 ##See Also
 
 - [Edge Swipe Demonstration GitHub Site](https://github.com/robertmryan/edge-swipe-demonstration)
 
 */

@interface ParentViewController : UIViewController <ParentControllerDelegate>

/*********************************************
 * @name Properties
 *********************************************/

/** Container view
 
 In iOS 6.0, this can be an `IBOutlet` for a "container view" (which includes an embedded first child view controller).
 If supporting iOS versions prior to 6.0, you could remove this embedded "container view" from the storyboard and replace
 it with a standard `UIView`, but you'd then have to alter `viewDidLoad` for this view controller to manually load the
 first child controller. (There is sample code for that in the `viewDidLoad` method.)
 */

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
