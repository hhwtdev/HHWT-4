//
//  PopView.h
//  MyPopOverExample
//
//  Created by Velmurugan on 06/12/15.
//  Copyright © 2015 Velmurugan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopView;

@protocol PopViewDelegate <NSObject>
-(void)popViewDidDismiss:(PopView *)popView;
-(void)popView:(PopView *)popView didSelectedAtIndex:(NSUInteger)selectedIndex;

@end

@interface PopView : UIView
@property(assign,nonatomic)id<PopViewDelegate> delegate;
@property (nonatomic, assign) BOOL isCategoryPopup;
@property (nonatomic, assign) BOOL isCountryPopUp;
@property (nonatomic, assign) CGRect rectCountry;


+(PopView *)loadNib;
-(void)setUPMenu;
-(void)showMenuForView:(UIView *)toView;
-(void)loadData:(NSArray*)data;
-(void)updateData:(NSArray*)data;
-(void)removePopUP;
@end
