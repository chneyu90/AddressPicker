//
//  FECAddressView.m
//  FECAddressPicker
//
//  Created by mac on 2016/12/1.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "FECAddressView.h"

#define kViewW self.frame.size.width
#define kViewH self.frame.size.height
#define kBtnW 60
#define kToolH 40
#define kBjViewH  220

@interface FECAddressView () <UIPickerViewDelegate,UIPickerViewDataSource>
// 工具栏和 pickview 的容器
@property (nonatomic, strong) UIView *BJview;
@property (nonatomic, strong) UIView *tool;
@property (nonatomic, strong) UIPickerView *pickView;
// 所有省份城市区的数组
@property (nonatomic, copy) NSArray *allArr;

@property (nonatomic, strong) NSMutableArray *provinceAry;
@property (nonatomic, strong) NSMutableArray *cityAry;
@property (nonatomic, strong) NSMutableArray *disAry;

@property (nonatomic, assign) NSInteger proIndex;
@property (nonatomic, assign) NSInteger cityIndex;
@property (nonatomic, assign) NSInteger disIndex;

@property (nonatomic, copy) AddressBlock addBlock;
@property (nonatomic, copy) AddressBlock autoBlock;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) AddressAnimationType type;
@end

@implementation FECAddressView

- (instancetype)initWithFrame:(CGRect)frame selecteViewTitle:(NSString *)title withAnimationType:(AddressAnimationType)type {
    if (self == [super initWithFrame:frame]) {
        _title = title;
        _type = type;
        // 解析数据 plist
        [self parseData];
        // 初始化UI
        [self setupUIViews];
    }
    return self;
}

- (void)parseData {
    _provinceAry = [NSMutableArray array];
    _cityAry = [NSMutableArray array];
    _disAry = [NSMutableArray array];
    
    _allArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"]];
    if (_allArr.count == 0) {
        NSLog(@"无相关数据");
    }
    
    for (NSDictionary *dict in _allArr) {
        [_provinceAry addObjectsFromArray:[dict allKeys]];
        
        if ([dict objectForKey:_provinceAry[_proIndex]]) {
            _cityAry = [NSMutableArray arrayWithArray:[[dict objectForKey:_provinceAry[_proIndex]] allKeys]];
            
            _disAry = [NSMutableArray arrayWithArray:[[dict objectForKey:_provinceAry[_proIndex]] objectForKey:_cityAry[0]]];
        }
    }
    
}

- (void)setupUIViews {
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }];
    
    // 背景view
    _BJview = [[UIView alloc] initWithFrame:CGRectMake(0, kViewH, kViewW   , kBjViewH)];
    [self addSubview:_BJview];
    
    // 工具栏
    _tool = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kViewW, kToolH)];
    _tool.backgroundColor = [UIColor colorWithRed:237/255.0 green:236/255.0 blue:234/255.0 alpha:1.0]; //[UIColor whiteColor];
    [_BJview addSubview:_tool];
    
    // tool上的按钮
    if (_type == AddressAnimationTypeAlert) {
        [self addToolBtnsWithFrame:CGRectMake(0, 0, _tool.frame.size.width/2, kToolH) title:@"取消" tag:10];
        [self addToolBtnsWithFrame:CGRectMake(_tool.frame.size.width/2, 0, _tool.frame.size.width/2, kToolH) title:@"选择" tag:11];
    }else {
        [self addToolBtnsWithFrame:CGRectMake(0, 0, kBtnW, kToolH) title:@"取消" tag:10];
        [self addToolBtnsWithFrame:CGRectMake(kViewW-kBtnW, 0, kBtnW, kToolH) title:@"选择" tag:11];
        // 标题
        UILabel *titeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kBtnW, 0, kViewW - (kBtnW * 2), kToolH)];
        titeLabel.text = _title;
        titeLabel.textColor = [UIColor darkGrayColor];
        titeLabel.textAlignment = NSTextAlignmentCenter;
        titeLabel.font = [UIFont systemFontOfSize:16];
        [_tool addSubview:titeLabel];
        
    }
    
    // pickView选择器
    // CGRectMake(0, kToolH, kViewW, kBjViewH-kToolH)
    _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kViewW, kBjViewH)];
    _pickView.delegate = self;
    _pickView.dataSource = self;
    _pickView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    [_BJview addSubview:_pickView];
    [_BJview sendSubviewToBack:_pickView];
    // 加这句可出现中间的两根选择状态横向，屏蔽可取消
    [_pickView selectRow:0 inComponent:0 animated:YES];
    
    // alert 布局
    if (_type == AddressAnimationTypeAlert) {
        _BJview.frame = CGRectMake(15, (kViewH - kBjViewH)/2, kViewW-30, kBjViewH);
        _BJview.layer.cornerRadius = 5.0f;
        _BJview.layer.masksToBounds = YES;
        
        _pickView.frame = CGRectMake(0, 0, _BJview.frame.size.width, kBjViewH-kToolH);
        _pickView.backgroundColor = [UIColor whiteColor];
        _tool.frame = CGRectMake(0, CGRectGetMaxY(_pickView.frame), _BJview.frame.size.width, kToolH);
    }
    
}

- (void)addToolBtnsWithFrame:(CGRect)rect title:(NSString *)btnTitle    tag:(NSInteger)tag {
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.tag = tag;
    cancelBtn.frame = rect;
    [cancelBtn setTitle:btnTitle forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_tool addSubview:cancelBtn];
}

- (void)btnClick:(UIButton *)sender {
    
    if (sender.tag == 11) { // 选择
        if (_addBlock) {
            _addBlock(_provinceAry[_proIndex],_cityAry[_cityIndex],_disAry[_disIndex]);
        }
        
        if (self.autoBlock) {
            _autoBlock(_provinceAry[_proIndex],_cityAry[_cityIndex],_disAry[_disIndex]);
        }
    }
    
    [self hiddenMethod];
}

#pragma mark - 隐藏和显示相关
- (void)hiddenMethod {
    __weak typeof (self) weakSelf = self;
    __weak typeof (UIView *)weakBJView = _BJview;
    __block NSInteger BlockH = kViewH;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect bjViewFrame = weakBJView.frame;
        bjViewFrame.origin.y = BlockH;
        weakBJView.frame = bjViewFrame;
        weakSelf.alpha = 0.1;
        
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)showMethod {
    __weak typeof (UIView *)weakBJView = _BJview;
    __block NSInteger BlockH = kViewH;
    __block NSInteger BlockBjH = kBjViewH;
    if (self.type == AddressAnimationTypeAlert) {
        // alert动画
        _BJview.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:10 options:UIViewAnimationOptionOverrideInheritedOptions animations:^{
            weakBJView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];
        
    }else {
        // action动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect bjViewFrame = weakBJView.frame;
            bjViewFrame.origin.y = BlockH-BlockBjH;
            weakBJView.frame = bjViewFrame;
        }];
        
    }
}

- (void)showCityView:(AddressBlock)selectBlock {
    self.addBlock = selectBlock;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self showMethod];
}

- (void)showCityViewWithAutoSlected:(AddressBlock)selectBlock {
    self.autoBlock = selectBlock;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self showMethod];
}

#pragma mark - pickView的代理和数据源
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *lb = [UILabel new];
    lb.numberOfLines = 0;
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = [UIFont systemFontOfSize:16];
    lb.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return lb;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return _provinceAry[row];
    }else if (component == 1) {
        return _cityAry[row];
    }else if (component == 2){
        return _disAry[row];
    }
    return nil;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _provinceAry.count;
    }else if (component == 1) {
        return _cityAry.count;
    }else if (component == 2){
        return _disAry.count;
    }
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  3;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) { // 省份
        _proIndex = row;
        _cityIndex = 0;
        _disIndex = 0;
        
        NSDictionary *dict = [_allArr objectAtIndex:row];
        if ([dict objectForKey:_provinceAry[_proIndex]]) {
            _cityAry = [NSMutableArray arrayWithArray:[[dict objectForKey:_provinceAry[_proIndex]] allKeys]];
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            
            _disAry = [NSMutableArray arrayWithArray:[[dict objectForKey:_provinceAry[_proIndex]] objectForKey:_cityAry[0]]];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
        }
        
    }
    
    if (component == 1) { // 城市
        _cityIndex = row;
        _disIndex = 0;
        NSDictionary *dict = [_allArr objectAtIndex:_proIndex];
        
        if ([dict objectForKey:_provinceAry[_proIndex]]) {
            _disAry = [[dict objectForKey:_provinceAry[_proIndex]] objectForKey:_cityAry[_cityIndex]];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
        
    }
    
    if (component == 2) {
        _disIndex = row;
    }
    
    if (self.autoBlock) {
        self.autoBlock(_provinceAry[_proIndex],_cityAry[_cityIndex],_disAry[_disIndex]);
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.type == AddressAnimationTypeAction) {
        CGPoint point = [[touches anyObject] locationInView:self];
        if (!CGRectContainsPoint(_BJview.frame, point)) {
            [self hiddenMethod];
        }
    }
    
}

@end
