class AssetPaths {
  static String avoc = 'assets/images/avoc.jpg';
  static String cow = 'assets/images/cow.jpg';
  static String goat = 'assets/images/goat.jpg';
  static String hipo = 'assets/images/hipo.jpg';
  static String lion = 'assets/images/lion.jpg';
  static String pig = 'assets/images/pig.jpg';

  static List<String> assetsforgame = [
    avoc,
    avoc,
    cow,
    cow,
    goat,
    goat,
    hipo,
    hipo,
    lion,
    lion,
    pig,
    pig
  ];

  static List<String> get assets {
    assetsforgame.shuffle();
    return assetsforgame;
  }
}
