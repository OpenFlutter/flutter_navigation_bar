# navigation_bar

A new Flutter project.

## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).


##How to use ?

1. Depend on it
 
```yaml
dependencies:
  navigation_bar: "^0.0.1"
```

2. Install it
 
```sh
$ flutter packages get
```

3. Import it

```dart
import 'package:navigation_bar/navigation_tab_bar.dart';
```


##Example
```
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var accentBackgroundColors = const Color(0xffe71d36);
    return new NavigationTabBar(
      onTap: (value, previousIndex) {},
      tabBuilder: (BuildContext context, int index) {
        return new LoginScreen();
      },
      navigationViews: <NavigationPageView>[
        new NavigationPageView(
          icon: const Icon(Icons.home),
          title: '首页',
          color: const Color(0xffe71d36),
          vsync: this,
        ),
        new NavigationPageView(
          icon: const Icon(Icons.notifications),
          title: '卡包',
          color: accentBackgroundColors,
          vsync: this,
        ),
        new NavigationPageView(
          icon: const Icon(Icons.menu),
          title: '账户',
          color: accentBackgroundColors,
          vsync: this,
        ),
      ],
    );
  }
}
```