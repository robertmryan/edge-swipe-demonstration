//
//  ChildViewController.m
//  deleteme4
//
//  Created by Robert Ryan on 6/13/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import "ChildViewController.h"
#import "ParentControllerDelegate.h"

@interface ChildViewController ()

@property (nonatomic) BOOL didAddGestureDependencies;

@end

@implementation ChildViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = [NSString stringWithFormat:@"%d", self.childNumber];
    label.font = [UIFont systemFontOfSize:300.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blueColor];

    [self.scrollView addSubview:label];

    NSDictionary *views = NSDictionaryOfVariableBindings(label);

    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label(400)]|" options:0 metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label(800)]|" options:0 metrics:nil views:views]];

    self.didAddGestureDependencies = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self makeViewsGesturesRequireParentsGesturesToFail];
}

// If your view has controls with their own gestures, you want to iterate through them, make sure that
// they require the parent's gestures to fail (i.e. try the parent's gestures first). This really is
// only an issue with scrollviews, webviews, or textviews.

- (void)makeViewsGesturesRequireParentsGesturesToFail
{
    if (!self.didAddGestureDependencies)
    {
        id<ParentControllerDelegate> parent = (id)self.parentViewController;
        NSAssert([parent conformsToProtocol:@protocol(ParentControllerDelegate)], @"Parent must conform to ParentControllerDelegate. Parent is %@", parent);
        
        [parent requireEdgeGesturesToFailForView:self.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchUpInsideNextButton:(id)sender
{
    typeof(self) controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ChildViewController"];
    controller.childNumber = self.childNumber + 1;

    id<ParentControllerDelegate> parent = (id)self.parentViewController;
    NSAssert([parent conformsToProtocol:@protocol(ParentControllerDelegate)], @"Parent must conform to ParentControllerDelegate");

    [parent pushChildViewController:controller];
}

- (IBAction)touchUpInsidePreviousButton:(id)sender
{
    id<ParentControllerDelegate> parent = (id)self.parentViewController;
    NSAssert([parent conformsToProtocol:@protocol(ParentControllerDelegate)], @"Parent must conform to ParentControllerDelegate");

    [parent popChildViewController];
}

@end
