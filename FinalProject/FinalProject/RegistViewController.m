//
//  RegistViewController.m
//  FinalProject
//
//  Created by 周沛然 on 5/8/16.
//  Copyright (c) 2016 zzzl. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *registUsernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *registPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *registPassword2TextField;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.registPasswordTextField.secureTextEntry = YES;
    self.registPassword2TextField.secureTextEntry = YES;
}

- (IBAction)registButtonIsTyped:(id)sender {
    
    BOOL passwordIsEqual = [_registPasswordTextField.text isEqualToString:(_registPassword2TextField.text)];
    
    BOOL textField1IsEmpty = [_registUsernameTextField.text isEqualToString:(@"")];
    BOOL textField2IsEmpty = [_registPasswordTextField.text isEqualToString:(@"")];
    BOOL textField3IsEmpty = [_registPassword2TextField.text isEqualToString:(@"")];
    
    if(textField1IsEmpty || textField2IsEmpty || textField3IsEmpty){
        UIAlertView *textfieldEmptyAlert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                     message:@"Man, text field can not be empty!"
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
        [textfieldEmptyAlert show];
        self.registUsernameTextField.text = @"";
        self.registPasswordTextField.text = @"";
        self.registPassword2TextField.text = @"";
    }
    else{
    if(passwordIsEqual){
        NSLog(@"Equal");

        NSString *urlStr2 = [NSString stringWithFormat:@"http://localhost:8081/signup?username=%@&password=%@", self.registUsernameTextField.text, self.registPasswordTextField.text];
        NSURL *url2 = [NSURL URLWithString:urlStr2];
        NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
        NSURLResponse *response2;
        NSError *error2;
        NSData *responseData2 = [NSURLConnection sendSynchronousRequest:request2 returningResponse:&response2 error:&error2];
        NSString *responseStr2 = [[NSString alloc] initWithData:responseData2 encoding:NSUTF8StringEncoding];
        NSLog(@"%@", responseStr2);
        
        BOOL isSuccess2 = [responseStr2 isEqualToString:(@"Accepted")];
        BOOL isFail2 = [responseStr2 isEqualToString:(@"Not Acceptable")];
        
        if(isSuccess2){
            NSLog(@"haha");

            UIAlertView *registSuccessAlert = [[UIAlertView alloc] initWithTitle:@"Congratulation!"
                                                                         message:@"You have successfully registed!"
                                                                        delegate:self
                                                               cancelButtonTitle:@"OK"
                                                               otherButtonTitles:nil];
            [registSuccessAlert show];
            [self performSegueWithIdentifier:@"registToWelcome" sender:self];
        }
        if(isFail2){
            UIAlertView *registFailAlert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                         message:@"The username has been occupied, please choose another one!"
                                                                        delegate:self
                                                               cancelButtonTitle:@"OK"
                                                               otherButtonTitles:nil];
            [registFailAlert show];
            self.registUsernameTextField.text = @"";
            self.registPasswordTextField.text = @"";
            self.registPassword2TextField.text = @"";
        }
        
    }
    else{
        NSLog(@"Not Equal");
        
        UIAlertView *passwordWrongAlert = [[UIAlertView alloc] initWithTitle:@"Password is not match!"
                                                             message:@"Please re-enter the password"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [passwordWrongAlert show];

        self.registPasswordTextField.text = @"";
        self.registPassword2TextField.text = @"";
        
    }
    }
    
    
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
