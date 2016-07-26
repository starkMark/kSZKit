//
//  JCDebugViewController.m
//  JCProject
//
//  Created by pg on 16/6/3.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JCDebugViewController.h"

@interface JCDebugViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *consoleSwich;
@property (weak, nonatomic) IBOutlet UISwitch *pasteBoard;
@property (weak, nonatomic) IBOutlet UIView *consoleView;

@property (weak, nonatomic) IBOutlet UITextView *consoleTextView;
@end

@implementation JCDebugViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"调试设置";
  self.consoleSwich.on = NO;
  self.pasteBoard.on = NO;
  self.view.backgroundColor = [UIColor whiteColor];
  // Do any additional setup after loading the view from its nib.
    self.consoleView.hidden = YES;
  [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(consoleRefresh) name:@"consoleRefresh" object:nil];

}

-(void)consoleRefresh{
  
  self.consoleTextView.text = [FunctionUtility shareSingleTon].deBugConsle;

}

- (IBAction)infoDebug:(id)sender {
  
}

// 控制台
- (IBAction)consoleAction:(UISwitch *)sender {
  if (sender.on) {
    self.consoleView.hidden = NO;
//    [self.view bringSubviewToFront:self.consoleView];

  }else{
    self.consoleView.hidden = YES;
  }
}

- (IBAction)clearConsle:(id)sender {
  [FunctionUtility shareSingleTon].deBugConsle = @"";
    self.consoleTextView.text =@"";
}
//  剪切板
- (IBAction)pasteboardDebug:(UISwitch *)sender {
  if (sender.on) {
    [FunctionUtility shareSingleTon].deBugMode = YES;
  }else{
    [FunctionUtility shareSingleTon].deBugMode = NO;
    
  }
}

// 关闭控制台
- (IBAction)closeConsole:(id)sender {
  self.consoleSwich.on = NO;
  self.consoleView.hidden = YES;
//  [self.consoleView sendSubviewToBack:self.view];

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
