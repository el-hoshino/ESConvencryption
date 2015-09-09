# ESConvencryption
A very convenient but not guaranteed way to encrypt and decrypt Int values.


#Notice
This framework is not a new algrithm to encrypt / decrypt data, but a combination of the existing algorithms to encrypt / decrypt an Int value fast and basically reliable. One of the uses is to encrypt some user data before saving, and decrypt the it after loaded to check if the data is valid that is not modified by user directly. It uses the identifierForVendor's hash value as a common key, which means your user shouldn't be able to get this key directly, different devices should generate different keys. But on the other hand, it also means that if your user has removed all the apps published from you, next time the device will generate a new key that won't be valid for the exist data, so you need to store the correct data in another place, like your own server. And another important information is that the default bitMask is 0xFFFF which is the same value as UInt16.max, the value you're trying to save should be less than this value, otherwise you need to specify the bitMask before creating the instance. And of course you need to make sure that the new bitMask has a larger flag field than the value you're trying to save.

#Instruction
This framework uses the device's identifierForVendor as a common key, and defaultly 0xFFFF as a bit mask to encrypt and decrypt the data you need to save.

When encrypting the value, first it will test if the value you're trying to save is less than the bit mask, which is very important for decryption. If not, it returns nil. Else, it multiplies the value with common key, and generate another hash number from the result's string. Then the encrypter applies the bit mask's opposite value to the hash number, and add the original value to it as the encrypted value. At this time, if you apply the bit mask to the encrypted value, you should get the original value.

And when decrypting the value, like above it just needs to apply the bit mask, but the more important thing is to check if this value is valid. So it encrypts the decrypted value again to see if it can generate the same encrypted value. If yes, it passes. Else, the decrypter treats it as an invalid value, and returns nil.

Basically since user is not able to get the device's identifierForVendor value, he's not able to get the correct common key. Also, since it uses the hash value of the string of int, it's even more difficult to attack the algorithm. In addition, since we're only using a part of the hash value, the user is even not able to get the correct hash value. So basically as long as the user doesn't track this system he shouldn't be able to crack this encryption.

#Usage
1. Download this framework project, and import it to your own project.
2. Add this framework in the Linked Frameworks and Libraries settings of your XCode project settings.
3. Import ESConvencryption to the source code file that you need to encrypt / decrypt a user generated value.
4. Create an instance, using the syntax like `let endecrypter = ESCEnDecrypter()` or `let endecrypter = ESCEnDecrypter(bitMaskDigits: Int)` if you need to specify the bit mask digits (e.g. `(bitMaskDigits: 4)` will generate the mask of `0xF`, which is `0b1111` that has 4 digits if `1` in binary).
5. Encrypt the value using the syntax like `let encryptedNumber = endecrypter.encrypt(value)` or `let encryptedNumber = endecrypter.encrypt(value, withAdditionalIdentifier: identifier)` (Notice that if your `value` is larger than the bitmask, this method will return nil. Also if you specify the additional identifier, you need it to decrypt the value.)
6. Decrypt the value using the syntax like `let decryptedNumber = endecrypter.decrypt(encryptedValue)` or `let decryptedNumber = endecrypter.decrypt(encryptedValue, withAdditionalIdentifier: identifier)` (Notice that if the decrypter can't generate the same encrypted value as `encryptedValue`, this method will return nil. In addition if you can't provide the same identifier that you specified when you encrypted it, this method will also return nil since it can't generate the same value as `encryptedValue`).
7. Enjoy.
