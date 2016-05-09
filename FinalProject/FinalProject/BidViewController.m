//
//  BidViewController.m
//  FinalProject
//
//  Created by 周沛然 on 5/8/16.
//  Copyright © 2016 zzzl. All rights reserved.
//

#import "BidViewController.h"

@interface BidViewController ()
@property (weak, nonatomic) IBOutlet UILabel *passingValue;
@end

@implementation BidViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self.passingValue setText:(_passingString)];
//    NSLog(@"%@", _passingString);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
