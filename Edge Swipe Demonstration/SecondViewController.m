//
//  SecondViewController.m
//  Edge Swipe Demonstration
//
//  Created by Robert Ryan on 7/9/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import "SecondViewController.h"
#import "ParentControllerDelegate.h"
#import "ChildViewController.h"

@interface SecondViewController ()

@property (nonatomic) BOOL didAddGestureDependencies;

@end

@implementation SecondViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

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

- (IBAction)touchUpInsideFirstButton:(id)sender
{
    id<ParentControllerDelegate> parent = (id)self.parentViewController;
    NSAssert([parent conformsToProtocol:@protocol(ParentControllerDelegate)], @"Parent must conform to ParentControllerDelegate");
    
    [parent popChildViewController];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToThird"])
    {
        ChildViewController *controller = segue.destinationViewController;
        controller.childNumber = 3;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
    
    return cell;
}

@end
