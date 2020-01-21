//
//  NetworkExtesionPrivate.m
//  VPN
//
//  Created by apple on 2020/1/20.
//  Copyright © 2020 layne. All rights reserved.
//

#import "NetworkExtesionPrivate.h"

@implementation NEVPNManager (lj)

-(BOOL)isProtocolTypeValid2:(long long)arg1
{
    return YES;
}

@end


@implementation NEVPNConnection (lj)

-(NEVPNStatus)statusEx
{
    return NEVPNStatusDisconnected;
}

@end
