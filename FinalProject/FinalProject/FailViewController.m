//
//  FailViewController.m
//  FinalProject
//
//  Created by 周沛然 on 5/10/16.
//  Copyright © 2016 zzzl. All rights reserved.
//

#import "FailViewController.h"

@interface FailViewController ()

@end

@implementation FailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logout4:(id)sender {
    [self performSegueWithIdentifier:@"failToLogin" sender:self];
}
- (IBAction)mainpage:(id)sender {
    [self performSegueWithIdentifier:@"failToMainpage" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
