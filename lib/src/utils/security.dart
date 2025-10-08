import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';

String encryptData(dynamic data, String secretKey) {
  try {
    if (data == null) {
      return encryptData('null', secretKey);
    }

    // Convert data to JSON string if it's not already a string
    final payload = data is String ? data : jsonEncode(data);

    // Derive a proper 256-bit key from the secret key using SHA-256
    final keyBytes = sha256.convert(utf8.encode(secretKey)).bytes;
    final key = Key(Uint8List.fromList(keyBytes));

    // Create encrypter with GCM mode
    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));

    // Generate random nonce (IV)
    final iv = IV.fromSecureRandom(16);

    // Encrypt the payload
    final encrypted = encrypter.encrypt(payload, iv: iv);

    // Get the authentication tag (last 16 bytes of encrypted.bytes in GCM)
    final ciphertext = encrypted.bytes.sublist(0, encrypted.bytes.length - 16);
    final tag = encrypted.bytes.sublist(encrypted.bytes.length - 16);

    // Encode nonce, tag, and ciphertext as base64
    final encodedNonce = base64Encode(iv.bytes);
    final encodedTag = base64Encode(tag);
    final encodedCiphertext = base64Encode(ciphertext);

    // Return in format: nonce.tag.ciphertext
    return '$encodedNonce.$encodedTag.$encodedCiphertext';
  } catch (e) {
    throw Exception('Encryption failed: $e');
  }
}

/// Decrypts data from format "nonce.tag.ciphertext" and returns dynamic data
dynamic decryptData(String encryptedData, String secretKey) {
  try {
    // Split the encrypted data by '.'
    final parts = encryptedData.split('.');
    if (parts.length != 3) {
      throw Exception(
          'Invalid encrypted data format. Expected: nonce.tag.ciphertext');
    }

    // Decode base64 parts
    final nonce = base64Decode(parts[0]);
    final tag = base64Decode(parts[1]);
    final ciphertext = base64Decode(parts[2]);

    // Combine ciphertext and tag (GCM expects them together)
    final combinedBytes = Uint8List.fromList([...ciphertext, ...tag]);

    // Derive a proper 256-bit key from the secret key using SHA-256
    final keyBytes = sha256.convert(utf8.encode(secretKey)).bytes;
    final key = Key(Uint8List.fromList(keyBytes));

    // Create encrypter with GCM mode
    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));

    // Create IV from nonce
    final iv = IV(Uint8List.fromList(nonce));

    // Decrypt
    final decrypted = encrypter.decrypt(
      Encrypted(combinedBytes),
      iv: iv,
    );

    // Handle null case
    if (decrypted == 'null') {
      return null;
    }

    // Try to parse as JSON and return as dynamic
    try {
      return jsonDecode(decrypted);
    } catch (_) {
      // If not JSON, return as string
      return decrypted;
    }
  } catch (e) {
    throw Exception('Decryption failed: $e');
  }
}
