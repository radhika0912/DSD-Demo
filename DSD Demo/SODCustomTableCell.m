//
//  SODCustomTableCell.m
//  NewProject
//
//  Created by ITIM Quinnox on 30/10/13.
//  Copyright (c) 2013 q-systems@quinnox.com. All rights reserved.
//

#import "SODCustomTableCell.h"
#import "AppDelegate.h"

#define OFFSET_FIELDS       5
#define WIDTH_FLAG          20
#define HEIGHT_FLAG         20
#define HEIGHT_FIELDS       22
#define HEIGHT_TXT_FIELD    44
#define WIDTH_COUNT_FIELDS  100
#define WIDTH_ACCEPT_BUTTON 100
#define HEIGHT_ACCEPT_BUTTON 34

@implementation SODCustomTableCell
@synthesize txtFieldActualCount = _txtFieldActualCount, enumViewType = _enumViewType;
NSString *arrReturnItems[4] = {@"Expired Crate", @"Empty bottle Crate", @"Broken Bottles", @"Incorrect Crate"};

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
- (id)initWithFrame:(CGRect)frame
{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self = [super initWithFrame:frame];
    UIColor *colorBG = [UIColor clearColor];
    if (self) {
        // Initialization code
        _lblMatID = [[UILabel alloc] initWithFrame:CGRectMake(2*OFFSET_FIELDS, OFFSET_FIELDS, 200, HEIGHT_FIELDS)];
        _lblMatID.font = [UIFont boldSystemFontOfSize:18.0];
        _lblMatID.backgroundColor = colorBG;
        
        _lblMatDesc = [[UILabel alloc] initWithFrame:CGRectMake(2*OFFSET_FIELDS, _lblMatID.frame.origin.y + _lblMatID.frame.size.height, 300, HEIGHT_FIELDS)];
        _lblMatDesc.font = [UIFont systemFontOfSize:14.0];
        _lblMatDesc.textColor = [UIColor grayColor];
        _lblMatDesc.backgroundColor = colorBG;
        
//        _imgViewDiscFlag = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - OFFSET_FIELDS - WIDTH_FLAG, frame.size.height/2 - HEIGHT_FLAG/2, WIDTH_FLAG, HEIGHT_FLAG)];
//        _imgViewDiscFlag.backgroundColor = colorBG;
//        
        _lblMatPlannedQty = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - WIDTH_COUNT_FIELDS - 2*OFFSET_FIELDS, frame.size.height/2 - HEIGHT_FLAG/2, WIDTH_COUNT_FIELDS, HEIGHT_FIELDS)];
        _lblMatPlannedQty.textAlignment = NSTextAlignmentRight;
        _lblMatPlannedQty.backgroundColor = colorBG;
        
        _txtFieldActualCount = [[UITextField alloc] initWithFrame:CGRectMake(_lblMatPlannedQty.frame.origin.x - WIDTH_COUNT_FIELDS - OFFSET_FIELDS, frame.size.height/2 - HEIGHT_TXT_FIELD/2, WIDTH_COUNT_FIELDS, HEIGHT_TXT_FIELD)];
        _txtFieldActualCount.borderStyle = UITextBorderStyleLine;
        _txtFieldActualCount.backgroundColor = colorBG;
        _txtFieldActualCount.keyboardType = UIKeyboardTypeNumberPad;
        _txtFieldActualCount.delegate = self;
        [_txtFieldActualCount addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
        
        _btnAccept = [[UIButton alloc] initWithFrame:CGRectMake(_txtFieldActualCount.frame.origin.x - WIDTH_ACCEPT_BUTTON - OFFSET_FIELDS, _txtFieldActualCount.frame.size.height/2 - HEIGHT_ACCEPT_BUTTON/2, WIDTH_ACCEPT_BUTTON, HEIGHT_ACCEPT_BUTTON)];
        [_btnAccept setTitle:@"Accept" forState:UIControlStateNormal];
        [_btnAccept addTarget:self action:@selector(acceptButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _btnAccept.backgroundColor = colorBG;
        _btnAccept.hidden = YES;
        
        [self addSubview:_lblMatID];
        [self addSubview:_lblMatDesc];
        [self addSubview:_txtFieldActualCount];
        [self addSubview:_lblMatPlannedQty];
        [self addSubview:_btnAccept];
//        [self addSubview:_imgViewDiscFlag];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataForRow:(int)indexID forOrder:(Order*)orderItem{
    _index = indexID;
    _lblMatID.text = orderItem.matNo;
    _lblMatDesc.text = orderItem.matDesc;
    _lblMatPlannedQty.text = [NSString stringWithFormat:@"%d",orderItem.reqrdQty];
    _txtFieldActualCount.text = @""; //[NSString stringWithFormat:@"%d", enteredValues[_index]];
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)setDataReturns:(NSDictionary*)dict :(int)indexID {
    _lblMatID.text = [dict valueForKey:@"item"];
    _lblMatDesc.text = [dict valueForKey:@"desc"];
    _txtFieldActualCount.text = [dict valueForKey:@"value"];
    _index = indexID;
}

- (void)setData:(int)indexID :(int)colorIndex {
    if (_enumViewType == RETURNS) {
        _lblMatID.text = arrReturnItems[indexID];
        _returnsIndex = colorIndex;
        _index = indexID;
        return;
    }
    _index = indexID;
    NSDictionary *dictionaryObject = [arrOrders objectAtIndex:_index];
    _lblMatID.text = [dictionaryObject valueForKey:JSONTAG_MAT_NO];
    _lblMatDesc.text = [dictionaryObject valueForKey:JSONTAG_MAT_DESC];
    _lblMatPlannedQty.text = [dictionaryObject valueForKey:JSONTAG_MAT_ACTUAL_COUNT];
    
    switch (_enumViewType) {
        case SOD:
            _txtFieldActualCount.text = [NSString stringWithFormat:@"%d", enteredValues[_index]];
            break;
        case EOD: {
            AppDelegate *appObject = (AppDelegate*)([[UIApplication sharedApplication] delegate]);
            NSLog(@"appObject.rowCustomerListSelected :: %d", appObject.rowCustomerListSelected);
            _txtFieldActualCount.text = [NSString stringWithFormat:@"%d", deliveredValues[appObject.rowCustomerListSelected][_index]];
            break;
        }
        default:
            _txtFieldActualCount.text = @"";
            break;
    }
    

    
    switch (colorIndex) {
        case 0: {
            self.backgroundColor = [UIColor whiteColor];
            break;
        }
        case 1: {
            self.backgroundColor = COLOR_ERROR;
            if (acceptedValues[_index] != 1) {
                _btnAccept.hidden = NO;
            }
            break;
        }
        case 2: {
            self.backgroundColor = [UIColor lightGrayColor];
            break;
        }
    }
}
    
- (void)textFieldDidChange {
//    NSLog(@"_txtFieldActualCount.text :: %@", _txtFieldActualCount.text);
    if (_enumViewType == SOD) {
        enteredValues[_index] = [_txtFieldActualCount.text intValue];
    }
    if (_enumViewType == RETURNS) {
        returnsValues[_returnsIndex][_index] = [_txtFieldActualCount.text intValue];
        NSLog(@"%d -- %d", _returnsIndex, _index);
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
//    NSLog(@"did end editing textValue:%@",textField.text);
     NSLog(@"index:%d value:%@",_index,_txtFieldActualCount.text);
    
    int indexValue = _index;
    [NSString stringWithFormat:@"%d",indexValue];
//        [NSString stringWithFormat:@"%d",]
//    int countValue = [_txtFieldActualCount.text intValue];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_txtFieldActualCount.text,[NSString stringWithFormat:@"%d",indexValue], nil]
        forKeys:[NSArray arrayWithObjects:@"placedQty",@"indexPath", nil]];
    
        [[NSNotificationCenter defaultCenter] postNotificationName:nSoldQtyUpdate object:nil  userInfo:dict];
}
- (void)acceptButtonClicked {
    acceptedValues[_index] = 1;
    self.backgroundColor = [UIColor lightGrayColor];
    _btnAccept.hidden = YES;
}
@end
