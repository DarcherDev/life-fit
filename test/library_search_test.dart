import 'package:flutter_test/flutter_test.dart';

import 'package:life_fit/shared/utils/library_search.dart';

void main() {
  test('filterLibraryItems devuelve todo sin consulta', () {
    const items = ['Sentadilla', 'Press'];
    expect(
      filterLibraryItems<String>(
        items: items,
        query: '',
        titleFor: (item) => item,
      ),
      items,
    );
  });

  test('filterLibraryItems busca en título y subtítulo', () {
    final items = [
      _Item(title: 'Sentadilla Copa', subtitle: '4 series x 12'),
      _Item(title: 'Press Banca', subtitle: '4 series x 10'),
    ];

    expect(
      filterLibraryItems<_Item>(
        items: items,
        query: 'copa',
        titleFor: (item) => item.title,
        subtitleFor: (item) => item.subtitle,
      ).map((item) => item.title),
      ['Sentadilla Copa'],
    );

    expect(
      filterLibraryItems<_Item>(
        items: items,
        query: 'series',
        titleFor: (item) => item.title,
        subtitleFor: (item) => item.subtitle,
      ),
      hasLength(2),
    );
  });
}

class _Item {
  const _Item({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}
