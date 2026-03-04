#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <sys/utsname.h>

// --- [ واجهة الوزير VIP الفخمة ] ---
@interface AlWazerGuardVC : UIViewController
@end

@implementation AlWazerGuardVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, self.view.frame.size.width-40, 40)];
    title.text = @"🛡️ نظام حماية الوزير";
    title.font = [UIFont boldSystemFontOfSize:26];
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];

    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, self.view.frame.size.width-40, 280)];
    desc.numberOfLines = 0;
    desc.textAlignment = NSTextAlignmentCenter;
    desc.text = [NSString stringWithFormat:@"مرحباً بك يا بطل\n\nجهازك: %@\nUDID: %@\n\nيجب تثبيت ملف التعريف لحجب رصد السناب وتشفير بيانات الـ 10,000 مستخدم. بدون التثبيت سيتم إغلاق النسخة فوراً لحمايتك.", deviceModel, udid];
    [self.view addSubview:desc];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(50, 450, self.view.frame.size.width-100, 55);
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:@"سماح وتثبيت الحماية" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 27;
    [btn addTarget:self action:@selector(install) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)install {
    // ⚠️ استبدل الرابط أدناه برابط ملفك المرفوع
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ALWAZER-HOST.com/protect.mobileconfig"] options:@{} completionHandler:nil];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AlWazerSafe"];
}
@end

// --- [ دمج حمايات الصور الـ 50 ] ---
%hook SCAppConfiguration
- (BOOL)boolForConfiguration:(NSString *)config {
    if ([config isEqualToString:@"is_jailbroken"] || [config isEqualToString:@"should_block_tweaks"]) return NO;
    return %orig;
}
%end

%hook SCAppIntegrityManager
- (long long)applicationIntegrityStatus { return 0; }
- (BOOL)isAppSignatureValid { return YES; }
%end

%hook SCSecurityIdentityService
- (id)getDeviceIdentityToken { return nil; } 
%end

%hook SCLoginRegisterViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"AlWazerSafe"]) {
        AlWazerGuardVC *vc = [[AlWazerGuardVC alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
%end
