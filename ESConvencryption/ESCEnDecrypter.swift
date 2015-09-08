//
//  ESCEnDecrypter.swift
//  ESConvencryption
//
//  Created by 史翔新 on 2015/09/09.
//  Copyright © 2015年 史翔新. All rights reserved.
//

/** WTFPL
DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
Version 2, December 2004

Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.

DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

0. You just DO WHAT THE FUCK YOU WANT TO.
*/

import UIKit

public struct ESCEnDecrypter {

	let hashedUUID = UIDevice.currentDevice().identifierForVendor?.hash ?? 1
	let intMask: Int
	
	public init(intMask: Int = 0xFFFF) {
		self.intMask = intMask
	}
	
	public func encrypt(plainInt: Int) -> Int? {
		
		guard (plainInt & self.intMask) == plainInt else {
			return nil
		}
		
		let hashedInt = (self.hashedUUID &* plainInt).description.hash
		let hashMask = ~self.intMask
		let encryptedInt = (hashedInt & hashMask) + plainInt
		
		return encryptedInt
		
	}
	
	public func decrypt(encryptedInt: Int) -> Int? {
		
		let plainInt = encryptedInt & self.intMask
		
		guard self.encrypt(plainInt) == encryptedInt else {
			return nil
			
		}
		
		return plainInt
		
	}
	
}
