//
//  ViewController.m
//  FinalProject
//
//  Created by 周沛然 on 4/9/16.
//  Copyright (c) 2016 zzzl. All rights reserved.
//

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
    
    NSString *post = [NSString stringWithFormat:@"&Username=%@&Password=%@",@"username",@"password"];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];

    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:@"127.0.0.1"]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self]; 
    
    
    
    // 判断username 和 password是否匹配，if... else...
    BOOL isUsernameEqual = [self.username isEqualToString:[self.usernameTextField text]];
    BOOL isPasswordEqual = [self.password isEqualToString:[self.passwordTextField text]];
    
    if(isUsernameEqual && isPasswordEqual){
        
        NSLog(@"OK!");
        
        [self performSegueWithIdentifier:@"login" sender:self]; // 从当前框转换到login界面
    }
    else{
        
        // 如果username 或者 password输入错误，则弹出提醒框，清空输入框内容
        UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Fail to Login"
                                                       message:@"Your Username or Password is wrong!"
                                                       delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
        self.usernameTextField.text = @"";
        self.passwordTextField.text = @"";
        [loginAlert show];
        NSLog(@"NO!");
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
