//
//  RedisiOS.h
//  RedisiOS
//

#import "MHRedis.h"

@implementation MHRedis

NSMutableDictionary* data;

-(NSString*)runQuery:(NSString*)command {
    NSArray* args = [self parseCommand:command];
    int argCount = [args count];
    NSString* commandName = [args[0] uppercaseString];
    
    if ([commandName isEqualToString:@"PING"]){
        if (argCount == 1){
        return [self PING];
        } else {
            return [NSString stringWithFormat:@"(error) ERR wrong number of arguments for '%@' command",commandName];
        }
    }
    
    if ([commandName isEqualToString:@"DBSIZE"]){
        if (argCount == 1){
        return [self DBSIZE];
        } else {
            return [NSString stringWithFormat:@"(error) ERR wrong number of arguments for '%@' command",commandName];
        }
    }
    
    if ([commandName isEqualToString:@"FLUSHDB"]){
        if (argCount == 1){
        return [self FLUSHDB];
        } else {
            return [NSString stringWithFormat:@"(error) ERR wrong number of arguments for '%@' command",commandName];
        }
    }
    
    if ([commandName isEqualToString:@"SET"]){
        if (argCount == 3){
        return [self SET:args[1] :args[2]];
        } else {
           return [NSString stringWithFormat:@"(error) ERR wrong number of arguments for '%@' command",commandName];
        }
    }
    
    if ([commandName isEqualToString:@"GET"]){
        if (argCount == 2){
            return [self GET:args[1]];
        } else {
            return [NSString stringWithFormat:@"(error) ERR wrong number of arguments for '%@' command",commandName];
        }
    }
    
    if ([commandName isEqualToString:@"APPEND"]){
        if (argCount == 3){
            return [self APPEND:args[1] :args[2]];
        } else {
            return [NSString stringWithFormat:@"(error) ERR wrong number of arguments for '%@' command",commandName];
        }
    }
    
    if ([commandName isEqualToString:@"DECR"]){
        if (argCount == 2){
            return [self DECR:args[1]];
        } else {
            return [NSString stringWithFormat:@"(error) ERR wrong number of arguments for '%@' command",commandName];
        }
    }
    
    if ([commandName isEqualToString:@"DECRBY"]){
        if (argCount == 3){
            return [self DECRBY:args[1]:args[2]];
        } else {
            return [NSString stringWithFormat:@"(error) ERR wrong number of arguments for '%@' command",commandName];
        }
    }
    
    if ([commandName isEqualToString:@"GETRANGE"]){
        if (argCount == 4){
            return [self GETRANGE:args[1] :args[2] :args[3]];
        } else {
            return [NSString stringWithFormat:@"(error) ERR wrong number of arguments for '%@' command",commandName];
        }
    }
    
    if ([commandName isEqualToString:@"GETSET"]){
        if (argCount == 3){
            return [self GETSET:args[1] :args[2]];
        } else {
            return [NSString stringWithFormat:@"(error) ERR wrong number of arguments for '%@' command",commandName];
        }
    }
    
    if ([commandName isEqualToString:@"INCRBY"]){
        if (argCount == 3){
            return [self INCRBY:args[1]:args[2]];
        } else {
            return [NSString stringWithFormat:@"(error) ERR wrong number of arguments for '%@' command",commandName];
        }
    }
    
    if ([commandName isEqualToString:@"INCR"]){
        if (argCount == 2){
            return [self INCR:args[1]];
        } else {
            return [NSString stringWithFormat:@"(error) ERR wrong number of arguments for '%@' command",commandName];
        }
    }
    
    if ([commandName isEqualToString:@"MGET"]){
        if (argCount >= 2){
            return [self MGET:args];
        } else {
            return [NSString stringWithFormat:@"(error) ERR wrong number of arguments for '%@' command",commandName];
        }
    }
    
    return [NSString stringWithFormat:@"(error) ERR unknown command '%@'",commandName];
}

-(void)create {
    data = [NSMutableDictionary dictionary];
}

-(NSArray*)parseCommand:(NSString*)command {
    NSMutableArray* args = [NSMutableArray array];
    command = [command stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* currentText = @"";
    int argCount = 0;
    Boolean inString = false;
    Boolean ignoreCharacter = false;
    for (int i = 0; i < [command length];i++){
        ignoreCharacter = false;
        NSString* character = [NSString stringWithFormat:@"%c",[command characterAtIndex:i]];
        if ([character isEqualToString:@" "]){
            if (inString == false){
            args[argCount] = currentText;
            argCount++;
            currentText = @"";
            ignoreCharacter = true;
            }
        }
        if ([character isEqualToString:@"\""]){
            ignoreCharacter = true;
            if (inString == false){
                inString = true;
            } else {
                args[argCount] = currentText;
                argCount++;
                currentText = @"";
            }
        }
        
        if (ignoreCharacter == false){
            currentText = [currentText stringByAppendingString:character];
        }
        
    }
    
    if ([currentText isEqualToString:@""] == false){
    args[argCount] = currentText;
    }
    return args;
}

-(BOOL)checkInteger:(NSString*)string {
    NSScanner *scanner = [NSScanner scannerWithString:string];
    BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
    if (isNumeric){
        if ([string integerValue] > INT_MAX){
            return false;
        } else {
            return true;
        }
    } else {
        return false;
    }
}

-(NSString*)PING {
    return @"PONG";
}

-(NSString*)DBSIZE {
    return [NSString stringWithFormat:@"(integer) %lu",(unsigned long)[[data allKeys] count]];
}

-(NSString*)FLUSHDB {
    data = [NSMutableDictionary dictionary];
    return @"OK";
}

-(NSString*)SET:(NSString*)key:(NSString*)value {
    [data setValue:value forKey:key];
    return @"OK";
}

-(NSString*)APPEND:(NSString*)key:(NSString*)value {
    NSString* currentValue = [data valueForKey:key];
    if (currentValue == NULL){
        [data setObject:key forKey:value];
        return [NSString stringWithFormat:@"(integer) %lu",(unsigned long)[value length]];
    }
    NSString* newValue = [currentValue stringByAppendingString:value];
    [data setObject:newValue forKey:key];
    return [NSString stringWithFormat:@"(integer) %lu",(unsigned long)[newValue length]];
}

-(NSString*)GET:(NSString*)key {
    if ([data valueForKey:key] != NULL){
    return [NSString stringWithFormat:@"\"%@\"",[data valueForKey:key]];
    } else {
        return @"(nil)";
    }
}

-(NSString*)DECR:(NSString*)key {
    NSString* value = [data valueForKey:key];
    if (value == NULL){
        [data setObject:@"0" forKey:key];
        value = @"0";
    }
    if ([self checkInteger:value]){
    int integerValue = [value intValue];
    integerValue--;
    [data setObject:[NSString stringWithFormat:@"%d",integerValue] forKey:key];
    return [NSString stringWithFormat:@"(integer) %d",integerValue];
    } else {
    return @"(error) ERR value is not an integer or out of range";
    }
}

-(NSString*)INCR:(NSString*)key {
    NSString* value = [data valueForKey:key];
    if (value == NULL){
        [data setObject:@"0" forKey:key];
        value = @"0";
    }
    if ([self checkInteger:value]){
        int integerValue = [value intValue];
        integerValue++;
        [data setObject:[NSString stringWithFormat:@"%d",integerValue] forKey:key];
        return [NSString stringWithFormat:@"(integer) %d",integerValue];
    } else {
        return @"(error) ERR value is not an integer or out of range";
    }
}

-(NSString*)DECRBY:(NSString*)key:(NSString*)by {
    NSString* value = [data valueForKey:key];
    if (value == NULL){
        [data setObject:@"0" forKey:key];
        value = @"0";
    }
    if ([self checkInteger:value] && [self checkInteger:by]){
    int integerValue = [value intValue];
    integerValue-=[by integerValue];
    [data setObject:[NSString stringWithFormat:@"%d",integerValue] forKey:key];
    return [NSString stringWithFormat:@"(integer) %d",integerValue];
    } else {
        return @"(error) ERR value is not an integer or out of range";
    }
}

-(NSString*)INCRBY:(NSString*)key:(NSString*)by {
    NSString* value = [data valueForKey:key];
    if (value == NULL){
        [data setObject:@"0" forKey:key];
        value = @"0";
    }
    if ([self checkInteger:value] && [self checkInteger:by]){
        int integerValue = [value intValue];
        integerValue+=[by integerValue];
        [data setObject:[NSString stringWithFormat:@"%d",integerValue] forKey:key];
        return [NSString stringWithFormat:@"(integer) %d",integerValue];
    } else {
        return @"(error) ERR value is not an integer or out of range";
    }
}

-(NSString*)GETRANGE:(NSString*)key:(NSString*)from:(NSString*)to {
    if ([self checkInteger:from] && [self checkInteger:to]){
        NSString* value = [data valueForKey:key];
        if (value == NULL){
            return @"\"\"";
        }
        int toInt = [to intValue] + 1;
        int fromInt = [from intValue];
        if (toInt > [value length]){
            toInt = [value length];
        }
        if (toInt < 0){
            toInt = 0;
        }
        if (fromInt > [value length]){
            fromInt = [value length];
        }
        if (fromInt < 0){
            fromInt = 0;
        }
        NSRange range = {fromInt,toInt - fromInt};
        return [NSString stringWithFormat:@"\"%@\"",[value substringWithRange:range]];
    } else {
        return @"(error) ERR value is not an integer or out of range";
    }
}

-(NSString*)GETSET:(NSString*)key:(NSString*)value {
    NSString* oldValue = [data valueForKey:key];
    if (oldValue == NULL){
        oldValue = @"(nil)";
    } else {
        oldValue = [NSString stringWithFormat:@"\"%@\"",oldValue];
    }
    [data setValue:value forKey:key];
    return oldValue;
}

-(NSString*)MGET:(NSArray*)args {
    NSString* returnValue = @"";
    int pos = 1;
    for (int i = 1; i < [args count];i++){
        NSString* value = [data valueForKey:args[i]];
        if (value == NULL){
            value = @"(nil)";
        } else {
            value = [NSString stringWithFormat:@"\"%@\"",value];
        }
       
        if ([returnValue isEqualToString:@""]){
            returnValue = [NSString stringWithFormat:@"%@%d) %@",returnValue,pos,value];
        } else {
            returnValue = [NSString stringWithFormat:@"%@\r\n%d) %@",returnValue,pos,value];
        }
        
        pos++;
    }
    return returnValue;
}
@end
