import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class DeepLinkRouter {
  final GlobalKey<NavigatorState> navigatorKey;

  DeepLinkRouter(this.navigatorKey);

  String? parseRouteFromUri(Uri? uri) {
    if (uri == null || uri.pathSegments.isEmpty) return null;

    if (uri.pathSegments.first == 'app' && uri.pathSegments.length > 1) {
      return '/${uri.pathSegments[1]}';
    }
    return null;
  }

  void handleDeepLink(String route, {Map<String, String>? queryParams}) {
    switch (route) {
      case "/dashboard":
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => const LearnDashboard()),
        );
        break;
      case "/courses":
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => const CoursesListPage(courses: [])),
        );
        break;
      case "/courseById":
        final courseId = int.tryParse(queryParams?['courseId'] ?? '');
        if (courseId != null) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
                builder: (_) => CourseDetailsPage(courseId: courseId)),
          );
        }
        break;
      case "/flowById":
        final flowId = int.tryParse(queryParams?['flowId'] ?? '');
        if (flowId != null) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
                builder: (_) => Scaffold(
                    body: SafeArea(
                        child:
                            WidgetPage(topicUserModel: null, flowId: flowId)))),
          );
        }
        break;
      case "/topicById":
        final topicId = int.tryParse(queryParams?['topicId'] ?? '');
        if (topicId != null) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
                builder: (_) => TopicDetailPage(topicId: topicId)),
          );
        }
        break;
      case "/openSideDrawer":
        final tagId = int.tryParse(queryParams?['tagId'] ?? '');
        final source = queryParams?['source'];
        final context = navigatorKey.currentContext;
        if (tagId != null && context != null) {
          TradeableRightSideDrawer.open(
            context: context,
            drawerBorderRadius: 24,
            body: TopicListPage(
              tagId: tagId,
              onClose: () => Navigator.of(context).pop(),
              showBottomButton: false,
              source: source,
            ),
          );
        }
        break;
      case "/userActivity":
        navigatorKey.currentState?.push(
          MaterialPageRoute(
              builder: (_) => UserActivityScreen(
                    progressItems: const [],
                    updateProgress: () {},
                  )),
        );
        break;
    }
  }
}
