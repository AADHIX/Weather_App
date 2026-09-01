import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weatherapps/modules/weather/models/weather_model.dart';
import 'package:weatherapps/modules/weather/widgets/search_history_list.dart';
import 'package:weatherapps/modules/weather/widgets/weather_details_grid.dart';

void main() {
  testWidgets('Weather details grid uses a tighter aspect ratio and padding', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: WeatherDetailsGrid(weather: WeatherModel.demo())),
      ),
    );

    final grid = tester.widget<GridView>(find.byType(GridView));
    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

    expect(delegate.childAspectRatio, closeTo(1.05, 0.01));
    expect(grid.padding, const EdgeInsets.all(12));
  });

  testWidgets('Search history list stays stable when history is empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchHistoryList(
            history: const [],
            onSelectCity: (_) {},
            onDeleteItem: (_) {},
            onClearAll: () {},
          ),
        ),
      ),
    );

    expect(find.text('Popular Destinations'), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });
}
