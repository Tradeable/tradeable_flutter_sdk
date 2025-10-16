import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart' hide Mac;
import 'package:asn1lib/asn1lib.dart';
import 'package:cryptography/cryptography.dart';

Future<String> encryptAes(String secretKey, String payload) async {
  // Convert secret key and payload to bytes
  List<int> secretKeyBytes = utf8.encode(secretKey);
  List<int> payloadBytes = utf8.encode(payload);

  // Create AES-GCM cipher
  final algorithm = AesGcm.with256bits();

  // Create SecretKey
  final secretKeyObj = SecretKey(secretKeyBytes);

  final nonce = List<int>.generate(16, (i) => Random.secure().nextInt(256));

  // Encrypt and generate authentication tag
  final secretBox = await algorithm.encrypt(
    payloadBytes,
    secretKey: secretKeyObj,
    nonce: nonce,
  );

  // Extract nonce, tag (MAC), and ciphertext
  List<int> nonceUsed = secretBox.nonce;
  // List<int> nonce = secretBox.nonce;
  // print(nonce.length);
  List<int> tag = secretBox.mac.bytes;
  List<int> ciphertext = secretBox.cipherText;

  // Encode to base64
  String encodedNonce = base64.encode(nonceUsed);
  String encodedTag = base64.encode(tag);
  String encodedCiphertext = base64.encode(ciphertext);

  // Return formatted string
  return '$encodedNonce.$encodedTag.$encodedCiphertext';
}

/// Decrypts data from format "nonce.tag.ciphertext" and returns dynamic data
Future<String> decryptData(String secretKey, String encodedPayload) async {
  // Convert secret key to bytes
  List<int> secretKeyBytes = utf8.encode(secretKey);

  // Split the encoded payload
  List<String> parts = encodedPayload.split('.');
  String encodedNonce = parts[0];
  String encodedTag = parts[1];
  String encodedCiphertext = parts[2];

  // Decode from base64
  List<int> nonce = base64.decode(encodedNonce);
  List<int> tag = base64.decode(encodedTag);
  List<int> ciphertext = base64.decode(encodedCiphertext);

  // Create AES-GCM cipher
  final algorithm = AesGcm.with256bits();

  // Create SecretKey
  final secretKeyObj = SecretKey(secretKeyBytes);

  // Create SecretBox (ciphertext + MAC/tag combined)
  final secretBox = SecretBox(
    ciphertext,
    nonce: nonce,
    mac: Mac(tag),
  );

  // Decrypt and verify
  final decryptedBytes = await algorithm.decrypt(
    secretBox,
    secretKey: secretKeyObj,
  );

  // Convert to string
  String decryptedPayload = utf8.decode(decryptedBytes);

  return decryptedPayload;
}

String generateSecretKey() {
  String secretKey = List.generate(16, (_) => Random.secure().nextInt(256))
      .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
      .join();
  return secretKey;
}

RSAPublicKey parsePublicKey(String pemString) {
  // Remove PEM header/footer and decode base64
  final pem = pemString
      .replaceAll('-----BEGIN PUBLIC KEY-----', '')
      .replaceAll('-----END PUBLIC KEY-----', '')
      .replaceAll('\n', '')
      .replaceAll('\r', '')
      .trim();

  final bytes = base64.decode(pem);

  // Parse ASN1 structure
  final asn1Parser = ASN1Parser(bytes);
  final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
  final publicKeyBitString = topLevelSeq.elements[1] as ASN1BitString;

  final publicKeyAsn = ASN1Parser(publicKeyBitString.contentBytes());
  final publicKeySeq = publicKeyAsn.nextObject() as ASN1Sequence;

  final modulus = (publicKeySeq.elements[0] as ASN1Integer).valueAsBigInteger;
  final exponent = (publicKeySeq.elements[1] as ASN1Integer).valueAsBigInteger;

  return RSAPublicKey(modulus, exponent);
}

String encryptRsa(String secretKey, String publicKey) {
  // Format the PEM string
  final pemString =
      '-----BEGIN PUBLIC KEY-----\n$publicKey\n-----END PUBLIC KEY-----';

  // Parse the public key
  final rsaPublicKey = parsePublicKey(pemString);

  // Create cipher with OAEP padding and SHA-256
  final cipher = OAEPEncoding.withSHA256(RSAEngine())
    ..init(
      true, // true for encryption
      PublicKeyParameter<RSAPublicKey>(rsaPublicKey),
    );

  // Encrypt the secret key
  final plainBytes = Uint8List.fromList(utf8.encode(secretKey));
  final encryptedBytes = cipher.process(plainBytes);

  // Encode to base64
  final encodedPayload = base64.encode(encryptedBytes);

  return encodedPayload;
}
