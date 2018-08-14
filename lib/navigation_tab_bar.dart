import 'package:flutter/material.dart';
import 'package:navigation_bar/NavigationPageView.dart';

///value 当前页面,pre 上个页面index
typedef void IndexChanged<T>(T value, T previousIndex);

class NavigationTabBar extends StatefulWidget {
  final List<NavigationPageView> navigationViews;
  final IndexedWidgetBuilder tabBuilder;
  final IndexChanged onTap;

  const NavigationTabBar({
    Key key,
    @required this.navigationViews,
    @required this.tabBuilder,
    @required this.onTap,
  }) : super(key: key);

  @override
  NavigationTabBarState createState() => NavigationTabBarState();
}

class NavigationTabBarState extends State<NavigationTabBar> {
  BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  int _currentPage;
  int _prePage;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _prePage = 0;
  }

  setCurrentPage(int currentIndex) {
    setState(() {
      _prePage = _currentPage;
      _currentPage = currentIndex;
      if (widget.onTap != null) widget.onTap(_currentPage, _prePage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
      items: widget.navigationViews
          .map((NavigationPageView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentPage,
      type: _type,
      onTap: (int index) {
        setState(() {
          widget.navigationViews[_currentPage].controller.reverse();
          var currentPage = index;
          widget.navigationViews[_currentPage].controller.forward();
          setCurrentPage(currentPage);
        });
      },
    );
    Widget content = new _TabSwitchingView(
      currentTabIndex: _currentPage,
      tabNumber: widget.navigationViews.length,
      tabBuilder: widget.tabBuilder,
    );
    return new Scaffold(
      body: content,
      bottomNavigationBar: botNavBar,
    );
  }
}

class _TabSwitchingView extends StatefulWidget {
  const _TabSwitchingView({
    @required this.currentTabIndex,
    @required this.tabNumber,
    @required this.tabBuilder,
  })  : assert(currentTabIndex != null),
        assert(tabNumber != null && tabNumber > 0),
        assert(tabBuilder != null);

  final int currentTabIndex;
  final int tabNumber;
  final IndexedWidgetBuilder tabBuilder;

  @override
  _TabSwitchingViewState createState() => new _TabSwitchingViewState();
}

class _TabSwitchingViewState extends State<_TabSwitchingView> {
  List<Widget> tabs;
  List<FocusScopeNode> tabFocusNodes;

  @override
  void initState() {
    super.initState();
    tabs = new List<Widget>(widget.tabNumber);
    tabFocusNodes = new List<FocusScopeNode>.generate(
      widget.tabNumber,
      (int index) => new FocusScopeNode(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _focusActiveTab();
  }

  @override
  void didUpdateWidget(_TabSwitchingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _focusActiveTab();
  }

  void _focusActiveTab() {
    FocusScope.of(context).setFirstFocus(tabFocusNodes[widget.currentTabIndex]);
  }

  @override
  void dispose() {
    for (FocusScopeNode focusScopeNode in tabFocusNodes) {
      focusScopeNode.detach();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: new List<Widget>.generate(widget.tabNumber, (int index) {
        final bool active = index == widget.currentTabIndex;

        if (active || tabs[index] != null) {
          tabs[index] = widget.tabBuilder(context, index);
        }

        return new Offstage(
          offstage: !active,
          child: new TickerMode(
            enabled: active,
            child: new FocusScope(
              node: tabFocusNodes[index],
              child: tabs[index] ?? new Container(),
            ),
          ),
        );
      }),
    );
  }
}
