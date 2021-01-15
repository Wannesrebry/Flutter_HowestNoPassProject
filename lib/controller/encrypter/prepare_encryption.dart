import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class PrepareForEncryption{

  SecureRandom secureRandom() {
    final secureRandom = FortunaRandom();

    final seedSource = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(255));
    }
    print(seeds);
    print(seeds.length);
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    return secureRandom;
  }

  SecureRandom secureSeed(List<String> seeds){
    final secureRandom = FortunaRandom();
    List<int> uInt8Seed = stringToUint8(seeds);
    if(uInt8Seed != null){
      secureRandom.seed(KeyParameter(uInt8Seed));
      return secureRandom;
    }else return null;
  }

  Uint8List stringToUint8(List<String> stringArray){
    List<int> res = [];
    stringArray.forEach((word) {
      word.runes.forEach((char) {
        var temp = char.toString().toLowerCase();
        var uint8 = int.parse(temp) %256;
        res.add(uint8);
      });
    });
    if(res.length == 32)
      return Uint8List.fromList(res);
    else return null;
  }
}