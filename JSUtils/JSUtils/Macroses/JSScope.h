// Created for BearDev by drif
// drif@mail.ru

#define JSDeclareVariable(type, name, value) type name = value

#define JSWeakify(var) JSDeclareVariable(__weak __typeof__(var), js_weak_##var, var)
#define JSStrongify(var) JSDeclareVariable(__strong __typeof__(js_weak_##var), var, js_weak_##var)
