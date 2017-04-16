//
//  PlaceHolderView.h
//  ColourMemory
//
//  Created by Shekhar on 12/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APRoundedButton.h"

typedef void (^PlaceholderActionBlock) ();

@interface PlaceholderData : NSObject

@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *buttonText;
@property (strong, nonatomic) NSString *imageName;
@end


@interface PlaceHolderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet APRoundedButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (copy, nonatomic) PlaceholderActionBlock actionButtonBlock;

- (id)initWithFrame:(CGRect)frame placeholderData:(PlaceholderData *)placeholderData;


@end
