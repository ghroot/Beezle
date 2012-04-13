//
//  BeeGlassHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeGlassHandler.h"
#import "BeeComponent.h"
#import "BeeType.h"
#import "Collision.h"
#import "NotificationTypes.h"
#import "SoundManager.h"

@implementation BeeGlassHandler

-(BOOL) handleCollision:(Collision *)collision
{
    Entity *beeEntity = [collision firstEntity];
    Entity *glassEntity = [collision secondEntity];
    
    [[SoundManager sharedManager] playSound:@"BeeHitGlass"];
    
    // TODO: This should be generic to the "crumble" component
    BeeComponent *beeComponent = [BeeComponent getFrom:beeEntity];
    if ([beeComponent type] == [BeeType SUMEE] &&
        [collision firstEntityVelocityTimesMass] >= 150)
    {
        NSDictionary *notificationUserInfo = [NSDictionary dictionaryWithObject:glassEntity forKey:@"entity"];
        [[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_ENTITY_CRUMBLED object:self userInfo:notificationUserInfo];
        
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}

@end
