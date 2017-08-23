//
//  ViewController.m
//  SendSystemMail
//
//  Created by RainHeroic Kung on 2017/8/23.
//  Copyright © 2017年 RainHeroic Kung. All rights reserved.
//

#import "ViewController.h"

#import <MessageUI/MessageUI.h>

#import <MBProgressHUD.h>
@interface ViewController () <UIAlertViewDelegate,MFMailComposeViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"发到邮箱" message:@"请输入邮箱地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertV setAlertViewStyle:UIAlertViewStylePlainTextInput];//“输入文本”类型
    
    //获取输入文本框
    UITextField * textNameTF = [alertV textFieldAtIndex:0];
    textNameTF.keyboardType = UIKeyboardTypeEmailAddress; //邮箱键盘
    textNameTF.placeholder = @"请输入邮箱地址";
    textNameTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]:@"";
    textNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [alertV show];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSLog(@"%ld",buttonIndex);
    if (buttonIndex == 1) { //确认按钮
        UITextField * toEmialTF = [alertView textFieldAtIndex:0];
        
        static NSString * const Regex_Email = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; //验证 邮箱号
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",Regex_Email];
        if ([predicate evaluateWithObject:toEmialTF.text] ) {
            //是邮箱
            [self sendByEmailWith:toEmialTF.text andTitle:@""];//可获取邮箱标题
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"请输入正确格式的邮箱";
            hud.margin = 10.f;
            hud.offset = CGPointMake(0, 0.f);
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:1.5f];
        }
        
    }
    
}



#pragma mark - 发送到邮箱
-(void)sendByEmailWith:(NSString *)toEmailStr andTitle:(NSString *)titleStr {
    // 邮件服务器
    MFMailComposeViewController * mailCompose = [[MFMailComposeViewController alloc] init];
    [mailCompose setMailComposeDelegate:self]; // 代理
    
    [mailCompose setSubject:@"邮件主题"];// 设置邮件主题
    [mailCompose setToRecipients:@[toEmailStr] ];// 设置收件人 (数组)
    [mailCompose setCcRecipients:@[] ];// 设置抄送人 (数组)
    [mailCompose setBccRecipients:@[] ];// 设置密抄送 (数组)
    
    
    /** 设置邮件的正文内容 */
    NSString * emailContent = @"邮件内容";
    
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //[mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    
    
    
    /**  添加附件 ：文件 ➡️ NSData   */
    /** A.发送图片 */
    UIImage * image = [UIImage imageNamed:@"chx.jpg"];
    NSData *imageData = UIImagePNGRepresentation(image); //图片较大
//    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);//图片较小
    [mailCompose addAttachmentData:imageData mimeType:@"" fileName:@"custom.jpg"];//邮件显示的文件名
    
    /** B.发送文档 */
//    NSString * pathStr = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/localFile"];
//    NSString * fileStr = [pathStr stringByAppendingPathComponent:@"蓝牙设备iOS SDK使用文档 -3.pdf"];
//    NSData * data = [NSData dataWithContentsOfFile:fileStr];//保存的数据
//    [mailCompose addAttachmentData:data mimeType:@"" fileName:@"蓝牙设备iOS SDK使用文档.pdf"];//邮件显示的文件名
    
    
    // 弹出邮件发送界面
    if (mailCompose) {  //如果没有设置邮件帐户，mailController为nil
        [self presentViewController:mailCompose animated:YES completion:nil];
    }
    
}



#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    switch(result) {
        case MFMailComposeResultCancelled:{ // 用户取消编辑
            NSLog(@"Mail send canceled...");
        }break;
        case MFMailComposeResultSaved:{ // 用户保存邮件
            NSLog(@"Mail saved...");
        }break;
        case MFMailComposeResultSent:{ // 用户点击发送
            NSLog(@"Mail sent...");
        }break;
        case MFMailComposeResultFailed:{ // 用户尝试保存或发送邮件失败
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = [error localizedDescription];
            hud.margin = 10.f;
            hud.offset = CGPointMake(0, 0.f);
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:1.5f];
        }break;
    }
    
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
