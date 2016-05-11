//
//  MyAccountInfoViewController.m
//  FinalProject
//
//  Created by 周沛然 on 5/11/16.
//  Copyright © 2016 zzzl. All rights reserved.
//
#import "AppDelegate.h"
#import "MyAccountInfoViewController.h"

@interface MyAccountInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *myAccountInfoShow;

@end

@implementation MyAccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate13 = [[UIApplication sharedApplication] delegate];    // Set global value
    
    
    NSString *urlStr = [NSString stringWithFormat:@"http://dynamicpricing-env.us-east-1.elasticbeanstalk.com/profile?username=%@", appDelegate13.usernameGlobal];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseStr);
    
    responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    responseStr = [responseStr stringByReplacingOccurrencesOfString:@"}" withString:@""];
    responseStr = [responseStr stringByReplacingOccurrencesOfString:@"{" withString:@""];
    responseStr = [responseStr stringByReplacingOccurrencesOfString:@"[" withString:@""];
    responseStr = [responseStr stringByReplacingOccurrencesOfString:@"]" withString:@""];
    responseStr = [responseStr stringByReplacingOccurrencesOfString:@",username" withString:@"\rusername"];


    
        [self.myAccountInfoShow setText: responseStr];
        self.myAccountInfoShow.lineBreakMode = NSLineBreakByWordWrapping;
        self.myAccountInfoShow.numberOfLines = 0;
    

    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
