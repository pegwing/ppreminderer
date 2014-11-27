#import <Foundation/Foundation.h>
#import "PPRSingleton.h"

@interface PPRDataStore : PPRSingleton
@property (nonatomic,strong)NSString *documentsDirectoryName;

- (id)loadObjectForKey:(NSString *)key;

- (void)saveObject:(id)object forKey:(NSString *)key;


- (NSString *)getPrivateDocsDir;

- (void)removeObjectId:(NSString *)objectId directory:(NSString *)directory ;

- (void)saveObject:(id)object objectId:(NSString *)objectId directory:(NSString *)directory ;

- (NSString *)createPrivateDocsDirFor:(NSString *)directory;

- (NSArray *)loadObjectsFromDirectory:(NSString *)directory;

@end