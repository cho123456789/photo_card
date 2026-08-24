/// 바인더 생성 시 자동으로 만들 카드의 기본 정보입니다.
/// 실제 전체 목록은 추후 이 카탈로그만 교체하면 됩니다.
class CardTemplate {
  const CardTemplate({
    required this.album,
    required this.title,
    this.isCollaboration = false,
  });

  final String album;
  final String title;
  final bool isCollaboration;
}

class CardCatalog {
  const CardCatalog._();

  static const groups = <String, List<CardTemplate>>{
    'QWER': [
      CardTemplate(album: '기본 슬롯', title: '카드 1'),
      CardTemplate(album: '기본 슬롯', title: '카드 2'),
      CardTemplate(album: '기본 슬롯', title: '카드 3'),
      CardTemplate(album: '기본 슬롯', title: '카드 4'),
    ],
    '리센느': [
      CardTemplate(album: '기본 슬롯', title: '카드 1'),
      CardTemplate(album: '기본 슬롯', title: '카드 2'),
      CardTemplate(album: '기본 슬롯', title: '카드 3'),
      CardTemplate(album: '기본 슬롯', title: '카드 4'),
    ],
  };
}
