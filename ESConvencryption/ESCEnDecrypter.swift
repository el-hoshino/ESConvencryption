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

/// Use this struct to encrypt and decrypt Int values.
///
/// To initialize just juse the syntax below:
///
/// `let endecrypter = ESCEnDecrypter()` or `let endecrypter = ESCEnDecrypter(bitMaskDigit: 12)`
///
/// - Parameter bitMaskDigit: The number of digits of the bit mask. Default value is 16, which generates the mask of 0xFFFF
public struct ESCEnDecrypter {
	
	private let hashedUUID = UIDevice.currentDevice().identifierForVendor?.hash ?? 1
	private let bitMask: Int
	
	/// Initializes the ESCEnDecrypter instance.
	///
	/// - Parameter bitMaskDigit: The number of digits of the bit mask. Default value is 16, which generates the mask of 0xFFFF
	public init(bitMaskDigits: Int = 16) {
		let bitMask = [Int](0 ..< bitMaskDigits).reduce(0) { $0 + (1 << $1) }
		self.bitMask = bitMask
	}
	
	/// Use this method to encrypt the value.
	///
	/// - Parameter plainInt: The input value you'd like to encrypt. Notice that this value should be able to get the same value after applying the bit mask (which simply means the input value should be smaller than the bit mask).
	///
	/// - Parameter identifier: An additional identifier for encrypting data. You may set different identifiers for different parameters you're encrypting so that the same value for different parameter can get a different encrypted value. Default identifier value is 1.
	///
	/// - Returns: The encrypted Int value, or nil if the plainInt is not able to get the same value after applying the bit mask.
	public func encrypt(plainInt: Int, withAdditionalIdentifier identifier: Int = 1) -> Int? {
		
		guard (plainInt & self.bitMask) == plainInt else {
			return nil
		}
		
		let hashedInt = (self.hashedUUID &* identifier &* plainInt).description.hash
		let hashMask = ~self.bitMask
		let encryptedInt = (hashedInt & hashMask) + plainInt
		
		return encryptedInt
		
	}
	
	/// Use this method to decrypt the value.
	///
	/// - Parameter plainInt: The input value you'd like to decrypt.
	///
	/// - Parameter identifier: An additional identifier for decrypting data, which should be the same as the one you used to encrypt it. Default identifier value is the same as encrypt() method's value which is 1.
	///
	/// - Returns: The decrypted Int value, or nil if the decrypter can't generate the same value as input value from the decrypted value which is considered as invalid value.
	public func decrypt(encryptedInt: Int, withAdditionalIdentifier identifier: Int = 1) -> Int? {
		
		let plainInt = encryptedInt & self.bitMask
		
		guard self.encrypt(plainInt, withAdditionalIdentifier: identifier) == encryptedInt else {
			return nil
			
		}
		
		return plainInt
		
	}
	
}
