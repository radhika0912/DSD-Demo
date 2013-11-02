//
//  ViewController.h
//  DSD Demo
//
//  Created by Shweta on 26/10/13.
//  Copyright (c) 2013 Quinnox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodayInfoViewController.h"
#import "CustomerListViewController.h"
#import "SODViewControllerViewController.h"
#import "EODViewControllerViewController.h"
#import "Constants.h"

@interface ViewController : UIViewController
{
    int tagNoButtonSelected;
    TodayInfoViewController *todayTableViewController;
    CustomerListViewController *customerViewC;
    SODViewControllerViewController *sodViewController;
    EODViewControllerViewController *eodViewController;
}
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIButton *btn_Today;
@property (strong, nonatomic) IBOutlet UIButton *btn_SOD;
@property (strong, nonatomic) IBOutlet UIButton *btn_ServiceOutlet;
@property (strong, nonatomic) IBOutlet UIButton *btn_transactionSummary;
@property (strong, nonatomic) IBOutlet UIButton *btn_EOD;

@end
