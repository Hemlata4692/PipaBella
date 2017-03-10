//
//  SoapGenerator.m
//  DigiBi
//
//  Created by Sumit on 07/09/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import "SoapGenerator.h"

@implementation SoapGenerator


+(NSString *)upperSoapPart : (NSString *)methodName
{
    
    return [NSString stringWithFormat:@"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\"><Body><%@ xmlns=\"urn:Magento\">",methodName];
    
}

+(NSString *)lowerSoapPart : (NSString *)methodName
{
    
    return [NSString stringWithFormat:@"</%@></Body></Envelope>",methodName];
    
}
+(NSString *)middleSoapPart :(NSDictionary *)parameters
{
    NSString * middleSoap;
    middleSoap= [[NSString alloc] init];
    
    for (NSString * key in parameters)
    {
        if ([[parameters valueForKey:key] isKindOfClass:[NSString class]])
        {
            middleSoap = [middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>",key,[parameters objectForKey:key],key]];
        }
        else if ([[parameters valueForKey:key] isKindOfClass:[NSDictionary class]])
        {
            NSDictionary * value = [parameters objectForKey:key];
            middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>",key]];
            for (NSString * key in value)
            {
                if ([[value valueForKey:key] isKindOfClass:[NSString class]])
                {
                    middleSoap = [middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>",key,[value objectForKey:key],key]];
                }
                else
                {
                    NSDictionary *  subvalue = [value objectForKey:key];
                    middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>",key]];
                    
                    for (NSString * key in subvalue)
                    {
                        if ([[subvalue valueForKey:key] isKindOfClass:[NSString class]])
                        {
                            middleSoap = [middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>",key,[subvalue objectForKey:key],key]];
                        }
                        else
                        {
                            NSDictionary *  subvalue1 = [subvalue objectForKey:key];
                            middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>",key]];
                            
                            for (NSString * key in subvalue1)
                            {
                                if ([[subvalue1 valueForKey:key] isKindOfClass:[NSString class]])
                                {
                                    middleSoap = [middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>",key,[subvalue1 objectForKey:key],key]];
                                }
                                else
                                {
                                    NSDictionary * subvalue2 = [subvalue1 objectForKey:key];
                                    middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>",key]];
                                    
                                    for (NSString * key in subvalue2)
                                    {
                                        if ([[subvalue2 valueForKey:key] isKindOfClass:[NSString class]]){
                                            middleSoap = [middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>",key,[subvalue2 objectForKey:key],key]];
                                        }
                                        else
                                        {
                                            NSDictionary * subvalue3 = [subvalue2 objectForKey:key];
                                            middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>",key]];
                                            
                                            for (NSString * key in subvalue3)
                                            {
                                                middleSoap = [middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>",key,[subvalue3 objectForKey:key],key]];
                                            }
                                            middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"</%@>",key]];
                                        }
                                    }
                                    middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"</%@>",key]];
                                }
                            }
                            middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"</%@>",key]];
                        }
                    }
                    middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"</%@>",key]];
                }
            }
            middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"</%@>",key]];
        }
        else if ([[parameters valueForKey:key] isKindOfClass:[NSArray class]]){
            NSArray * value = [parameters objectForKey:key];
            
            for (NSString * key1 in value)
            {
                middleSoap = [middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>",key,key1,key]];
            }
        }
    }
    NSLog(@"middlesoap:  %@",middleSoap);
    return middleSoap;
}
//+(NSString *)middleSoapPart :(NSDictionary *)parameters
//{
//    NSString * middleSoap;
//    middleSoap= [[NSString alloc] init];
//
//    for (NSString * key in parameters)
//    {
//
//        if ([[parameters valueForKey:key] isKindOfClass:[NSString class]])
//        {
//            middleSoap = [middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>",key,[parameters objectForKey:key],key]];
//
//        }
//        else
//        {
//            NSDictionary * value = [parameters objectForKey:key];
//
//            middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>",key]];
//            for (NSString * key in value)
//            {
//                middleSoap = [middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>",key,[value objectForKey:key],key]];
//            }
//            middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"</%@>",key]];
//
//        }
//    }
//    NSLog(@"middlesoap:  %@",middleSoap);
//
//    return middleSoap;
//}
+(NSString *)middleSoapPartWithArray :(NSDictionary *)parameters
{
    NSString * middleSoap;
    middleSoap= [[NSString alloc] init];
    
    for (NSString * key in parameters)
    {
        
        if ([[parameters valueForKey:key] isKindOfClass:[NSString class]])
        {
            middleSoap = [middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>",key,[parameters objectForKey:key],key]];
            
        }
        else if ([[parameters valueForKey:key] isKindOfClass:[NSArray class]])
        {
            NSMutableArray * value = [parameters objectForKey:key];
            
            middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>",key]];
            
            for (int i = 0; i < value.count; i++) {
                for (NSString * key in [value objectAtIndex:i])
                {
                    // middleSoap = [middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>",key,[value objectForKey:key],key]];
                    
                    if ([[[value objectAtIndex:i] valueForKey:key] isKindOfClass:[NSString class]])
                    {
                        middleSoap = [middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>",key,[[value objectAtIndex:i] objectForKey:key],key]];
                        
                    }
                    else
                    {
                        
                        NSDictionary *  subvalue = [[value objectAtIndex:i] objectForKey:key];
                        middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>",key]];
                        
                        for (NSString * key in subvalue)
                        {
                            
                            
                            if ([[subvalue valueForKey:key] isKindOfClass:[NSString class]])
                            {
                                middleSoap = [middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>",key,[subvalue objectForKey:key],key]];
                                
                            }
                            else
                            {
                                
                                NSDictionary *  subvalue1 = [subvalue objectForKey:key];
                                middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>",key]];
                                
                                for (NSString * key in subvalue1)
                                {
                                    
                                    if ([[subvalue1 valueForKey:key] isKindOfClass:[NSString class]])
                                    {
                                        middleSoap = [middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>",key,[subvalue1 objectForKey:key],key]];
                                        
                                    }
                                    else
                                    {
                                        
                                        NSDictionary * subvalue2 = [subvalue1 objectForKey:key];
                                        
                                        middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>",key]];
                                        
                                        for (NSString * key in subvalue2)
                                        {
                                            if ([[subvalue2 valueForKey:key] isKindOfClass:[NSString class]]){
                                                middleSoap = [middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>",key,[subvalue2 objectForKey:key],key]];
                                                
                                            }
                                            else
                                            {
                                                
                                                NSDictionary * subvalue3 = [subvalue2 objectForKey:key];
                                                
                                                middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>",key]];
                                                
                                                for (NSString * key in subvalue3)
                                                {
                                                    middleSoap = [middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>",key,[subvalue3 objectForKey:key],key]];
                                                }
                                                
                                                middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"</%@>",key]];
                                                
                                                
                                            }
                                        }
                                        
                                        middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"</%@>",key]];
                                        
                                        
                                    }
                                    
                                    
                                }
                                middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"</%@>",key]];
                                
                            }
                            
                            //                    for (NSString * key in subvalue)
                            //                    {
                            //                        middleSoap = [middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>",key,[subvalue objectForKey:key],key]];
                            //
                            //                    }
                        }
                        middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"</%@>",key]];
                        
                    }
                }
            }
            
            middleSoap=[middleSoap stringByAppendingString:[NSString stringWithFormat:@"</%@>",key]];
            
        }
        else if ([[parameters valueForKey:key] isKindOfClass:[NSArray class]]){
            NSArray * value = [parameters objectForKey:key];
            
            for (NSString * key1 in value)
            {
                middleSoap = [middleSoap stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>",key,key1,key]];
            }
        }
    }
    NSLog(@"middlesoap:  %@",middleSoap);
    
    return middleSoap;
}
+(NSString *)getSoapString :(NSDictionary *)parameters methodName:(NSString *)methodName
{
    
    return [NSString stringWithFormat:@"%@%@%@",[self upperSoapPart:methodName],[self middleSoapPart:parameters],[self lowerSoapPart:methodName]];
    
}
+(NSString *)getSoapStringWithArray :(NSDictionary *)parameters methodName:(NSString *)methodName
{
    
    return [NSString stringWithFormat:@"%@%@%@",[self upperSoapPart:methodName],[self middleSoapPartWithArray:parameters],[self lowerSoapPart:methodName]];
    
}

@end
