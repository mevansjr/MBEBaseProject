//
//  MBEPickerController.m
//  MBEPickerController
//
//  Created by Mark Evans on 9/6/14.
//  Copyright (c) 2014 3Advance, LLC. All rights reserved.
//

#import "MBEPickerController.h"

#define MBE_IS_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface MBEPickerController ()
{
    NSDate *dateSelection;
    NSString *selection;
    NSString *selectionMonth;
    NSString *selectionYear;
    BOOL isTime;
    int pos;
    IBOutlet UIButton *tintButton;
    UIView *bgView;
    NSMutableArray *monthsArray;
    NSMutableArray *yearsArray;
}
@end

@implementation MBEPickerController

- (id)init
{
    MBEPickerController* picker = [self initWithNibName:@"MBEPickerController" bundle:nil];
    return picker;
}


- (void)showInViewController:(UIViewController*)vc
{
    [self.view endEditing:YES];
    
    if (MBE_IS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        _backgroundContainer.hidden = _tintContainer.hidden = YES;
        self.modalPresentationStyle = UIModalPresentationCustom;
    } else {
        _backgroundContainer.image = [self captureView:vc.view];
        _backgroundContainer.alpha = 0.0;
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    bgView = [[UIView alloc] initWithFrame:screenRect];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.0;
    bgView.userInteractionEnabled = NO;
    [vc.view addSubview:bgView];
    
    [UIView animateWithDuration:0.3 animations:^() {
        if ([UIDevice currentDevice].systemVersion.floatValue < 7.1) {
            _backgroundContainer.alpha = 1.0;
        }
        bgView.alpha = 0.5;
    } completion:^(BOOL finished){}];
    
    [vc presentViewController:self animated:YES completion:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPicker];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    CGRect toRect = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView animateWithDuration:0.3 animations:^() {
        self.view.frame = toRect; bgView.alpha = 0.0;
    } completion:^(BOOL finished){}];
}

- (void)setupPicker {
    switch (_pickerTypeState) {
        case PickerTypeText:
            _pickerView.hidden = NO;
            _datePickerView.hidden = YES;
            _monthYearPickerView.hidden = YES;
            break;
            
        case PickerTypeDate:
            _pickerView.hidden = YES;
            _monthYearPickerView.hidden = YES;
            _datePickerView.hidden = NO;
            isTime = NO;
            _datePickerView.datePickerMode = UIDatePickerModeDate;
            break;
            
        case PickerTypeTime:
            _pickerView.hidden = YES;
            _monthYearPickerView.hidden = YES;
            _datePickerView.hidden = NO;
            isTime = YES;
            _datePickerView.datePickerMode = UIDatePickerModeTime;
            break;
            
        case PickerTypeDateTime:
            _pickerView.hidden = YES;
            _monthYearPickerView.hidden = YES;
            _datePickerView.hidden = NO;
            isTime = YES;
            _datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
            break;
            
        case PickerTypeMonthYear:
            _monthYearPickerView.hidden = NO;
            _pickerView.hidden = YES;
            _datePickerView.hidden = YES;
            break;
            
        default:
            break;
    }
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods

- (void)setDateSelection:(id)sender {
    
    UIDatePicker *picker = (UIDatePicker*)sender;
    if (picker != nil) {
        dateSelection = picker.date;
    }
    
}

- (UIImage*)captureView:(UIView *)view {
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - PickerView Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (_pickerTypeState == PickerTypeMonthYear) {
        return 2;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_pickerTypeState == PickerTypeMonthYear) {
        NSInteger rowsInComponent;
        if (component==0)
        {
            rowsInComponent=[monthsArray count];
        }
        else
        {
            rowsInComponent=[yearsArray count];
        }
        return rowsInComponent;
    }
    
    if (_pickerOptions != nil) {
        if (_pickerOptions.count > 0) {
            return _pickerOptions.count;
        }
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_pickerTypeState == PickerTypeMonthYear) {
        NSString * nameInRow;
        if (component==0)
        {
            nameInRow=[monthsArray objectAtIndex:row];
        }
        else  if (component==1)
        {
            nameInRow=[yearsArray objectAtIndex:row];
        }
        
        return nameInRow;
    }
    
    if (_pickerOptions != nil) {
        if (_pickerOptions.count > 0) {
            return _pickerOptions[row];
        }
    }
    return nil;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (_pickerTypeState == PickerTypeMonthYear) {
        CGFloat componentWidth ;
        
        if (component == 0)
        {
            componentWidth = 100;
        }
        else  {
            componentWidth = 100;
        }
        
        return componentWidth;
    }
    return pickerView.frame.size.width;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_pickerTypeState == PickerTypeMonthYear) {
        
        if (component == 0)
        {
            selectionMonth = [monthsArray objectAtIndex:row];
        }
        else  if (component == 1)
        {
            selectionYear = [yearsArray objectAtIndex:row];
        }
        
        NSDateFormatter *monFormatter = [[NSDateFormatter alloc] init];
        monFormatter.dateFormat = @"MM";
        
        NSDateFormatter *fromFormatter = [[NSDateFormatter alloc] init];
        fromFormatter.dateFormat = @"MMM";
        
        NSString *m = selectionMonth;
        if (selectionMonth.length == 3) {
            m = [monFormatter stringFromDate:[fromFormatter dateFromString:selectionMonth]];
        }
        
        selection = [NSString stringWithFormat:@"%@/%@", m, selectionYear];
        pos = (int)row;
        
        return;
    }
    if (_pickerOptions != nil) {
        if (_pickerOptions.count > 0) {
            selection = _pickerOptions[row];
            pos = (int)row;
        }
    }
}

#pragma mark - UI Methods

- (void)setupUI {
    
    pos = 0;
    
    if (_selectDate != nil) {
        if (_datePickerView != nil) {
            [_datePickerView setDate:_selectDate];
        }
    }
    
    if (!_showPast) {
        _datePickerView.minimumDate = [NSDate date];
    }
    
    if (_disableFuture) {
        _datePickerView.maximumDate = [NSDate date];
    }
    
    if (_datePickerView != nil) {
        dateSelection = _datePickerView.date;
        [_datePickerView addTarget:self action:@selector(setDateSelection:) forControlEvents:UIControlEventValueChanged];
    }
    
    if (_pickerOptions != nil) {
        if (_pickerOptions.count > 0) {
            selection = _pickerOptions[0];
        }
    }
    
    if (_pickerTitle != nil) {
        if (_pickerTitle.length > 0) {
            _titleContainer.hidden = NO;
            _titleLabel.text = _pickerTitle;
        }
    }
    
    if (_selectOption != nil) {
        if(_selectOption.length > 0) {
            if (_pickerOptions != nil) {
                if (_pickerOptions.count > 0) {
                    for (NSString *s in _pickerOptions) {
                        if ([_selectOption isEqualToString:s]) {
                            if (_pickerView != nil)
                                selection = _pickerOptions[pos];
                            [_pickerView selectRow:pos inComponent:0 animated:YES];
                            break;
                        }
                        pos++;
                    }
                }
            }
        }
    }
    
    if (_pickerTypeState == PickerTypeMonthYear) {
        if (_monthYearPickerView != nil) {
            //Array for picker view
            monthsArray = [[NSMutableArray alloc]initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
            
            NSDateFormatter *monFormatter = [[NSDateFormatter alloc] init];
            monFormatter.dateFormat = @"MM";
            
            NSDateFormatter *fromFormatter = [[NSDateFormatter alloc] init];
            fromFormatter.dateFormat = @"MMM";
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy"];
            NSString *yearString = [formatter stringFromDate:[NSDate date]];
            
            
            yearsArray = [NSMutableArray new];
            
            for (int i=0; i<13; i++)
            {
                [yearsArray addObject:[NSString stringWithFormat:@"%d",[yearString intValue]+i]];
            }
            
            _monthYearPickerView.delegate = self;
            _monthYearPickerView.showsSelectionIndicator = YES;
            
            selectionMonth = monthsArray.firstObject;
            selectionYear = yearsArray.firstObject;
            
            NSString *fSelectedMonth = [fromFormatter stringFromDate:[monFormatter dateFromString:selectionMonth]];
            
            int monthPos = 0;
            int yearPos = 0;
            
            if (_selectOption && _selectOption.length > 0) {
                NSArray *optionSet = [ _selectOption componentsSeparatedByString:@"/"];
                if (optionSet && optionSet.count > 1) {
                    selectionMonth = optionSet.firstObject;
                    selectionYear = optionSet.lastObject;
                    fSelectedMonth = [fromFormatter stringFromDate:[monFormatter dateFromString:selectionMonth]];
                    
                    int mI = 0;
                    for (NSString *m in monthsArray) {
                        if ([m isEqualToString:fSelectedMonth]) {
                            monthPos = mI;
                            break;
                        }
                        mI++;
                    }
                    int yI = 0;
                    for (NSString *y in yearsArray) {
                        if ([y isEqualToString:selectionYear]) {
                            yearPos = yI;
                            break;
                        }
                        yI++;
                    }
                }
            }
            
            selection = [NSString stringWithFormat:@"%@/%@", [monFormatter stringFromDate:[fromFormatter dateFromString:selectionMonth]], selectionYear];
            
            [_monthYearPickerView selectRow:monthPos inComponent:0 animated:NO];
            [_monthYearPickerView selectRow:yearPos inComponent:1 animated:NO];
        }
    }
    
    _selectButton.layer.cornerRadius = _cancelButton.layer.cornerRadius = _pickerContainer.layer.cornerRadius = _titleContainer.layer.cornerRadius = 10.0;
    
}

#pragma mark - IBAction Methods

- (IBAction)dismissPickerView {
    if (!self.isBeingDismissed || !self.isBeingPresented) {
        [self dismissViewControllerAnimated:YES completion:^{
            selection = nil;
            dateSelection = nil;
            selection = @"";
            dateSelection = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_pickerView.hidden && _monthYearPickerView.hidden) {
                    _dateSelected(dateSelection);
                } else if (_pickerView.hidden) {
                    _optionSelected(selection);
                } else {
                    _optionSelected(selection);
                }
            });
        }];
    }
}

- (IBAction)select:(id)sender {
    if (!self.isBeingDismissed || !self.isBeingPresented) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (_pickerTypeState == PickerTypeText) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _optionSelected(selection);
                });
            } else if (_pickerTypeState == PickerTypeMonthYear) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _optionSelected(selection);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _dateSelected(dateSelection);
                });
            }
        }];
    }
}

- (IBAction)cancel:(id)sender {
    if (!self.isBeingDismissed || !self.isBeingPresented) {
        [self dismissViewControllerAnimated:YES completion:^{
            selection = nil;
            dateSelection = nil;
            selection = @"";
            dateSelection = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_pickerView.hidden && _monthYearPickerView.hidden) {
                    _dateSelected(dateSelection);
                } else if (_pickerView.hidden) {
                    _optionSelected(selection);
                } else {
                    _optionSelected(selection);
                }
            });
        }];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

@end
