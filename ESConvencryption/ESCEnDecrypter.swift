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
	
	private let hashedUUID = UIDevice.currentDevice().identifierForVendor?.hash ?? 1
	private let bitMask: Int
	
	public init(bitMaskDigits: Int = 16) {
		let bitMask = [Int](0 ..< bitMaskDigits).reduce(0) { $0 + (1 << $1) }
		self.bitMask = bitMask
	}
	
	public func encrypt(plainInt: Int, withAdditionalIdentifier identifier: Int = 1) -> Int? {
		
		guard (plainInt & self.bitMask) == plainInt else {
			return nil
		}
		
		let hashedInt = (self.hashedUUID &* identifier &* plainInt).description.hash
		let hashMask = ~self.bitMask
		let encryptedInt = (hashedInt & hashMask) + plainInt
		
		return encryptedInt
		
	}
	
	public func decrypt(encryptedInt: Int, withAdditionalIdentifier identifier: Int = 1) -> Int? {
		
		let plainInt = encryptedInt & self.bitMask
		
		guard self.encrypt(plainInt, withAdditionalIdentifier: identifier) == encryptedInt else {
			return nil
			
		}
		
		return plainInt
		
	}
	
}
