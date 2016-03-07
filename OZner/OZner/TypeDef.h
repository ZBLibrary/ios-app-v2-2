//
//  TypeDef.h
//  BlackRoom
//
//  Created by Mac Mini 1 on 14-10-14.
//  Copyright (c) 2014年 sunlinlin. All rights reserved.
//

typedef unsigned short WORD;
typedef unsigned int DWORD;
typedef unsigned char BYTE;
typedef unsigned long long UNDWORD;
typedef signed long long DWORD64;

#define MAX_LONGLONG 0x7FFFFFFFFFFFFFFF
#define MAX_LONGLONG2 ((~((UNDWORD)0)) >> 1)

#define COLORWITH_RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];

#define UIFONT_SYSTERM_SIZE_EIGHT       8.0f
#define UIFONT_SYSTERM_SIZE_NINE        9.0f
#define UIFONT_SYSTERM_SIZE_LITTER      10.0f
#define UIFONT_SYSTERM_SIZE_ELEVN       11.0f
#define UIFONT_SYSTERM_SIZE_LITTLE      12.0f
#define UIFONT_SYSTERM_SIZE_THIRTEEN    13.0f
#define UIFONT_SYSTERM_DEFAULT_SIZE     14.0f
#define UIFONT_SYSTERM_SIZE_LARGE       15.0f
#define UIFONT_SYSTERM_SIZE_SIXTEEN     16.0f
#define UIFONT_SYSTERM_SIZE_LARGER      18.0f
#define UIFONT_SYSTERM_SIZE_NINETEENT   19.0f
#define UIFONT_SYSTERM_SIZE_TWEENTYONE  21.0f

#define SafeVal(p) (p ? (*p) : 0)