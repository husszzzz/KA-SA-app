#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// ==========================================
// 1. تحميل الصورة من الرابط المباشر (SH SHOP)
// ==========================================
static UIImage *customMenuImage = nil;
static BOOL isFetchingImage = NO;

// تم تحويل استدعاء الصورة ليكون غير متزامن (Asynchronous) لكي لا يسبب تجميداً للعبة
static UIImage *getCustomMenuImage(void) {
    if (!customMenuImage && !isFetchingImage) {
        isFetchingImage = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [NSURL URLWithString:@"https://f.top4top.io/p_3915ng3fo1.jpg"];
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
// 2. تعديل الأزرار (UIButton)
// ==========================================
%hook UIButton

- (void)layoutSubviews {
    %orig;
    
    // منع التكرار اللانهائي لكل زر
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
                    return; // نرجع حتى إذا لم تُحمّل الصورة لتطبيقها في الدورة القادمة
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
    
    // --- ج) زر قناة المطور (تليجرام) ---
    if (self.tag == 401 || [self.currentTitle isEqualToString:@"تيليجرام"] || (self.frame.size.width == 118 && self.frame.size.height == 42)) {
        [self setTitle:@"قناة المطور" forState:UIControlStateNormal];
        self.hidden = NO;
        self.alpha = 1.0;
        self.userInteractionEnabled = YES;
        
        [self removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [self addTarget:self action:@selector(openDevChannel) forControlEvents:UIControlEventTouchUpInside];
        
        objc_setAssociatedObject(self, &kHasBeenConfiguredKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    
    // --- د) زر حساب المطور (تليجرام) ---
    if ([self.currentTitle isEqualToString:@"فيسبوك"]) {
        [self setTitle:@"حساب المطور" forState:UIControlStateNormal];
        self.hidden = NO;
        self.alpha = 1.0;
        self.userInteractionEnabled = YES;
        
        [self removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [self addTarget:self action:@selector(openDevAccount) forControlEvents:UIControlEventTouchUpInside];
        
        objc_setAssociatedObject(self, &kHasBeenConfiguredKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }

    // --- هـ) زر تويتر / إكس ---
    if ([self.currentTitle isEqualToString:@"إكس"] || [self.currentTitle isEqualToString:@"تويتر"]) {
        [self setTitle:@"تويتر" forState:UIControlStateNormal];
        self.hidden = NO;
        self.alpha = 1.0;
        self.userInteractionEnabled = YES;
        
        [self removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [self addTarget:self action:@selector(openTwitterAccount) forControlEvents:UIControlEventTouchUpInside];
        
        objc_setAssociatedObject(self, &kHasBeenConfiguredKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

// دوال توجيه الروابط الخارجية
%new
- (void)openDevChannel {
    NSURL *url = [NSURL URLWithString:@"https://t.me/xar_ipa"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

%new
- (void)openDevAccount {
    NSURL *url = [NSURL URLWithString:@"https://t.me/x_arw"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

%new
- (void)openTwitterAccount {
    NSURL *url = [NSURL URLWithString:@"https://x.com/adnansajd?s=11"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

%end

// ==========================================
// 3. تعديل النصوص (UILabel) لتصبح تابعة لـ SH SHOP
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
    
    // إزالة أي إشارة لآيفون بالعربي أو المتجر القديم
    if ([text isEqualToString:@"i3rby Store"] || self.tag == 11 || [text containsString:@"ايفون بالعربي"]) {
        %orig(@"تطوير SH SHOP");
        return;
    }
    
    if (self.tag == 12 || [text containsString:@"8 ball pool mod"]) {
        %orig(@"SH SHOP - 8 Ball Pool");
        return;
    }
    
    %orig(text);
}

%end

// ==========================================
// 4. إخفاء اللوجو العلوي القديم (UIImageView)
// ==========================================
%hook UIImageView

- (void)layoutSubviews {
    %orig;
    
    if (self.tag == 10 || (self.frame.size.width == 56 && self.frame.size.height == 56)) {
        self.hidden = YES;
    }
}

%end
