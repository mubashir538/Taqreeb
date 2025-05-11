import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class TransitionHelper {
  static Future<void> pushNamedReplacement({
    required BuildContext context,
    required String routeName,
    required PageTransitionType transitionType,
    Object? arguments,
    int durationMs = 300,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
    required RouteFactory onGenerateRoute,
  }) async {
    // Generate the route using the app's route generator
    final Route<dynamic>? route = onGenerateRoute(
      RouteSettings(
        name: routeName,
        arguments: arguments,
      ),
    );

    if (route != null) {
      // Get the widget builder from the route
      final WidgetBuilder pageBuilder = _getPageBuilderFromRoute(route);

      // Use the transition
      await Navigator.of(context).pushReplacement(
        PageTransition(
          type: transitionType,
          duration: Duration(milliseconds: durationMs),
          child: Builder(
            builder: (context) => pageBuilder(context),
          ),
          settings:
              settings ?? RouteSettings(name: routeName, arguments: arguments),
        ),
      );
    } else {
      throw Exception('Route $routeName not found');
    }
  }

  static WidgetBuilder _getPageBuilderFromRoute(Route<dynamic> route) {
    if (route is MaterialPageRoute) {
      return route.builder;
    } else if (route is PageRouteBuilder) {
      // For PageRouteBuilder, we need to extract the page builder
      return (BuildContext context) {
        return route.pageBuilder(
          context,
          route.animation!,
          route.secondaryAnimation!,
        );
      };
    }
    throw Exception('Unsupported route type: ${route.runtimeType}');
  }
}
