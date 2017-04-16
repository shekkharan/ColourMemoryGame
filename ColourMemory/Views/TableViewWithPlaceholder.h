//
//  TableViewWithPlaceholder.h
//  ColourMemory
//
//  Created by Shekhar on 12/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceHolderView.h"

@interface TableViewWithPlaceholder : UITableView

@property (strong,nonatomic) PlaceHolderView *placeholderView;
@property (nonatomic,readonly) BOOL isEmpty;

@end

