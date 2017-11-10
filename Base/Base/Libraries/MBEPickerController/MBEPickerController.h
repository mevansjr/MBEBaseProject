//
//  MBEPickerController.h
//  MBEPickerController
//
//  Created by Mark Evans on 9/6/14.
//  Copyright (c) 2014 3Advance, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    PickerTypeMonthYear= 4,
    PickerTypeDateTime = 3,
    PickerTypeTime = 2,
    PickerTypeDate = 1,
    PickerTypeText = 0
};
typedef NSInteger PickerTypeInt;

@interface MBEPickerController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

- (void)showInViewController:(UIViewController*)vc;

@property (nonatomic, strong) NSMutableArray *pickerOptions;
@property (nonatomic, strong) NSString *pickerTitle;
@property (nonatomic, strong) NSString *selectOption;
@property (nonatomic, strong) NSDate *selectDate;
@property (nonatomic, assign) BOOL showPast;
@property (nonatomic, assign) BOOL disableFuture;
@property (nonatomic, assign) PickerTypeInt pickerTypeState;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIButton *selectButton;
@property (nonatomic, strong) IBOutlet UIView *titleContainer;
@property (nonatomic, strong) IBOutlet UIView *tintContainer;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundContainer;
@property (nonatomic, strong) IBOutlet UIView *pickerContainer;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) IBOutlet UIPickerView *monthYearPickerView;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePickerView;
@property (nonatomic, copy) void (^optionSelected)(NSString *selection);
@property (nonatomic, copy) void (^dateSelected)(NSDate *selectedDate);

@end
