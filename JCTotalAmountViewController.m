//
//  JCTotalAmountViewController.m
//  JIECAI
//
//  Created by Jame on 15/3/13.
//  Copyright (c) 2015年 Jame. All rights reserved.
//

#import "ModalAnimation.h"
#import "JCWithdrawNomalVC.h"
#import "JCRechargeViewController.h"
#import "JCTotalAmountViewController.h"

@interface JCTotalAmountViewController ()<UIViewControllerTransitioningDelegate>
{
  //2.动画全局变量
  ModalAnimation *_modalAnimationController;
}
@property (strong, nonatomic) NSDictionary *bankDic;
@property (strong, nonatomic) NSDictionary *statuesDic;
@property (strong, nonatomic) NSString *senderBtnTag;//区别提现及充值事件
@property (weak, nonatomic) IBOutlet UIButton *withButton;
@property (weak, nonatomic) IBOutlet UIButton *rechButton;
@property (strong, nonatomic) IBOutlet UILabel *expMoneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *frozenMon;
@property (strong, nonatomic) IBOutlet UIView *frozenMoneyView;
@end

@implementation JCTotalAmountViewController

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:YES];
  [self.scrollView headerBeginRefreshing];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"总资产";
  self.frozenMoneyView.hidden = YES;//默认无冻结金额
  // 3.初始化展现动画
  _modalAnimationController = [[ModalAnimation alloc] init];
  [self initTotalAmountViewController];
  
}

- (void)initTotalAmountViewController{
  self.scrollView.contentSize = CGSizeMake(0, 700);
  self.scrollView.showsVerticalScrollIndicator = NO;
  [self.scrollView addHeaderWithTarget:self action:@selector(headerRefreshing)];
  
}

- (void)headerRefreshing{
  [self doGetUserAmountInformation];
  [self performSelector:@selector(EndRefresh) withObject:self afterDelay:8];
}

- (void)EndRefresh{
  [self.scrollView headerEndRefreshing];
}

- (void)doGetUserAmountInformation{
  NSMutableDictionary *dic_ = [[NSMutableDictionary alloc]init];
  if (CURRENT_USER) {
    [dic_ setObject:CURRENT_USER.userID forKey:@"uId"];
  }
  UserService *userService = [ServiceFactory getService:@"userService"];
  [userService getUserAccountDetailWithParameter:dic_ Delegate:self];
}

- (void)didGetUserAccountDetail:(NSDictionary *)returnDic{
  [self.scrollView headerEndRefreshing];
  [self initSubViews:returnDic];
  SZLog(@"didGetUserAccountDetail::%@",returnDic);
  
}

/** 总资产数据加载 */
- (void)initSubViews:(NSDictionary *)retrun{
  
  /**
   await = 0;
   jcBaoAmount = 0;
   uAmtTotal = 1131200;
   uBalance = 1131000;
   uFrostAmt = 200;
   uFrostAmtCash = 0;
   uFrostAmtTender = 0;
   uId = 18600000325;
   */
  
  NSString *captialString = [NSString stringWithFormat:@"%0.2f", [[retrunDic objectForKey:@"uWaitRecvCapital"] doubleValue]];
  captialString = [FunctionUtility stringOfStandardMoney:captialString];
  self.captialLabel.text = captialString;
  
  NSString *interestString =[NSString stringWithFormat:@"%0.2f", [[retrunDic objectForKey:@"uWaitRecvInterest"] doubleValue]];
  interestString = [FunctionUtility stringOfStandardMoney:interestString];
  self.interestLabel.text = interestString;
  
  NSString *investString =[NSString stringWithFormat:@"%0.2f", [[retrunDic objectForKey:@"uFrostAmtTender"] doubleValue]];
  investString = [FunctionUtility stringOfStandardMoney:investString];
  self.investLabel.text = investString;
  
  NSString *withdrawString = [NSString stringWithFormat:@"%0.2f",[[retrunDic objectForKey:@"uFrostAmtCash"] doubleValue]];
  withdrawString = [FunctionUtility stringOfStandardMoney:withdrawString];
  self.withdrawLabel.text = withdrawString;
  
  
  [AppDocument sharedDocument].leftAmount =[[retrunDic objectForKey:@"uBalance"]doubleValue];
  NSString *useableString = [NSString stringWithFormat:@"%0.2f",[[retrunDic objectForKey:@"uBalance"]doubleValue]];
  useableString = [FunctionUtility stringOfStandardMoney:useableString];
  self.useableLabel.text = useableString;

  
  /**总计*/
  NSString *totalString = [NSString stringWithFormat:@"%0.2f", [[retrunDic objectForKey:@"currBal"] doubleValue]+[[retrunDic objectForKey:@"experenceMoney"] doubleValue]+[[retrunDic objectForKey:@"awaitInterest"] doubleValue]+[[retrunDic objectForKey:@"awaitRewardInterest"] doubleValue]+[[retrunDic objectForKey:@"JCB"] doubleValue]];
  totalString = [FunctionUtility stringOfStandardMoney:totalString];
  self.totalLabel.text = totalString;
  /**代收本金*/
  NSString *captialString = [NSString stringWithFormat:@"%0.2f", [[retrunDic objectForKey:@"awaitCapital"] doubleValue]];
  captialString = [FunctionUtility stringOfStandardMoney:captialString];
  self.captialLabel.text = captialString;
  /**代收利息*/
  NSString *interestString =[NSString stringWithFormat:@"%0.2f", [[retrunDic objectForKey:@"awaitInterest"] doubleValue]];
  interestString = [FunctionUtility stringOfStandardMoney:interestString];
  self.interestLabel.text = interestString;
  
  NSString *investString =[NSString stringWithFormat:@"%0.2f", [[retrunDic objectForKey:@"uFrostAmtTender"] doubleValue]];
  investString = [FunctionUtility stringOfStandardMoney:investString];
  self.investLabel.text = investString;
  /**冻结金额*/
  NSString *withdrawString = [NSString stringWithFormat:@"%0.2f",[[retrunDic objectForKey:@"currBal"] doubleValue] - [[retrunDic objectForKey:@"availBal"] doubleValue]];
  withdrawString = [FunctionUtility stringOfStandardMoney:withdrawString];
  self.withdrawLabel.text = withdrawString;
  
  /**可用余额*/
  //  [AppDocument sharedDocument].leftAmount =[[retrunDic objectForKey:@"uBalance"]doubleValue];
  //  DLog(@"[retrunDic objectForKey]%@",[retrunDic objectForKey:@"txTime"]);
  NSString *useableString = [NSString stringWithFormat:@"%0.2f",[[retrunDic objectForKey:@"availBal"]doubleValue]];
  useableString = [FunctionUtility stringOfStandardMoney:useableString];
  self.useableLabel.text = useableString;
  
}

#pragma mark - 充值
- (IBAction)showRechargeViewController:(id)sender {
  self.senderBtnTag = @"0";//充值
  self.rechButton.enabled = NO;
  [self loadUserStatues];
  [self performSelector:@selector(rechButtonEnable) withObject:nil afterDelay:2];
}

//  防重点
- (void)rechButtonEnable{
  self.rechButton.enabled = YES;
}

#pragma mark - 提现
- (IBAction)showWithdrawViewC:(id)sender{
  self.senderBtnTag = @"1";//提现;
  self.withButton.enabled = NO;
  [self loadUserStatues];
  [self performSelector:@selector(withButtonEnable) withObject:nil afterDelay:2];
}

//  防重点
- (void)withButtonEnable{
  self.withButton.enabled = YES;
}

#pragma mark - 获取用户状态
-(void)loadUserStatues{
  NSMutableDictionary *dic_ = [NSMutableDictionary dictionary];
  [dic_ setObject:CURRENT_USER.userID forKey:@"uId"];
  BorrowService *borrowService = [ServiceFactory getService:@"borrowService"];
  [borrowService getBorrowUserStatuesWithParameter:dic_ Delegate:self];
  
}
/**根据状态码确定弹层*/
- (void)didLoadUserStatuesData:(NSDictionary *)returnDictionary{
  self.statuesDic = returnDictionary;
  SZLog(@"didLoadBorrowUserStatuesData%@",returnDictionary);
  NSString *statueStr = [returnDictionary objectForKey:@"userStatus"];
  
  if ([statueStr isEqualToString:@"0"]) {
    if ([self.senderBtnTag isEqualToString:@"1"]) {
      //  提现
      JCWithdrawNomalVC *drawNomal = [[JCWithdrawNomalVC alloc]init];
      drawNomal.bankDic = self.statuesDic;
      drawNomal.useableStr = self.useableLabel.text;
      [self.navigationController pushViewController:drawNomal animated:YES];
    }else if([self.senderBtnTag isEqualToString:@"0"]){
      //  充值
      JCRechargeViewController *rechargeVC = [[JCRechargeViewController alloc]init];
      //  可用余额
      rechargeVC.leftAccount = self.useableLabel.text;
      rechargeVC.statuesDic = self.statuesDic;
      [self.navigationController pushViewController:rechargeVC animated:YES];
      
    }
  }else{
    OpenAccountVC * openAccount = [[OpenAccountVC alloc]initWithNibName:@"OpenAccountVC" bundle:nil];
    openAccount.supViewNumber = @"2";
    openAccount.statuesDic = self.statuesDic;
    openAccount.modalPresentationStyle =UIModalPresentationCustom;
    openAccount.transitioningDelegate = self;
    [self presentViewController:openAccount animated:YES completion:nil];
  }
}


- (void)didEndScrollViewRefresh{
  //  [self.scrollView headerEndRefreshing];
}


//  5.实现动画代理方法
#pragma mark - Transitioning Delegate (Modal)
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
  _modalAnimationController.type = AnimationTypePresent;
  return _modalAnimationController;
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
 再次保存用户信息,账户页信息
 [self loadAccountInfo];
 
 - (void)loadAccountInfo{
 NSMutableDictionary *dic_ = [[NSMutableDictionary alloc]init];
 if (CURRENT_USER) {
 [dic_ setObject:CURRENT_USER.userID forKey:@"uId"];
 }
 UserService *userService = [ServiceFactory getService:@"userService"];
 [userService getUserInfoWithParameter:dic_ Delegate:self];
 }
 
 - (void)didGetUserInformationSuccess:(NSDictionary *)returnDic{
 [self.scrollView headerEndRefreshing];
 ACCOUNT_LAST_REFRESH_TIME = [NSDate date];
 UserModel *userModel = [[UserModel alloc]init];
 [userModel storeUserFeeDetail:returnDic];
 NSDictionary *userDic = [returnDic objectForKey:@"uInfo"];
 [userModel storeUserCardInformation:userDic];
 NSInteger VipLevel = [[returnDic objectForKey:@"uVipLevel"] integerValue];
 [userModel storeUserVipLevel:VipLevel];
 
 }
 
 #pragma mark -  调支付接口
 - (void)getRechargeID{
 
 NSMutableDictionary *dic_ = [NSMutableDictionary dictionary];
 UserService *userService = [ServiceFactory getService:@"userService"];
 [userService getRechargeIDWithParameter:dic_ Delegate:self];
 }
 
 #pragma mark - 验证后打开连连支付
 - (void)didGetRechargeID:(NSDictionary *)returnDic{
 //    DLog(@"pay/validate.html----%@",returnDic);
 self.bankDic = returnDic;
 
 NSString *bankCard = [NSString stringWithFormat:@"%@",[returnDic objectForKey:@"t"]];
 NSString *passwordStatus =[NSString stringWithFormat:@"%@",[returnDic objectForKey:@"isdigital"]];
 
 if (self.selectAction ==1) {
 if (CURRENT_USER.cardID) {
 //判断用户状态
 if ([bankCard isEqualToString:@"2"]) {
 //  未绑卡
 JCCardTiedViewController *cardTiedVC = [[JCCardTiedViewController alloc]init];
 [cardTiedVC setHidesBottomBarWhenPushed:YES];
 [self.navigationController pushViewController:cardTiedVC animated:YES];
 
 }else{
 //  已绑卡
 JCRechargeViewController *rechargeViewController_ = [[JCRechargeViewController alloc]init];
 //  可用余额
 rechargeViewController_.leftAccount = self.useableLabel.text;
 
 [rechargeViewController_ setHidesBottomBarWhenPushed:YES];
 [self.navigationController pushViewController:rechargeViewController_ animated:YES];
 }
 }else{
 
 // 未实名认证 825
 //            JCGuildCustomViewController *guildCustomViewController = [[JCGuildCustomViewController alloc]init];
 //            guildCustomViewController.transitioningDelegate = self;
 //            guildCustomViewController.supViewNo = 2;
 //            guildCustomViewController.modalPresentationStyle = UIModalPresentationCustom;
 //            [self presentViewController:guildCustomViewController animated:YES completion:nil];
 
 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"为保障您的账户安全，充值前需要先完成实名认证" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"实名认证", nil];
 alertView.tag = 2000;
 [alertView show];
 }
 }else if (self.selectAction ==2){
 if (CURRENT_USER.cardID) {
 if (bankCard) {
 if ([bankCard isEqualToString:@"2"]){
 JCCardTiedViewController*cardTiedViewController = [[JCCardTiedViewController alloc]init];
 
 [self.navigationController pushViewController:cardTiedViewController animated:YES];
 }else {
 NSArray *bankList = [[NSArray alloc]initWithObjects:returnDic, nil];
 NSString * openAcctName = [self.bankDic objectForKey:@"bbn"];
 if (openAcctName.length>1) {
 //  非初次提现
 JCWithdrawNomalVC *withdrawNomalVC = [[JCWithdrawNomalVC alloc]init];
 withdrawNomalVC.passwordStatus = [passwordStatus integerValue];
 withdrawNomalVC.returnArray = bankList;//datasourse
 
 [self.navigationController pushViewController:withdrawNomalVC animated:YES];
 
 }else{
 
 //  初次提现
 JCWithdrawViewController *withdrawViewController_ = [[JCWithdrawViewController alloc]init];
 //    withdrawViewController_.useableString = self.useableLabel.text;
 withdrawViewController_.returnArray = bankList;//datasourse
 withdrawViewController_.passwordStatus = [passwordStatus integerValue];
 [self.navigationController pushViewController:withdrawViewController_ animated:YES];
 }
 }
 }
 }else{
 // 未实名认证 825
 //            JCGuildCustomViewController *guildCustomViewController = [[JCGuildCustomViewController alloc]init];
 //            guildCustomViewController.transitioningDelegate = self;
 //            guildCustomViewController.supViewNo = 2;
 //            guildCustomViewController.modalPresentationStyle = UIModalPresentationCustom;
 //            [self presentViewController:guildCustomViewController animated:YES completion:nil];
 
 
 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请先完成实名认证和银行卡认证后，再进行提现。" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"实名认证", nil];
 alertView.tag = 2000;
 [alertView show];
 }
 }
 }
 
 #pragma mark - alert delegate
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 if (alertView.tag == 2000) {
 if (buttonIndex == 1) {
 JCValidateRealUserViewController *validateRealUserViewController_ = [[JCValidateRealUserViewController alloc]init];
 if (validateRealUserViewController_.hidesBottomBarWhenPushed == NO) {
 [validateRealUserViewController_ setHidesBottomBarWhenPushed:YES];
 }
 [self.navigationController pushViewController:validateRealUserViewController_ animated:YES];
 }
 }
 }
 */

@end
