import 'package:flutter/material.dart';
import 'package:site_blackboard_app/bloc/bloc_base.dart';

/// Blocプロバイダー
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final T bloc;
  final Widget child;
  final bool useDispose;
  final bool useSuperContext;

  BlocProvider(
      {Key key,
      @required this.child,
      @required this.bloc,
      this.useDispose: true,
      this.useSuperContext: true})
      : super(key: key);

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  /// Blocを取得
  static T of<T extends BlocBase>(BuildContext context) {
    BlocProvider<T> provider =
        context.findAncestorWidgetOfExactType<BlocProvider<T>>();
    return provider?.bloc;
  }

  // /// APPコンポーネントを取得
  // static AppComponent getAppComponent(BuildContext context) {
  //   return context.findAncestorWidgetOfExactType<AppComponent>();
  // }
  //
  // /// アプリを取得
  // static App getApp(BuildContext context) {
  //   return getAppComponent(context).app;
  // }
  //
  // /// ルートを取得
  // static Router getRouter(BuildContext context) {
  //   return getApp(context).router;
  // }
  //
  // /// ページ切り替え
  // static void navigateTo(BuildContext context, String url,
  //     {Map<String, dynamic> params,
  //     bool replace = false,
  //     bool clearStack = false,
  //     TransitionType transition,
  //     Duration transitionDuration = const Duration(milliseconds: 250),
  //     RouteTransitionsBuilder transitionBuilder}) {
  //   String uri = Uri(path: url, queryParameters: params ?? {}).toString();
  //   getRouter(context).navigateTo(context, uri,
  //       replace: replace,
  //       clearStack: clearStack,
  //       transition: transition,
  //       transitionDuration: transitionDuration,
  //       transitionBuilder: transitionBuilder);
  // }
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override
  void dispose() {
    if (widget.useDispose) widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useSuperContext) widget.bloc.superContext = context;
    return widget.child;
  }
}
