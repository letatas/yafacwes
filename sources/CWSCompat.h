//
//  CWSCompat.h
//  yafacwesConsole
//
//  Created by Damien Brossard on 15/07/2015.
//  Copyright (c) 2015 pinguzaph. All rights reserved.
//

#ifdef GNUSTEP
#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif
#endif