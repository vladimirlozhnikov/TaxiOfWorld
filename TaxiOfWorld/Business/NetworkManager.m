//
//  NetworkManager.m
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 22.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import "NetworkManager.h"
#import "User+Category.h"
#import "Pin+Category.h"
#import "NSManagedObject+Category.h"
#import "Group+Category.h"
#import "Message+Category.h"
#import "Country+Category.h"
#import "City+Category.h"

@implementation NetworkManager

- (void) dealloc
{
    [httpClient release];
    [super dealloc];
}

- (id) init
{
	if (self = [super init])
	{
		NSString* baseURL = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"ServerBaseURL"];
		httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
		[httpClient setDefaultHeader:@"X-Developerkey" value:@"123"];
		[httpClient setDefaultHeader:@"Accept" value:@"application/json"];
        //[httpClient setDefaultHeader:@"X-Debug" value:@"1"];
		[httpClient setParameterEncoding:AFJSONParameterEncoding];
        [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
	}
    
	return self;
}

#pragma mark - Server Methods

- (void) register:(User*)user success:(void(^)(User* user, NSString* password))onSuccess onError:(void(^)(NSString* error))onError
{
    NSMutableDictionary* params = [user toDictionary];
    
    [httpClient postPath:@"users/register" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary* result = responseObject;
        //NSLog(@"%@", result);
        
        NSString* error = [result objectForKey:@"error"];
        if(![[result objectForKey:@"success"] boolValue])
        {
            if ([error isKindOfClass:[NSNumber class]])
            {
                onError([NSString stringWithFormat:@"%@", error]);
            }
            else
            {
                onError(error);
            }
            
            return;
        }
        
        onSuccess(user, [result objectForKey:@"password"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        onError([error localizedDescription]);
    }];
}

- (void) login:(NSString*)email password:(NSString*)password pin:(Pin*)pin language:(NSInteger)language version:(NSString*)version deviceToken:(NSData*)deviceToken success:(void(^)(NSString* session, User* user, NSArray* groups))onSuccess onError:(void(^)(NSString* error))onError
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:email forKey:@"email"];
    [params setObject:password forKey:@"password"];
    [params setObject:[NSNumber numberWithInteger:language] forKey:@"language"];
    [params setObject:version forKey:@"version"];
 
    if ([deviceToken length] > 0)
    {
        NSString* token = [[[[deviceToken description]  stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""] retain];
        //NSString* token = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
        [params setObject:token forKey:@"devicetoken"];
    }
    
    NSMutableDictionary* pinDictionary = [pin toDictionary];
    [params setObject:pinDictionary forKey:@"pin"];
    //NSLog(@"%@", params);
    
    [httpClient postPath:@"users/login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* result = responseObject;
         //NSLog(@"%@", result);
         
         NSString* error = [result objectForKey:@"error"];
         if(![[result objectForKey:@"success"] boolValue])
         {
             if ([error isKindOfClass:[NSNumber class]])
             {
                 onError([NSString stringWithFormat:@"%@", error]);
             }
             else
             {
                 onError(error);
             }
             
             return;
         }
         
         User* u = nil;
         NSMutableArray* gs = [NSMutableArray array];
         
         NSString* session = [result objectForKey:@"session"];
         if ([session length] > 0)
         {
             NSLog(@"session: %@", session);
             [httpClient setDefaultHeader:@"X-Session" value:session];
             
             NSDictionary* userDictionary = [result objectForKey:@"user"];
             u = [User createManagedObjectFromDictionary:userDictionary inContext:DELEGATE.managedObjectContext];
             u.phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
             //NSLog(@"%@", u);
             
             NSArray* groupsArray = [[result objectForKey:@"groups"] objectForKey:@"withCriteria"];
             for (NSDictionary* groupDictionary in groupsArray)
             {
                 Group* g = [Group createManagedObjectFromDictionary:groupDictionary inContext:DELEGATE.managedObjectContext];
                 [gs addObject:g];
             }
         }
         else
         {
             [httpClient setDefaultHeader:@"X-Session" value:@""];
             
             NSArray* groupsArray = [result objectForKey:@"groups"];
             for (NSDictionary* groupDictionary in groupsArray)
             {
                 Group* g = [Group createManagedObjectFromDictionary:groupDictionary inContext:DELEGATE.managedObjectContext];
                 [gs addObject:g];
             }
         }
         
         onSuccess(session, u, gs);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //NSLog(@"%@", error);
         onError([error localizedDescription]);
     }];
}

- (void) updateMe:(void(^)())onSuccess onError:(void(^)(NSString* error))onError
{
    NSMutableDictionary* params = [DELEGATE.me toDictionary];
    
    [httpClient postPath:@"users/update" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* result = responseObject;
         //NSLog(@"%@", result);
         
         NSString* error = [result objectForKey:@"error"];
         if(![[result objectForKey:@"success"] boolValue])
         {
             if ([error isKindOfClass:[NSNumber class]])
             {
                 onError([NSString stringWithFormat:@"%@", error]);
             }
             else
             {
                 onError(error);
             }
             
             return;         }
         
         onSuccess();
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         onError([error localizedDescription]);
     }];
}

- (void) joinToGroup:(Group*)group ticket:(NSString*)ticket success:(void(^)())onSuccess onError:(void(^)(NSString* error))onError
{
    NSString* path = [NSString stringWithFormat:@"groups/%@/join", group.index];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:ticket forKey:@"ticket"];
    NSLog(@"%@", params);
    
    [httpClient postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* result = responseObject;
         //NSLog(@"%@", result);
         
         NSString* error = [result objectForKey:@"error"];
         if(![[result objectForKey:@"success"] boolValue])
         {
             if ([error isKindOfClass:[NSNumber class]])
             {
                 onError([NSString stringWithFormat:@"%@", error]);
             }
             else
             {
                 onError(error);
             }
             
             return;
         }
         
         onSuccess();
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", operation.responseString);
         onError([error localizedDescription]);
     }];
}

- (void) leaveGroup:(Group*)group success:(void(^)())onSuccess onError:(void(^)(NSString* error))onError
{
    NSString* path = [NSString stringWithFormat:@"groups/%@/leave", group.index];
    //NSLog(@"%@", path);
    
    [httpClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* result = responseObject;
         //NSLog(@"%@", result);
         
         NSString* error = [result objectForKey:@"error"];
         if(![[result objectForKey:@"success"] boolValue])
         {
             if ([error isKindOfClass:[NSNumber class]])
             {
                 onError([NSString stringWithFormat:@"%@", error]);
             }
             else
             {
                 onError(error);
             }
             
             return;
         }
         
         onSuccess();
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //NSLog(@"%@", operation.responseString);
         onError([error localizedDescription]);
     }];
}

- (void) usersOfGroup:(Group*)group fullInfo:(BOOL)fullInfo success:(void(^)(NSArray* usersOrPins))onSuccess onError:(void(^)(NSString* error))onError
{
    NSString* path = [NSString stringWithFormat:@"groups/%@/users", group.index];
    //NSLog(@"%@", path);
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:@"" forKey:@"criteria"];
    [params setObject:[NSNumber numberWithBool:fullInfo] forKey:@"fullInfo"];
    
    //NSLog(@"%@", params);
    
    [httpClient postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* result = responseObject;
         //NSLog(@"%@", result);
         
         NSString* error = [result objectForKey:@"error"];
         if(![[result objectForKey:@"success"] boolValue])
         {
             if ([error isKindOfClass:[NSNumber class]])
             {
                 onError([NSString stringWithFormat:@"%@", error]);
             }
             else
             {
                 onError(error);
             }
             
             return;
         }
         
         NSArray* usersArray = [result objectForKey:@"users"];
         NSArray* pinsArray = [result objectForKey:@"gps"];
         
         NSMutableArray* array = [NSMutableArray array];
         
         if ([usersArray count] > 0)
         {
             for (NSDictionary* u in usersArray)
             {
                 User* user = [User createManagedObjectFromDictionary:u inContext:DELEGATE.managedObjectContext];
                 [array addObject:user];
             }
         }
         else if ([pinsArray count] > 0)
         {
             for (NSDictionary* p in pinsArray)
             {
                 Pin* pin = [Pin createManagedObjectFromDictionary:p inContext:DELEGATE.managedObjectContext];
                 [array addObject:pin];
             }
         }
         
         onSuccess(array);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //NSLog(@"%@", error);
         //NSLog(@"%@", [operation responseString]);
         onError([error localizedDescription]);
     }];
}

- (void) messages:(NSInteger)limit success:(void(^)(NSArray* messages))onSuccess onError:(void(^)(NSString* error))onError
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    
    [httpClient postPath:@"messages" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* result = responseObject;
         //NSLog(@"%@", result);
         
         NSString* error = [result objectForKey:@"error"];
         if(![[result objectForKey:@"success"] boolValue])
         {
             if ([error isKindOfClass:[NSNumber class]])
             {
                 onError([NSString stringWithFormat:@"%@", error]);
             }
             else
             {
                 onError(error);
             }
             
             return;
         }
         
         NSMutableArray* array = [NSMutableArray array];
         NSArray* messagesArray = [result objectForKey:@"messages"];
         
         for (NSDictionary* m in messagesArray)
         {
             Message* message = [Message createManagedObjectFromDictionary:m inContext:DELEGATE.managedObjectContext];
             [DELEGATE.managedObjectContext deleteObject:message];
             [array addObject:message];
         }
         
         onSuccess(array);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         onError([error localizedDescription]);
     }];
}

- (void) sendMessage:(Message*)message users:(NSArray*)users success:(void(^)())onSuccess onError:(void(^)(NSString* error))onError
{
    NSString* path = [NSString stringWithFormat:@"groups/%@/message", message.index];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    NSDictionary* messageDictionary = [message toDictionary];
    [params setObject:messageDictionary forKey:@"message"];
    
    NSMutableArray* usersArray = [NSMutableArray array];
    [params setObject:usersArray forKey:@"ids"];
    for (User* u in users)
    {
        NSDictionary* d = [u toDictionary];
        [usersArray addObject:d];
    }
    
    [httpClient postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* result = responseObject;
         //NSLog(@"%@", result);
         
         NSString* error = [result objectForKey:@"error"];
         if(![[result objectForKey:@"success"] boolValue])
         {
             if ([error isKindOfClass:[NSNumber class]])
             {
                 onError([NSString stringWithFormat:@"%@", error]);
             }
             else
             {
                 onError(error);
             }
             
             return;
         }
         
         onSuccess();
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         onError([error localizedDescription]);
     }];
}

- (void) updateCoordinates:(Pin*)pin success:(void(^)())onSuccess onError:(void(^)(NSString* error))onError
{
    NSMutableDictionary* params = [pin toDictionary];
    
    [httpClient postPath:@"update_coordinates" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* result = responseObject;
         //NSLog(@"%@", result);
         
         NSString* error = [result objectForKey:@"error"];
         if(![[result objectForKey:@"success"] boolValue])
         {
             if ([error isKindOfClass:[NSNumber class]])
             {
                 onError([NSString stringWithFormat:@"%@", error]);
             }
             else
             {
                 onError(error);
             }
             
             return;
         }
         
         onSuccess();
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         onError([error localizedDescription]);
     }];
}

- (void) countries:(void(^)(NSArray* countries))onSuccess onError:(void(^)(NSString* error))onError
{
    [httpClient getPath:@"countries" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* result = responseObject;
         //NSLog(@"%@", result);
         
         NSString* error = [result objectForKey:@"error"];
         if(![[result objectForKey:@"success"] boolValue])
         {
             if ([error isKindOfClass:[NSNumber class]])
             {
                 onError([NSString stringWithFormat:@"%@", error]);
             }
             else
             {
                 onError(error);
             }
             
             return;
         }
         
         NSMutableArray* countries = [NSMutableArray array];
         NSArray* countriesArray = [result objectForKey:@"countries"];
         for (NSDictionary* c in countriesArray)
         {
             Country* country = [Country createManagedObjectFromDictionary:c inContext:DELEGATE.managedObjectContext];
             [countries addObject:country];
         }
         
         onSuccess(countries);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         onError([error localizedDescription]);
     }];
}

- (void) cities:(Country*)country success:(void(^)(NSArray* cities))onSuccess onError:(void(^)(NSString* error))onError
{
    NSString* path = [NSString stringWithFormat:@"countries/%@/cities", country.index];
    
    [httpClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* result = responseObject;
         //NSLog(@"%@", result);
         
         NSString* error = [result objectForKey:@"error"];
         if(![[result objectForKey:@"success"] boolValue])
         {
             if ([error isKindOfClass:[NSNumber class]])
             {
                 onError([NSString stringWithFormat:@"%@", error]);
             }
             else
             {
                 onError(error);
             }
             
             return;
         }
         
         NSMutableArray* cities = [NSMutableArray array];
         NSArray* citiesArray = [result objectForKey:@"cities"];
         for (NSDictionary* c in citiesArray)
         {
             City* city = [City createManagedObjectFromDictionary:c inContext:DELEGATE.managedObjectContext];
             [cities addObject:city];
         }
         
         onSuccess(cities);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         onError([error localizedDescription]);
     }];
}

- (void) ping:(NSInteger)status success:(void(^)(NSInteger messageQuantity, NSString* version, NSArray* leftUsers, NSArray* joinedUSers))onSuccess onError:(void(^)(NSString* error))onError
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:status] forKey:@"status"];
    
    [httpClient postPath:@"ping" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* result = responseObject;
         //NSLog(@"%@", result);
         
         NSString* error = [result objectForKey:@"error"];
         if(![[result objectForKey:@"success"] boolValue])
         {
             if ([error isKindOfClass:[NSNumber class]])
             {
                 onError([NSString stringWithFormat:@"%@", error]);
             }
             else
             {
                 onError(error);
             }
             
             return;
         }
         
         NSNumber* quantity = [result objectForKey:@"message_quantity"];
         NSString* version = [result objectForKey:@"version"];
         NSArray* leftUsersArray = [result objectForKey:@"left_users"];
         NSArray* joinedUsersArray = [result objectForKey:@"joined_users"];
         
         NSMutableArray* leftArray = [NSMutableArray array];
         NSMutableArray* joinedArray = [NSMutableArray array];
         
         for (NSNumber* l in leftUsersArray)
         {
             [leftArray addObject:l];
         }
         
         for (NSDictionary* j in joinedUsersArray)
         {
             User* user = [User createManagedObjectFromDictionary:j inContext:DELEGATE.managedObjectContext];
             [joinedArray addObject:user];
         }
         
         onSuccess([quantity integerValue], version, leftArray, joinedArray);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //NSLog(@"%@, %@", error, operation.responseString);
         onError([error localizedDescription]);
     }];
}

- (void) handleMessage:(Message*)message success:(void(^)())onSuccess onError:(void(^)(NSString* error))onError
{
    NSMutableDictionary* params = [message toDictionary];
    //NSLog(@"%@", params);
    
    [httpClient postPath:@"handle_message" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* result = responseObject;
         //NSLog(@"%@", result);
         
         NSString* error = [result objectForKey:@"error"];
         if(![[result objectForKey:@"success"] boolValue])
         {
             if ([error isKindOfClass:[NSNumber class]])
             {
                 onError([NSString stringWithFormat:@"%@", error]);
             }
             else
             {
                 onError(error);
             }
             
             return;
         }
         
         onSuccess();
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //NSLog(@"%@", operation.responseString);
         onError([error localizedDescription]);
     }];
}

- (void) pushRate:(User*)user rate:(Rating*)rating success:(void(^)())onSuccess onError:(void(^)(NSString* error))onError
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    NSDictionary* ratingDictionary = [rating toDictionary];
    
    [params setObject:user.index forKey:@"user_id"];
    [params setObject:ratingDictionary forKey:@"rate_item"];
    
    //NSLog(@"%@", params);
    
    [httpClient postPath:@"push_rate" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary* result = responseObject;
         //NSLog(@"%@", result);
         
         NSString* error = [result objectForKey:@"error"];
         if(![[result objectForKey:@"success"] boolValue])
         {
             if ([error isKindOfClass:[NSNumber class]])
             {
                 onError([NSString stringWithFormat:@"%@", error]);
             }
             else
             {
                 onError(error);
             }
             
             return;
         }
         
         onSuccess();
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         onError([error localizedDescription]);
     }];
}

- (void) getAddresses:(CLLocationCoordinate2D)position success:(void(^)(NSArray* addresses))onSuccess onError:(void(^)(NSString* error))onError
{
    NSString* baseURL = @"https://maps.googleapis.com";
    AFHTTPClient* gooleHttpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    [gooleHttpClient setDefaultHeader:@"Accept" value:@"text/json"];
    [gooleHttpClient setParameterEncoding:AFJSONParameterEncoding];
    [gooleHttpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f,%f", position.latitude, position.longitude], @"latlng", @"true", @"sensor", nil];
    
    [gooleHttpClient getPath:@"maps/api/geocode/json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* result = responseObject;
        
        NSArray* places = [result objectForKey:@"results"];
        onSuccess(places);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        onError([error localizedDescription]);
    }];
}

@end
