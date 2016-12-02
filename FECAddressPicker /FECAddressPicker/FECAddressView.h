//
//  FECAddressView.h
//  FECAddressPicker
//
//  Created by mac on 2016/12/1.
//  Copyright © 2016年 Peter. All rights reserved.
//
/**
    AddressAnimationType ： 弹框动画类型
    两个选择方式： showCityView 点击选择按钮选择
                showCityViewWithAutoSlected  滚动自动选择
 */


#import <UIKit/UIKit.h>

// 地址选择器弹框动画
typedef NS_ENUM(NSInteger,AddressAnimationType){
    AddressAnimationTypeAction, // action风格
    AddressAnimationTypeAlert   // alert风格
};

typedef void(^AddressBlock)(NSString *proviceStr,NSString *cityStr,NSString * disStr);

@interface FECAddressView : UIView

- (instancetype)initWithFrame:(CGRect)frame selecteViewTitle:(NSString *)title withAnimationType:(AddressAnimationType)type;

// 点击按钮选择地址
- (void)showCityView:(AddressBlock)selectBlock;
// 滚动自动选择地址
- (void)showCityViewWithAutoSlected:(AddressBlock)selectBlock;
@end
