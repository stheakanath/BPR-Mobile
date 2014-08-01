//
//  OptionsMenuController.m
//  Wear Pants
//
//  Created by Sony Theakanath on 3/22/13.
//  Copyright (c) 2013 Sony Theakanath. All rights reserved.
//

#import "OptionsMenuController.h"
#import "Appirater.h"

@interface OptionsMenuController ()

@end

@implementation OptionsMenuController

@synthesize interfaceArray;

- (IBAction)dismissView:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)goToWebsite:(id)sender {
    NSString *url = @"http://www.sonytheakanath.com";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url stringByAppendingFormat:@""]]];
}

- (IBAction)suggestions:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"mailto:Sony.Theakanath14@bcp.org"stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (IBAction)goToBPR:(id)sender {
    NSString *url = @"http://bpr.bcp.org";
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url stringByAppendingFormat:@""]]];
}


- (void) startInterface {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    interfaceArray = [[NSArray alloc] initWithObjects:
                      [UIButton buttonWithType:UIButtonTypeRoundedRect],
                      [UIButton buttonWithType:UIButtonTypeRoundedRect],
                      [UIButton buttonWithType:UIButtonTypeRoundedRect],
                      [UIButton buttonWithType:UIButtonTypeRoundedRect],
                      nil];
    
    [[interfaceArray objectAtIndex:0] addTarget:self action:@selector(goToWebsite:) forControlEvents:UIControlEventTouchUpInside];
    [[interfaceArray objectAtIndex:0] setFrame:CGRectMake(screenWidth/2-105, screenHeight-70, 210, 40)];
    [[interfaceArray objectAtIndex:0] setTitle:@"http://sonytheakanath.com" forState:UIControlStateNormal];
    [[interfaceArray objectAtIndex:0] setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    
    [[interfaceArray objectAtIndex:1] addTarget:self action:@selector(goToBPR:) forControlEvents:UIControlEventTouchUpInside];
    [[interfaceArray objectAtIndex:1] setFrame:CGRectMake(screenWidth/2-105, screenHeight-120, 210, 40)];
    [[interfaceArray objectAtIndex:1] setTitle:@"Go To BPR Website" forState:UIControlStateNormal];
    [[interfaceArray objectAtIndex:1] setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    
    [[interfaceArray objectAtIndex:2] addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
    [[interfaceArray objectAtIndex:2] setFrame:CGRectMake((screenWidth/2-25), screenHeight-220, 50, 40)];
    [[interfaceArray objectAtIndex:2] setTitle:@"Back" forState:UIControlStateNormal];
    [[interfaceArray objectAtIndex:2] setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];

    [[interfaceArray objectAtIndex:3] addTarget:self action:@selector(suggestions:) forControlEvents:UIControlEventTouchUpInside];
    [[interfaceArray objectAtIndex:3] setUserInteractionEnabled:NO];
    [[interfaceArray objectAtIndex:3] setFrame:CGRectMake(screenWidth/2-105, screenHeight-170, 210, 40)];
    [[interfaceArray objectAtIndex:3] setTitle:@"Suggestions? Email Me." forState:UIControlStateNormal];
    [[interfaceArray objectAtIndex:3] setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    for (UIView *view in interfaceArray)
        if(![view superview])
            [[self view] addSubview:view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
