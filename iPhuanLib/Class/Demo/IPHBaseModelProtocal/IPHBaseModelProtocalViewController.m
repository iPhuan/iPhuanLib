//
//  IPHBaseModelProtocalViewController.m
//  iPhuanLib
//
//  Created by iPhuan on 2017/6/14.
//  Copyright © 2017年 iPhuan. All rights reserved.
//

#import "IPHBaseModelProtocalViewController.h"
#import "IPHOverseasHotel.h"

static NSString * const kIPHHotelUserDefaultCacheKey = @"IPHHotelUserDefaultCacheKey";

@interface IPHBaseModelProtocalViewController ()
@property (weak, nonatomic) IBOutlet UITextView *jsonTextView;
@property (strong, nonatomic) IPHOverseasHotel *hotel;


@end

@implementation IPHBaseModelProtocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}



- (IBAction)onButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 11:{
            NSDictionary *dataDic = [self p_dictionaryFromJsonString];
            self.hotel = [[IPHOverseasHotel alloc] initWithIphDictionary:dataDic];
            [self iph_popupAlertViewWithTitle:@"IPHOverseasHotel" message:[_hotel description]];
            break;
        }
        case 12:{
            if (![self p_isHotelInitialized]) {
                return;
            }
            
            NSDictionary *dic = [_hotel iph_toDictionary];
            [self iph_popupAlertViewWithTitle:@"IPHOverseasHotel" message:[dic description]];
            
            break;
        }
        case 13:
            if (![self p_isHotelInitialized]) {
                return;
            }
            // 支持编码后通过archivedData存档
            [[NSUserDefaults standardUserDefaults] setObject:[_hotel iph_archivedData] forKey:kIPHHotelUserDefaultCacheKey];
            [self iph_popupAlertViewWithTitle:@"存档成功！" message:nil];
            break;
        case 14:{
            NSData *hotelData = [[NSUserDefaults standardUserDefaults] objectForKey:kIPHHotelUserDefaultCacheKey];
            self.hotel = [NSKeyedUnarchiver unarchiveObjectWithData:hotelData];
            [self iph_popupAlertViewWithTitle:@"IPHOverseasHotel" message:[_hotel description]];
            break;
        }
        case 15: {
            if (![self p_isHotelInitialized]) {
                return;
            }
            _hotel.country = @"中国";
            IPHOverseasHotel *hotel = [_hotel copy];
            [self iph_popupAlertViewWithTitle:@"IPHOverseasHotel" message:[hotel description]];
            break;
        }
    }
}

- (BOOL)p_isHotelInitialized{
    if (_hotel == nil) {
        [self iph_popupAlertViewWithTitle:@"请先通过initWithIphDictionary初始化IPHHotel" message:@"现在初始化？" handler:^(UIAlertAction *action, NSUInteger index) {
            if (index == 0) {
                NSDictionary *dataDic = [self p_dictionaryFromJsonString];
                self.hotel = [[IPHOverseasHotel alloc] initWithIphDictionary:dataDic];
            }
        } cancelActionTitle:@"取消" otherActionTitles:@"初始化", nil];
        
        return NO;
    }
    return YES;
}

- (NSDictionary *)p_dictionaryFromJsonString{
    NSData *jsonData = [_jsonTextView.text dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = nil;
      NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error != nil) {
        IPHLog(@"Error: %@", [error localizedDescription]);
    }
    
    return dataDic;
}


@end
