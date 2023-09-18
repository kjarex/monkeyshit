//  monkeyshit
//  monkeyshit.m
//
//  Created by Kjartan Rex on 17/09/2023.
//  Copyright © 2023 Kjartan Rex. All rights reserved.

#import <objc/runtime.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSUserDefaults+Private.h>
#import <ApplePushService/APSConnectionServer.h>

void new_hrmtui(Class self, SEL _cmd, id arg1, id arg2){
  NSString* listener= [[NSUserDefaults standardUserDefaults] objectForKey: @"listener" inDomain:  @"com.kjarex.monkeyshit"];
  if (!listener || [listener isEqualToString: @""] || [listener isEqualToString: arg1]){
    NSLog(@"Potential 🙊💩 received: %@", arg2);
    NSString* argX= arg2[@"aps"][@"alert"];
    if ([argX hasPrefix: @"🙊💩"]) {
      NSUInteger loc= [argX rangeOfString: @": "].location;
      if (loc!=NSNotFound){
        arg1= [argX substringWithRange: NSMakeRange(4, loc-4)];
        NSString* arg2js= [argX substringFromIndex: loc+2];
        arg2= [NSJSONSerialization JSONObjectWithData: [arg2js dataUsingEncoding: NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: nil] ?: arg2;
        NSLog(@"🙊💩: %@, %@", arg1, arg2);}}}
  [self performSelector: @selector(orig_handleReceivedMessageTopic:userInfo:) withObject: arg1 withObject: arg2];}

static __attribute__((constructor)) void _logosLocalInit() {
  SEL selector= @selector(handleReceivedMessageTopic:userInfo:);
  Class cls= objc_getClass("APSConnectionServer");
  Method m= class_getInstanceMethod(cls, selector);
  const char* encoding= method_getTypeEncoding(m);
  IMP imp= method_getImplementation(m);
  class_replaceMethod(cls, @selector(orig_handleReceivedMessageTopic:userInfo:), imp, encoding);
  class_replaceMethod(cls, selector, (IMP)new_hrmtui, encoding);}
