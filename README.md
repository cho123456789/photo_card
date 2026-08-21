# Pocket Binder

<p align="center">
  좋아하는 포토카드를 한 권씩, 나만의 방식으로 모아보세요.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Riverpod-00BFA5?style=flat-square" alt="Riverpod" />
  <img src="https://img.shields.io/badge/Platform-Android-3DDC84?style=flat-square&logo=android&logoColor=white" alt="Android" />
</p>

Pocket Binder는 포토카드 컬렉션을 바인더 단위로 정리하고, 카드의 보유 현황과 기록을 관리할 수 있는 Flutter 앱입니다. 사진을 촬영하거나 앨범에서 선택해 카드를 등록하고, 컬렉션의 완성도를 직관적으로 확인할 수 있습니다.

> 좋아하는 아티스트, 앨범, 이벤트별로 흩어진 포토카드를 한곳에 기록하고, 아직 모으지 못한 카드를 쉽게 파악하는 것을 목표로 합니다.

## 주요 기능

| 기능 | 설명 |
| --- | --- |
| 📚 바인더 관리 | 멤버·그룹별 바인더를 만들고 이름, 색상, 표지를 꾸밀 수 있어요. |
| 🃏 카드 컬렉션 | 카드 슬롯을 만들고 이름·버전·설명을 기록할 수 있어요. |
| 📷 사진 등록 | 카메라 스캔 또는 갤러리 사진을 포토카드 비율로 잘라 등록해요. |
| 📝 카드 기록 | 앨범, 입수처, 가격, 입수일, 메모를 카드별로 남길 수 있어요. |
| 📊 보유 통계 | 전체·바인더별 보유율, 남은 카드 수, 총 지출과 최근 등록 카드를 확인해요. |
| 💾 로컬 저장 | 바인더와 카드 정보는 기기 내 SQLite 데이터베이스에 저장돼요. |

## 화면별 안내

### 1. 바인더 홈

- 전체 바인더를 표지 형태로 둘러볼 수 있습니다.
- 새 바인더를 만들고, 이름 변경·삭제·표지 꾸미기를 할 수 있습니다.
- 각 바인더 표지의 진행 바로 현재 보유한 카드 수를 빠르게 확인할 수 있습니다.

### 2. 바인더 상세

- 바인더 안에 수집할 포토카드 슬롯을 추가합니다.
- 등록이 끝난 카드는 사진과 함께 표시되고, 미보유 카드는 빈 슬롯으로 남습니다.
- 여러 카드를 선택해 한 번에 삭제하거나, 카드별 기록을 수정할 수 있습니다.

### 3. 카드 등록 및 기록

- 카메라로 포토카드를 촬영하거나 기기 앨범에서 사진을 가져옵니다.
- 사진은 포토카드 비율에 맞춰 자른 뒤 저장됩니다.
- 카드 이름, 버전, 설명과 함께 앨범·입수처·가격·입수일·메모를 남길 수 있습니다.

### 4. 통계

- 전체 보유율과 `보유 장수 / 전체 장수 / 남은 장수`를 함께 확인할 수 있습니다.
- 바인더별 완성도와 총 지출, 최근 등록 카드를 제공합니다.

## 기술 스택

- **Framework**: Flutter, Dart
- **State management**: Riverpod
- **Local database**: SQLite (`sqflite`)
- **Image**: `image_picker`, `image_cropper`, ML Kit document scanner
- **Architecture**: Presentation · Domain · Data 레이어 분리

## 설계 포인트

### 상태 관리

`BinderNotifier`가 바인더 목록, 선택한 바인더, 카드 상태를 한곳에서 관리합니다. 화면은 Riverpod provider를 구독해 변경된 데이터를 즉시 반영합니다.

### 데이터 저장

앱은 네트워크 계정이나 서버 없이 동작합니다. 바인더와 카드 메타데이터는 SQLite에, 카드·표지 사진은 앱의 로컬 저장소에 보관합니다. 따라서 오프라인에서도 컬렉션을 계속 관리할 수 있습니다.

### 레이어 구조

- **Presentation**: 화면, 위젯, 사용자 입력, Riverpod 상태
- **Domain**: `MemberBinder`, `PhotoCard` 같은 엔티티와 유스케이스
- **Data**: SQLite 저장소, 사진 선택·자르기·스캔 구현체

## 시작하기

### 준비 사항

- Flutter SDK `3.11.1` 이상
- Android Studio 또는 Android SDK가 설치된 개발 환경

### 실행

```bash
git clone <repository-url>
cd flutter_study
flutter pub get
flutter run
```

### 유용한 명령어

```bash
# 정적 분석
flutter analyze

# 테스트 실행
flutter test

# Android APK 빌드
flutter build apk
```

## 사용 흐름

1. 홈 화면에서 새 바인더를 만듭니다.
2. 바인더 안에 수집할 포토카드 슬롯을 추가합니다.
3. 카드 사진을 촬영하거나 갤러리에서 선택해 등록합니다.
4. 통계 화면에서 보유율과 남은 카드 수를 확인합니다.

## 프로젝트 구조

```text
lib/
└── feature/
    ├── data/           # SQLite, 이미지 스캔 등 구현체
    ├── domain/         # 엔티티, 저장소 계약, 유스케이스
    └── presentation/   # Riverpod 상태와 Flutter UI
```

## Android 권한

포토카드 촬영 기능을 위해 카메라 권한을 요청합니다. 갤러리에서 사진을 선택할 때는 Android 시스템 사진 선택기를 사용합니다. 권한을 허용하지 않아도 이미 등록된 컬렉션을 조회하고 편집할 수 있습니다.

## 데이터 안내

### 저장되는 항목

- 바인더 이름, 그룹, 테마 색상, 표지 정보
- 카드 이름, 버전, 설명, 보유 여부
- 카드 기록: 앨범, 입수처, 가격, 입수일, 메모
- 등록한 카드 사진과 표지 사진

### 유의 사항

컬렉션 정보와 등록 사진은 사용 중인 기기에만 저장됩니다. 앱을 삭제하거나 앱 데이터를 초기화하면 해당 데이터도 함께 삭제될 수 있습니다.

현재는 클라우드 동기화와 자동 백업을 제공하지 않습니다. 기기를 변경하거나 앱을 삭제하기 전에는 중요한 사진과 기록을 별도로 보관해 주세요.

## 향후 개선 아이디어

- 컬렉션 데이터 내보내기·가져오기 및 백업
- 아티스트·앨범·시즌별 필터와 검색
- 위시리스트와 카드 교환 목록
- 다크 모드 및 태블릿 레이아웃

---

<p align="center">Collect the moments you love. ✨</p>
