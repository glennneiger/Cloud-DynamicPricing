//
//  ViewController.m
//  FinalProject
//
//  Created by 周沛然 on 4/9/16.
//  Copyright (c) 2016 zzzl. All rights reserved.
//
#import "BidViewController.h"
#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.username = @"username"; // 假设username是 username字符串
    self.password = @"password"; //假设password是 password字符串
    
    self.passwordTextField.secureTextEntry = YES; // 密码部分不可见
    
    NSLog(@"%@%@", self.username, self.password);
    
}

- (IBAction)landButtonWasTyped:(id)sender {
    
    // -------------------- Method 1 --------------------
    
//    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@",self.usernameTextField.text, self.passwordTextField.text];
//    
//    NSLog(@"%@", post);
//
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//
//    NSString *postLength = [NSString stringWithFormat:@"%lu", [postData length]];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    
//    [request setURL:[NSURL URLWithString:@"127.0.0.1:8081"]];
//    
//    [request setHTTPMethod:@"GET"];
//    
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    
//    [request setHTTPBody:postData];
//    
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSRange whiteSpaceRange = [self.usernameTextField.text rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    if (whiteSpaceRange.location != NSNotFound) {
        NSLog(@"Found whitespace");
        UIAlertView *whiteSpaceAlert = [[UIAlertView alloc] initWithTitle:@"Username is not valid"
                                                             message:@"Please re-enter username!"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        self.usernameTextField.text = @"";
        [whiteSpaceAlert show];
    }
    else{
    NSString *urlStr = [NSString stringWithFormat:@"http://160.39.139.24:8081/login?username=%@&password=%@", self.usernameTextField.text, self.passwordTextField.text];
    NSLog(@"0");
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"1");
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"2");
    NSURLResponse *response;
    NSLog(@"3");
    NSError *error;
    NSLog(@"4");
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"5");
    NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"6");
    NSLog(@"%@", responseStr);
    
    BOOL isSuccess = [responseStr isEqualToString:(@"Accepted")];
    BOOL isFail = [responseStr isEqualToString:(@"Not Acceptable")];
    
    if(isSuccess){
        NSLog(@"haha");
        
        [self performSegueWithIdentifier:@"login" sender:self];
    }
    if(isFail){
        UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Fail to Login"
                                                             message:@"Your Username or Password is wrong!"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        self.usernameTextField.text = @"";
        self.passwordTextField.text = @"";
        [loginAlert show];
        NSLog(@"koko");
    }
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing: YES];
}


@end
