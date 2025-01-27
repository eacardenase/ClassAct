//
//  main.m
//  ClassAct
//
//  Created by Edwin Cardenas on 26/01/25.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NSArray *BNRHierarchyForClass(Class cls) {
    NSMutableArray *classHierarchy = [NSMutableArray array];
    
    for (Class c = cls; c != Nil; c = class_getSuperclass(c)) {
        NSString *className = NSStringFromClass(c);
        
        [classHierarchy insertObject:className atIndex:0];
    }
    
    return classHierarchy;
}

NSArray *BNRMethodsForClass(Class cls) {
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(cls, &methodCount);
    NSMutableArray *methodArray = [NSMutableArray array];
    
    for (int m = 0; m < methodCount; m++) {
        Method currentMethod = methodList[m];
        SEL methodSelector = method_getName(currentMethod);
        
        [methodArray addObject:NSStringFromSelector(methodSelector)];
    }
    
    free(methodList);
    
    return methodArray;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableArray *runtimeClassesInfo = [NSMutableArray array];
        
        unsigned int classCount = 0;
        
        Class *classList = objc_copyClassList(&classCount);
        
        for (int i = 0; i < classCount; i++) {
            Class currentClass = classList[i];
            NSString *className = NSStringFromClass(currentClass);
            
            NSArray *hierarchy = BNRHierarchyForClass(currentClass);
            NSArray *methods = BNRMethodsForClass(currentClass);
            NSDictionary *classInfoDict = @{
                @"classname": className,
                @"hierarchy": hierarchy,
                @"methods": methods
            };
            
            [runtimeClassesInfo addObject:classInfoDict];
        }
        
        free(classList);
        
        NSSortDescriptor *alphaAsc = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        NSArray *sortedArray = [runtimeClassesInfo sortedArrayUsingDescriptors:@[alphaAsc]];
        
        NSLog(@"There are %ld classes registered with this program's Runtime.", sortedArray.count);
        NSLog(@"%@", sortedArray);
    }
    return 0;
}
