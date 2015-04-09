//
//  MyCalendarItem.m
//  HYCalendar
//
//  Created by nathan on 14-9-17.
//  Copyright (c) 2014年 nathan. All rights reserved.
//

#import "CKCalendarView.h"

@implementation CKCalendarView
{
    UIButton  *_selectButton;
    NSMutableArray *_daysArray;
    UIView *bgview;
    UIView *weekBg;
    UILabel *headlabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        bgview = [[UIView alloc] initWithFrame:CGRectZero];
        weekBg = [[UIView alloc] initWithFrame:CGRectZero];
        headlabel = [[UILabel alloc] initWithFrame:CGRectZero];
        bgview.layer.borderWidth = 1.5f;
        bgview.layer.borderColor = [[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1] CGColor];
        _daysArray = [NSMutableArray arrayWithCapacity:42];
        for (NSInteger i = 0; i < 42; i++) {
            UIButton *button = [[UIButton alloc] init];
            [_daysArray addObject:button];
            [bgview addSubview:button];
        }
        [self addSubview:bgview];
        [self addSubview:weekBg];
        [self addSubview:headlabel];
    }
    return self;
}

#pragma mark - date

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}


- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

#pragma mark - create View
- (void)setDate:(NSDate *)date{
    _date = date;
    
    [self createCalendarViewWith:date];
}

- (void)createCalendarViewWith:(NSDate *)date{
    
    CGFloat itemW     = self.frame.size.width / 7;
    CGFloat itemH     = self.frame.size.height / 8;
    
    // 1.year month
    headlabel.text     = [NSString stringWithFormat:@"%zi年%zi月%zi日",[self year:date],[self month:date],[self day:date]];
    headlabel.font     = [UIFont systemFontOfSize:14];
    headlabel.frame           = CGRectMake(0, 0, self.frame.size.width, itemH);
    headlabel.layer.borderColor = [[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1] CGColor];
    headlabel.layer.borderWidth = 1.5f;
    [headlabel setTextColor:[UIColor colorWithRed:0.98 green:0.28 blue:0.41 alpha:1]];
    headlabel.textAlignment   = NSTextAlignmentCenter;
    
    // 2.weekday
    NSArray *array = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    weekBg.backgroundColor = [UIColor whiteColor];
    weekBg.frame = CGRectMake(1, CGRectGetMaxY(headlabel.frame), self.frame.size.width-2, itemH);
    
    for (NSInteger i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:14];
        week.frame    = CGRectMake(itemW * i, 0, itemW-2/7, itemH);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor clearColor];
        week.textColor       = [UIColor colorWithRed:0.98 green:0.32 blue:0.43 alpha:1];
        [weekBg addSubview:week];
    }
    
    //  3.days (1-31)
    for (NSInteger i = 0; i < 42; i++) {
        NSInteger x = (i % 7) * itemW+2;
        NSInteger y = (i / 7) * itemH + CGRectGetMaxY(weekBg.frame);
        
        UIButton *dayButton = _daysArray[i];
        dayButton.frame = CGRectMake(x, y, itemW-5, itemH);
        dayButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        dayButton.layer.cornerRadius = 5.0f;
        [dayButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [dayButton setUserInteractionEnabled:NO];
        //[dayButton addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
        
        NSInteger daysInLastMonth = [self totaldaysInMonth:[self lastMonth:date]];
        NSInteger daysInThisMonth = [self totaldaysInMonth:date];
        NSInteger firstWeekday    = [self firstWeekdayInThisMonth:date];
        
        NSInteger day = 0;
        
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            [self setStyle_AfterToday:dayButton];
        }
        
        [dayButton setTitle:[NSString stringWithFormat:@"%zi", day] forState:UIControlStateNormal];
        
        // this month
        if ([self month:date] == [self month:[NSDate date]]) {
            NSInteger todayIndex = [self day:date] + firstWeekday - 1;
            if (i < todayIndex && i >= firstWeekday) {
                [self setStyle_BeforeToday:dayButton];
                
            }else if(i ==  todayIndex){
                [self setStyle_Today:dayButton];
            }
        }
    }
    [bgview setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

#pragma mark - output date
-(void)logDate:(UIButton *)dayBtn
{
    _selectButton.selected = NO;
    dayBtn.selected = YES;
    _selectButton = dayBtn;
    
    NSInteger day = [[dayBtn titleForState:UIControlStateNormal] integerValue];
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    
    if (self.calendarBlock) {
        self.calendarBlock(day, [comp month], [comp year]);
    }
}

#pragma mark - signDate
-(void)layoutSign:(NSInteger)signDay{
    for (UIButton *btn in _daysArray) {
        NSInteger day = [[btn titleForState:UIControlStateNormal] integerValue];
        if (signDay == day && btn.enabled) {
            [self setStyle_SignDay:btn];
            break;
        }
    }
}

#pragma mark - date button style

- (void)setStyle_BeyondThisMonth:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

- (void)setStyle_BeforeToday:(UIButton *)btn
{
    btn.enabled = YES;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

-(void)setStyle_SignDay:(UIButton *)btn{
    NSInteger day = [[btn titleForState:UIControlStateNormal] integerValue];
    if ([self day:self.date] == day) {
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    }
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(btn.frame.origin.x+3, btn.frame.origin.y+3, btn.frame.size.width-10, btn.frame.size.height-10);
    [btn setBackgroundImage:[UIImage imageNamed:@"sign_icon"] forState:UIControlStateNormal];
}

- (void)setStyle_Today:(UIButton *)btn
{
    btn.enabled = YES;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
}

- (void)setStyle_AfterToday:(UIButton *)btn
{
    btn.enabled = YES;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


@end
