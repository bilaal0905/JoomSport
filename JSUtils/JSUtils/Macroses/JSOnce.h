// Created for BearDev by drif
// drif@mail.ru

#define JSOnceStatement(token, statement) dispatch_once(&token, ^{ statement; });

#define JSOnceSet(type, name, statement) \
    static dispatch_once_t name##OnceToken; \
    static type name; \
    JSOnceStatement(name##OnceToken, name = statement);

#define JSOnceSetReturn(type, name, statement) \
    JSOnceSet(type, name, statement); \
    return name;
