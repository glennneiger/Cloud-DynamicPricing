//
//  BidViewController.m
//  FinalProject
//
//  Created by 周沛然 on 5/8/16.
//  Copyright © 2016 zzzl. All rights reserved.
//

#import "AppDelegate.h"
#import "BidViewController.h"

@interface BidViewController ()

// passingValue用于商品信息.
@property (weak, nonatomic) IBOutlet UILabel *passingValue;
@property (weak, nonatomic) IBOutlet UITextField *expectingPrice;
@property int countcount;
@property (weak, nonatomic) IBOutlet UILabel *passingValueDescription;
@property (weak, nonatomic) IBOutlet UILabel *passingValueBusiness;

@end

@implementation BidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate4 = [[UIApplication sharedApplication] delegate];
    
    self.countcount = 0;
    
    // 显示商品信息
    [self.passingValue setText: appDelegate4.itemnameGlobal];
    [self.passingValueDescription setText: appDelegate4.descriptionGlobal];
    [self.passingValueBusiness setText: appDelegate4.businessnameGlobal];

}


- (IBAction)confirmPrice:(id)sender {
    
    // 取出商品的最低价格用于做比较
    AppDelegate *appDelegate5 = [[UIApplication sharedApplication] delegate];
    
    
    // 转化底价和投标价的数据类型（NSString - NSNumber）
    NSNumber *lowestPrice2 = @([appDelegate5.lowestPriceGlobal floatValue]);
    NSNumber *expectPrice = @([self.expectingPrice.text floatValue]);
    NSLog(@"%@", expectPrice);
    
    
    // 输入投标价的地方不能是空的
    if([self.expectingPrice.text isEqualToString:@""]){
        UIAlertView *notEmptyAlert = [[UIAlertView alloc] initWithTitle:@"Space can not be empty"
                                                             message:@"Please enter price!"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [notEmptyAlert show];
    }
    
    
    else{
    
    // 如果bid的价格小于最低价
    if([expectPrice floatValue] < [lowestPrice2 floatValue]){
        
        // 计数器，只让bid三次！
        self.countcount = self.countcount + 1;
        
        
        if(self.countcount >2){
            NSLog(@"Say good bye to this product!");
            
            // 如果bid失败大于三次，则将username, barcode, businessname, bid_price=0同步到database，记录下这个username,禁止他再对同样的商品做bid.
            NSString *urlStr = [NSString stringWithFormat:@"http://209.2.222.143:8081/transaction?username=%@&barcode=%@&businessname=%@&bid_price=0", appDelegate5.usernameGlobal, appDelegate5.barcodeGlobal, appDelegate5.businessnameGlobal];
            NSURL *url = [NSURL URLWithString:urlStr];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSURLResponse *response;
            NSError *error;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", responseStr);
            
            self.countcount = 0;
            
            [self performSegueWithIdentifier:@"failBid" sender:self];
            
        }
        
        
        if(self.countcount != 0){
        
        NSString *theAnswer = [NSString stringWithFormat:@"The rest of times: %d", 3-self.countcount];
        
        UIAlertView *bidAgainAlert = [[UIAlertView alloc] initWithTitle:@"Your price is so low!"
                                                                message:theAnswer
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
        [bidAgainAlert show];
            
        }
        
        NSLog(@"Re-Bid!");
        
    }
    
    // 如果bid价格大于最低价
    else{
        
        // 设置bid_price全局变量
        AppDelegate *appDelegate6 = [[UIApplication sharedApplication] delegate];
        appDelegate6.bid_price = self.expectingPrice.text;
        
        // 记录下bid的详细信息: username, barcode, businessname, bid_price. 以后user不得再bid.
        NSString *urlStr = [NSString stringWithFormat:@"http://160.39.138.243:8081/transaction?username=%@&barcode=%@&businessname=%@&bid_price=%@", appDelegate5.usernameGlobal, appDelegate5.barcodeGlobal, appDelegate5.businessnameGlobal, [expectPrice stringValue]];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLResponse *response;
        NSError *error;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", responseStr);
        
        NSLog(@"It's yours!");
        
        [self performSegueWithIdentifier:@"successBid" sender:self];
        
    }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (IBAction)logout2:(id)sender {
    [self performSegueWithIdentifier:@"bidToLogin" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing: YES];
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
