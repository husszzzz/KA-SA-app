#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// ==========================================
// 1. كلاس الحماية الوهمي (تطابق مع Info.plist)
// ==========================================
@interface SAUnityApplication : UIApplication
@end
@implementation SAUnityApplication
@end

// ==========================================
// 2. واجهة تسجيل الدخول (SATAR VIP)
// ==========================================
@interface SatarAuthView : UIView
@property (nonatomic, strong) UITextField *codeField;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *welcomeLabel;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UILabel *iconLabel;
@end

@implementation SatarAuthView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLuxuriousUI];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)setupLuxuriousUI {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:blurView];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 340, 450)];
    containerView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    containerView.backgroundColor = [UIColor colorWithRed:0.04 green:0.06 blue:0.12 alpha:0.95];
    containerView.layer.cornerRadius = 24;
    containerView.layer.borderWidth = 1.5;
    containerView.layer.borderColor = [UIColor colorWithRed:0.1 green:0.5 blue:1.0 alpha:0.6].CGColor;
    containerView.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.6 blue:1.0 alpha:1.0].CGColor;
    containerView.layer.shadowOpacity = 0.5;
    containerView.layer.shadowRadius = 25;
    containerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:containerView];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake((340-100)/2, 25, 100, 100)];
    logoView.contentMode = UIViewContentModeScaleAspectFill;
    logoView.layer.cornerRadius = 20;
    logoView.clipsToBounds = YES;
    logoView.layer.borderWidth = 2;
    logoView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.15].CGColor;
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        // صورة ستار جبار
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:@"https://a.top4top.io/p_3916ea7qr1.jpg"]];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                logoView.image = [UIImage imageWithData:data];
            });
        }
    });
    [containerView addSubview:logoView];
    
    self.welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 300, 50)];
    self.welcomeLabel.text = @"أهـلاً بك في نظـام الحمايـة ✦\nيرجى إدخال كود التفعيل الخاص بك";
    self.welcomeLabel.textColor = [UIColor whiteColor];
    self.welcomeLabel.textAlignment = NSTextAlignmentCenter;
    self.welcomeLabel.font = [UIFont boldSystemFontOfSize:15];
    self.welcomeLabel.numberOfLines = 2;
    [containerView addSubview:self.welcomeLabel];
    
    self.iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 300, 50)];
    self.iconLabel.font = [UIFont systemFontOfSize:35];
    self.iconLabel.textAlignment = NSTextAlignmentCenter;
    self.iconLabel.alpha = 0; 
    [containerView addSubview:self.iconLabel];
    
    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(30, 205, 280, 50)];
    self.codeField.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    self.codeField.textColor = [UIColor colorWithRed:0.3 green:0.8 blue:1.0 alpha:1.0];
    self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.font = [UIFont boldSystemFontOfSize:16];
    self.codeField.layer.cornerRadius = 14;
    self.codeField.layer.borderWidth = 1;
    self.codeField.layer.borderColor = [UIColor colorWithRed:0.2 green:0.4 blue:0.8 alpha:0.5].CGColor;
    self.codeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"XXXX-XXXX" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.3]}];
    [containerView addSubview:self.codeField];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.loginBtn.frame = CGRectMake(30, 275, 280, 50);
    [self.loginBtn setTitle:@"تفعيل الدخول ➔" forState:UIControlStateNormal];
    self.loginBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.45 blue:0.95 alpha:1.0];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.loginBtn.layer.cornerRadius = 14;
    self.loginBtn.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.45 blue:0.95 alpha:1.0].CGColor;
    self.loginBtn.layer.shadowOpacity = 0.6;
    self.loginBtn.layer.shadowRadius = 10;
    self.loginBtn.layer.shadowOffset = CGSizeMake(0, 4);
    [self.loginBtn addTarget:self action:@selector(verifyCode) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:self.loginBtn];
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 335, 300, 40)];
    self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0];
    self.statusLabel.font = [UIFont boldSystemFontOfSize:13];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.numberOfLines = 2;
    self.statusLabel.text = @"";
    [containerView addSubview:self.statusLabel];
    
    UIButton *channelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    channelBtn.frame = CGRectMake(30, 385, 135, 45);
    [channelBtn setTitle:@"❖ القناة" forState:UIControlStateNormal];
    channelBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.05];
    [channelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    channelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    channelBtn.layer.cornerRadius = 12;
    [channelBtn addTarget:self action:@selector(openChannel) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:channelBtn];

    UIButton *devBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    devBtn.frame = CGRectMake(175, 385, 135, 45);
    [devBtn setTitle:@"⎋ المطور" forState:UIControlStateNormal];
    devBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.05];
    [devBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    devBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    devBtn.layer.cornerRadius = 12;
    [devBtn addTarget:self action:@selector(openDev) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:devBtn];

    // الدخول التلقائي المستقل الخاص بستار جبار
    NSString *savedCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"SatarAuth_SavedCode"];
    if (savedCode && savedCode.length > 0) {
        self.codeField.text = savedCode;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self verifyCode];
        });
    }
}

// حسابات ستار جبار حصراً
- (void)openDev { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/SATAR_50"] options:@{} completionHandler:nil]; }
- (void)openChannel { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/SATAR_70"] options:@{} completionHandler:nil]; }

- (void)verifyCode {
    NSString *userCode = [self.codeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (userCode.length == 0) {
        self.statusLabel.text = @"يرجى إدخال الكود أولاً ✕";
        self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0];
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.welcomeLabel.alpha = 0;
        self.loginBtn.alpha = 0;
        self.iconLabel.alpha = 0;
    }];
    
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    self.statusLabel.text = @"جاري الاتصال بقاعدة البيانات... ⟳";
    self.statusLabel.textColor = [UIColor colorWithRed:0.4 green:0.8 blue:1.0 alpha:1.0];
    [self endEditing:YES];
    
    // سيرفر Vercel الخاص بستار جبار
    NSURL *url = [NSURL URLWithString:@"https://stare-jabare.vercel.app/verify"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *jsonBody = @{@"code": userCode, @"device_id": deviceID};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonBody options:0 error:nil];
    request.HTTPBody = jsonData;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error || !data) {
                [self showErrorState:@"فشل الاتصال، تأكد من الإنترنت ✕"];
                return;
            }
            
            NSError *jsonError;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (jsonError || !jsonResponse) {
                [self showErrorState:@"عطل في سيرفر التحقق ✕"];
                return;
            }
            
            NSString *status = jsonResponse[@"status"];
            NSString *message = jsonResponse[@"message"];
            
            if ([status isEqualToString:@"success"]) {
                [[NSUserDefaults standardUserDefaults] setObject:userCode forKey:@"SatarAuth_SavedCode"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                self.statusLabel.textColor = [UIColor colorWithRed:0.2 green:0.9 blue:0.5 alpha:1.0];
                self.statusLabel.text = @"تم التحقق بنجاح! جاري الدخول... ✓";
                
                self.iconLabel.text = @"✅";
                [UIView animateWithDuration:0.3 animations:^{
                    self.iconLabel.alpha = 1;
                }];
                
                [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.alpha = 0;
                    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
            } else {
                [self showErrorState:message ? message : @"حدث خطأ غير معروف!"];
            }
        });
    }];
    [task resume];
}

- (void)showErrorState:(NSString *)errorMsg {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SatarAuth_SavedCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0];
    self.statusLabel.text = errorMsg;
    
    self.iconLabel.text = @"❌";
    [UIView animateWithDuration:0.3 animations:^{
        self.iconLabel.alpha = 1;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.iconLabel.alpha = 0;
            self.welcomeLabel.alpha = 1;
            self.loginBtn.alpha = 1;
        }];
    });
}
@end


// ==========================================
// 3. الاستدعاء المضمون (الحقن)
// ==========================================
%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig; 
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UIView *targetView = self.view.window;
            if (!targetView) targetView = self.view; 
            
            if (targetView && ![targetView viewWithTag:888888]) {
                SatarAuthView *authAlert = [[SatarAuthView alloc] initWithFrame:targetView.bounds];
                authAlert.tag = 888888;
                authAlert.layer.zPosition = 9999; 
                authAlert.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [targetView addSubview:authAlert];
            }
        });
    });
}
%end


// ==========================================
// 4. تحميل الصورة للقائمة العائمة (خاصة بستار جبار)
// ==========================================
static UIImage *customMenuImage = nil;
static BOOL isFetchingImage = NO;

static UIImage *getCustomMenuImage(void) {
    if (!customMenuImage && !isFetchingImage) {
        isFetchingImage = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // تم توحيد الصورة للقائمة العائمة لتكون خاصة بستار جبار
            NSURL *url = [NSURL URLWithString:@"https://a.top4top.io/p_3916ea7qr1.jpg"];
            NSData *data = [NSData dataWithContentsOfURL:url];
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    customMenuImage = [UIImage imageWithData:data];
                });
            }
        });
    }
    return customMenuImage;
}

static char kHasBeenConfiguredKey;


// ==========================================
// 5. تعديل أزرار اللعبة (UIButton)
// ==========================================
%hook UIButton

- (void)layoutSubviews {
    %orig;
    
    NSNumber *configured = objc_getAssociatedObject(self, &kHasBeenConfiguredKey);
    if ([configured boolValue]) {
        return;
    }

    // --- أ) زر القائمة العائمة ---
    if (self.frame.size.width == 58 && self.frame.size.height == 58) {
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = (UIImageView *)subview;
                if (imageView.frame.size.width >= 30) {
                    UIImage *customImg = getCustomMenuImage();
                    if (customImg) {
                        imageView.image = customImg;
                        imageView.contentMode = UIViewContentModeScaleAspectFit;
                        [self setImage:customImg forState:UIControlStateNormal];
                        self.tintColor = [UIColor clearColor];
                        self.backgroundColor = [UIColor clearColor];
                        objc_setAssociatedObject(self, &kHasBeenConfiguredKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    }
                    return; 
                }
            }
        }
    }

    // --- ب) إخفاء زر "ادعمني بقهوة" ---
    if (self.tag == 404 || [self.currentTitle containsString:@"ادعمني بقهوة"] || (self.frame.size.width == 366 && self.frame.size.height == 48)) {
        self.hidden = YES;
        self.alpha = 0.0;
        self.userInteractionEnabled = NO;
        objc_setAssociatedObject(self, &kHasBeenConfiguredKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    
    // --- ج) زر تويتر / إكس (إلغاء وإخفاء نهائي) ---
    if ([self.currentTitle isEqualToString:@"إكس"] || [self.currentTitle isEqualToString:@"تويتر"]) {
        self.hidden = YES;
        self.alpha = 0.0;
        self.userInteractionEnabled = NO;
        objc_setAssociatedObject(self, &kHasBeenConfiguredKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    
    // --- د) زر قناة المطور ---
    if (self.tag == 401 || [self.currentTitle isEqualToString:@"تيليجرام"] || (self.frame.size.width == 118 && self.frame.size.height == 42)) {
        [self setTitle:@"قناة المطور" forState:UIControlStateNormal];
        self.hidden = NO;
        self.alpha = 1.0;
        self.userInteractionEnabled = YES;
        
        [self removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [self addTarget:self action:@selector(openSatarChannel) forControlEvents:UIControlEventTouchUpInside];
        
        objc_setAssociatedObject(self, &kHasBeenConfiguredKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    
    // --- هـ) زر حساب المطور ---
    if ([self.currentTitle isEqualToString:@"فيسبوك"]) {
        [self setTitle:@"حساب المطور" forState:UIControlStateNormal];
        self.hidden = NO;
        self.alpha = 1.0;
        self.userInteractionEnabled = YES;
        
        [self removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [self addTarget:self action:@selector(openSatarAccount) forControlEvents:UIControlEventTouchUpInside];
        
        objc_setAssociatedObject(self, &kHasBeenConfiguredKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

// دوال توجيه روابط الأزرار
%new
- (void)openSatarChannel {
    NSURL *url = [NSURL URLWithString:@"https://t.me/SATAR_70"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

%new
- (void)openSatarAccount {
    NSURL *url = [NSURL URLWithString:@"https://t.me/SATAR_50"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

%end


// ==========================================
// 6. تعديل النصوص (UILabel) لتكون خاصة بستار جبار
// ==========================================
%hook UILabel

- (void)setText:(NSString *)text {
    if (!text) {
        %orig(text);
        return;
    }

    if (self.tag == 330 || [text containsString:@"المجتمع"]) {
        %orig(@"تواصل مع المطور");
        return;
    }
    
    if ([text isEqualToString:@"i3rby Store"] || self.tag == 11 || [text containsString:@"ايفون بالعربي"]) {
        %orig(@"تطوير ستار جبار");
        return;
    }
    
    if (self.tag == 12 || [text containsString:@"8 ball pool mod"]) {
        %orig(@"ستار جبار - 8 Ball Pool");
        return;
    }
    
    %orig(text);
}

%end


// ==========================================
// 7. إخفاء اللوجو العلوي القديم (UIImageView)
// ==========================================
%hook UIImageView

- (void)layoutSubviews {
    %orig;
    
    if (self.tag == 10 || (self.frame.size.width == 56 && self.frame.size.height == 56)) {
        self.hidden = YES;
    }
}

%end
