//
//  WhetherBidViewController.m
//  FinalProject
//
//  Created by 周沛然 on 5/9/16.
//  Copyright © 2016 zzzl. All rights reserved.
//
#import "AppDelegate.h"
#import "WhetherBidViewController.h"

@interface WhetherBidViewController ()

@end

@implementation WhetherBidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)WantToBid:(id)sender {
    
    AppDelegate *appDelegate2 = [[UIApplication sharedApplication] delegate];
    
    // 判断该该用户是否有资格进行bid。（通过匹配barcode, businessname, username来确定）
    NSString *urlStr = [NSString stringWithFormat:@"http://209.2.222.143:8081/bid?barcode=%@&businessname=%@&username=%@", appDelegate2.barcodeGlobal, appDelegate2.businessnameGlobal, appDelegate2.usernameGlobal];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseStr);
    
    
    // 如果返回Forbidden, 则表示该用户失去了bid的权利.
    if([responseStr isEqualToString:@"Forbidden"]){
        
        UIAlertView *alreadyBidAlert = [[UIAlertView alloc] initWithTitle:@"Sorry You Have Already Bid!"
                                                                message:@"Please scan other products~"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
        
        [alreadyBidAlert show];
        
        [self performSegueWithIdentifier:@"WhetherBidToMainpage" sender:self];

    }
    
    // 如果返回不是Forbidden，则表示该用户有权利进行bid. 并且server返回商品信息以及底价. 将,itemname, description, price存成global variable.
    else{
    
    // 处理返回的报文段.
    responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    responseStr = [responseStr stringByReplacingOccurrencesOfString:@"}" withString:@""];
    responseStr = [responseStr stringByReplacingOccurrencesOfString:@"{" withString:@""];
    NSLog(@"%@", responseStr);
        
    NSArray *subStrings = [responseStr componentsSeparatedByString:@","];
    NSString *itemnameOrg = [subStrings objectAtIndex:0];
    NSString *descriptionOrg = [subStrings objectAtIndex:1];
    NSString *priceOrg = [subStrings objectAtIndex:2];
    
    NSString *itemname = [itemnameOrg substringFromIndex:9];
    NSString *description = [descriptionOrg substringFromIndex:12];
    NSString *price = [priceOrg substringFromIndex:6];
    
        
    NSLog(@"%@", itemname);
    NSLog(@"%@", description);
    NSLog(@"%@", price);
    
    
    // 将处理好的值传给Global Variable
    AppDelegate *appDelegate3 = [[UIApplication sharedApplication] delegate];    // Set global value
    appDelegate3.descriptionGlobal = description;
    appDelegate3.lowestPriceGlobal = price;
    appDelegate3.itemnameGlobal = itemname;
    
        
    // 进入bid页面
    [self performSegueWithIdentifier:@"BidYes" sender:self];

    }
    
}

- (IBAction)regretBid:(id)sender {
    [self performSegueWithIdentifier:@"WhetherBidToMainpage" sender:self];
}

- (IBAction)logout:(id)sender {
    [self performSegueWithIdentifier:@"whetherBidToLogin" sender:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
