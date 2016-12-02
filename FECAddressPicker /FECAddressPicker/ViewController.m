//
//  ViewController.m
//  FECAddressPicker
//
//  Created by mac on 2016/12/1.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ViewController.h"
#import "FECAddressView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lb_address;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)selectedAddClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        FECAddressView *view =[[FECAddressView alloc] initWithFrame:self.view.bounds selecteViewTitle:@"FEC地址选择器" withAnimationType:AddressAnimationTypeAlert];
        [view showCityView:^(NSString *proviceStr, NSString *cityStr, NSString *disStr) {
            
            _lb_address.text = [NSString stringWithFormat:@"%@%@%@",proviceStr,cityStr,disStr];
            
        }];
        
//        [view showCityViewWithAutoSlected:^(NSString *proviceStr, NSString *cityStr, NSString *disStr) {
//            
//            _lb_address.text = [NSString stringWithFormat:@"%@%@%@",proviceStr,cityStr,disStr];
//            
//        }];
        
    }else {
        
        FECAddressView *view =[[FECAddressView alloc] initWithFrame:self.view.bounds selecteViewTitle:@"" withAnimationType:AddressAnimationTypeAction];
        
        [view showCityViewWithAutoSlected:^(NSString *proviceStr, NSString *cityStr, NSString *disStr) {
            
            _lb_address.text = [NSString stringWithFormat:@"%@%@%@",proviceStr,cityStr,disStr];
            
        }];
        
//        [view showCityView:^(NSString *proviceStr, NSString *cityStr, NSString *disStr) {
//            
//            _lb_address.text = [NSString stringWithFormat:@"%@%@%@",proviceStr,cityStr,disStr];
//            
//        }];
    }
    
}

@end
