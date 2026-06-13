// Downloads bundled Google Fonts used by cover generation.
//
// Run from book_cover_designer_flutter:
//   dart run tool/download_cover_fonts.dart
//
// Font files are saved to assets/google_fonts/ with names expected by the
// google_fonts package (e.g. Roboto-Bold.ttf).

import 'dart:io';

typedef _FontAsset = ({String family, String filenamePart, String hash});

/// Variants used by cover generation (weights 400–900, normal + italic).
const _assets = <_FontAsset>[
  // Roboto
  (family: 'Roboto', filenamePart: 'Regular', hash: 'd1d7c5f4500eeb1a09e051781906c3642015a3f6c9b69046b905c8bf34c6ad60'),
  (family: 'Roboto', filenamePart: 'Italic', hash: '02323a7160fcc356c056f7167dc9fdea07b9573ec2e8720914c6c2128be051f0'),
  (family: 'Roboto', filenamePart: 'Bold', hash: '05b2d0935046846efe2c8786ad1c5d909a11c3431787eea52f2fc70f2a8a6edf'),
  (family: 'Roboto', filenamePart: 'BoldItalic', hash: 'ac35b475460fbf9d94b44ba54ee3d3e7e208c75705f4c6acb7781d0d94cdeb63'),
  (family: 'Roboto', filenamePart: 'Black', hash: 'b1839e6182fe1be6a6f6ae74edaa1aa16d27b9787ff44aeef04baa0ba2404a9d'),
  (family: 'Roboto', filenamePart: 'BlackItalic', hash: '4d7232f96ac551205759111c413af725e706eacab3477e429b72b66c74ecdf0a'),

  // Merriweather
  (family: 'Merriweather', filenamePart: 'Regular', hash: '17eea3c23dedc67e39cc162b4f95c5927f415be23f01181d6441a821401f2e40'),
  (family: 'Merriweather', filenamePart: 'Italic', hash: 'a01ca4baf4746b17b8c5c2e403ac0943ad6e2af8451c1651ea770f16cf8c06e0'),
  (family: 'Merriweather', filenamePart: 'Bold', hash: '5ffd149f337f5b52c2f4fcc0de5d543697fceac78b416e230def6b7c02c81ea9'),
  (family: 'Merriweather', filenamePart: 'BoldItalic', hash: 'ba796e3f7bbbf053447975f5e4e72ae4a8c01a0c109a688bc7d80836c6270344'),
  (family: 'Merriweather', filenamePart: 'Black', hash: '0c0a81948fc4e537d93d6b935abe73b2a89ec9cfd6d9c48bf9787c8627aaf16c'),
  (family: 'Merriweather', filenamePart: 'BlackItalic', hash: 'ddc6eda15dc3b4c34cf815954a5ee4af26282332b5baf09c8a938143d7ae956b'),

  // Roboto Mono
  (family: 'RobotoMono', filenamePart: 'Regular', hash: '98e94e15e13718555a10299bb96017f6e50a69f47ff61899b1d9e1a86b5fac7f'),
  (family: 'RobotoMono', filenamePart: 'Italic', hash: '07884a6dc8021a2eef997774bf83e0c67f13985e3f61797ce0eaa38d672c9038'),
  (family: 'RobotoMono', filenamePart: 'Bold', hash: '10e89cd69daf71a7c64dbcc00f694dbbff3c234f4d4aaf12709e67f4d1b0e8d7'),
  (family: 'RobotoMono', filenamePart: 'BoldItalic', hash: '4110df6eb9855f4b1b509dee1597dce8a7beb522ab4fc46cc317e88d76dc45d2'),
  (family: 'RobotoMono', filenamePart: 'SemiBold', hash: '77a88f0807b9af22ca1caa4c3ab778f5c2513c60fde26c1701f80cb473262294'),
  (family: 'RobotoMono', filenamePart: 'SemiBoldItalic', hash: '2427ed57d03c2d128127429ef4de10ba21826a6992de2bb7b096ed45387876f7'),

  // Ibarra Real Nova
  (family: 'IbarraRealNova', filenamePart: 'Regular', hash: '2bb1c4e2df79f3ce5912a4cc064fd07372f7ba7290f501296392d3d85750e5af'),
  (family: 'IbarraRealNova', filenamePart: 'Italic', hash: '5982d9a28ebc2215a2f4b0fd9cbbbb94960dd036b1d97504205062ccb7ff0b3c'),
  (family: 'IbarraRealNova', filenamePart: 'SemiBold', hash: '4bf692aaba03b79077df7d951e2678c00ad5562caa89d87b82cd087d9be3f5af'),
  (family: 'IbarraRealNova', filenamePart: 'SemiBoldItalic', hash: '820217cd6d690220ce3a13828d215e510d765191e67aba8a960bc2cba25a6aae'),
  (family: 'IbarraRealNova', filenamePart: 'Bold', hash: 'bb79240c20a7c66682c6ad589090801f37c19d036997076c67b13c81d7ad2ed4'),
  (family: 'IbarraRealNova', filenamePart: 'BoldItalic', hash: '45030721016c97ad1404cb439696e949c00d7f47b41e5603c44ad8bb2f3eefa9'),

  // Square Peg (single weight)
  (family: 'SquarePeg', filenamePart: 'Regular', hash: 'f7ccc2e51e141c90cecbb0111cc3418c0524dbd483c9690ab1a11b85032c1650'),

  // Nunito
  (family: 'Nunito', filenamePart: 'Regular', hash: '6f96017e762896b4cf3c2db345d41d7a72a3720a95698c3cd47020bf433db435'),
  (family: 'Nunito', filenamePart: 'Italic', hash: 'df3c491d67e881e1b0c6265a7a8364f07e38d7a25893e9b2beac1439e1c2efd9'),
  (family: 'Nunito', filenamePart: 'Bold', hash: '8148a236e4127dad38346ce596c544389aa2fdaaa9f311e589741de30d25ddb8'),
  (family: 'Nunito', filenamePart: 'BoldItalic', hash: '1d9670625be9c432a93d3467f99c5aa3e5626181c27d6d9a27285781539dfd83'),
  (family: 'Nunito', filenamePart: 'ExtraBold', hash: '43364ac2d05d1033b5e255ce77e4d84d2f6467bfadb5e5985ca4e688949e73bf'),
  (family: 'Nunito', filenamePart: 'ExtraBoldItalic', hash: '170f35fc695e39b13b53b58452f1a9e334277f3633c4ab89346db743b6b4923f'),
  (family: 'Nunito', filenamePart: 'Black', hash: 'a5ddd59da28c281984ae3bd12aa3b9af3b204e61156e50f1108d5fcf71aa5665'),
  (family: 'Nunito', filenamePart: 'BlackItalic', hash: '3fff73610e77b1bca1edd861e4830865d147de46cffc685fb253cb050b1148a5'),

  // Pacifico (single weight)
  (family: 'Pacifico', filenamePart: 'Regular', hash: 'd00add3a7d91f903eb33bcb08d397693c60d68bb5673410ba279a83490f8b054'),
];

Future<void> main() async {
  final outputDir = Directory('assets/google_fonts');
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  final client = HttpClient();
  var downloaded = 0;
  var skipped = 0;

  for (final asset in _assets) {
    final filename = '${asset.family}-${asset.filenamePart}.ttf';
    final file = File('${outputDir.path}/$filename');
    if (file.existsSync()) {
      skipped++;
      continue;
    }

    final url = Uri.parse('https://fonts.gstatic.com/s/a/${asset.hash}.ttf');
    stdout.writeln('Downloading $filename ...');
    final request = await client.getUrl(url);
    final response = await request.close();
    if (response.statusCode != 200) {
      stderr.writeln('Failed to download $filename (${response.statusCode})');
      exitCode = 1;
      continue;
    }

    final bytes = await response.fold<List<int>>(
      <int>[],
      (previous, element) => previous..addAll(element),
    );
    await file.writeAsBytes(bytes);
    downloaded++;
  }

  client.close(force: true);
  stdout.writeln('Done. Downloaded $downloaded, skipped $skipped existing.');
}
