//
//  Member.h
//  RuiSi
//
//  Created by 汪泽伟 on 2016/12/1.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "BaseModel.h"

@interface Member : BaseModel
@property (nonatomic,copy) NSString *memberUid;
@property (nonatomic,copy) NSString *memberName;
@property (nonatomic,copy) NSString *memberAvatarSmall;
@property (nonatomic,copy) NSString *memberAvatarMiddle;
//@property (nonatomic,copy) NSString *memberAvatarBig;
@property (nonatomic,copy) NSString *memberCoins;
@property (nonatomic,copy) NSString *memberCredicts;
@property (nonatomic,copy) NSString *memberUploads;
@property (nonatomic,copy) NSString *memberDownloads;
@property (nonatomic,copy) NSString *memberTorrents;
@property (nonatomic,copy) NSString *memberChip;// 筹码
@property (nonatomic,copy) NSString *memberRatio;// 保种度
@property (nonatomic,copy) NSString *memberPin;//人品
//@property (nonatomic,copy) NSString *memberSex;//
//@property (nonatomic,copy) NSString *memberBirthday;//
//@property (nonatomic,copy) NSString *memberBirthplace;//
@property (nonatomic,copy) NSString *memberHomepage;


+ (Member *) getMemberWithHomepage:(NSString *)homepage;
@end
