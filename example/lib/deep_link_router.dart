import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/learn_dashboard.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/courses_list_screen.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/course_details_screen.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/widget_page.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class DeepLinkRouter {
  final GlobalKey<NavigatorState> navigatorKey;

  DeepLinkRouter(this.navigatorKey);

  String? parseRouteFromUri(Uri? uri) {
    if (uri != null &&
        uri.pathSegments.isNotEmpty &&
        uri.pathSegments.first == 'app') {
      if (uri.pathSegments.length > 1) {
        return '/${uri.pathSegments[1]}';
      }
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
          MaterialPageRoute(
              builder: (_) => const CoursesListScreen(courses: [])),
        );
        break;
      case "/courseById":
        final courseIdStr = queryParams?['courseId'];
        final courseId = courseIdStr != null ? int.tryParse(courseIdStr) : null;
        if (courseId != null) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
                builder: (_) => CourseDetailsScreen(courseId: courseId)),
          );
        }
        break;
      case "/flowById":
        final flowIdStr = queryParams?['flowId'];
        final flowId = flowIdStr != null ? int.tryParse(flowIdStr) : null;
        if (flowId != null) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
                builder: (_) => Scaffold(
                    body: SafeArea(
                        child: WidgetPage(topicId: null, flowId: flowId)))),
          );
        }
        break;
      case "/topicById":
        final topicIdStr = queryParams?['topicId'];
        final topicId = topicIdStr != null ? int.tryParse(topicIdStr) : null;
        if (topicId != null) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
                builder: (_) => TopicDetailPage(topicId: topicId)),
          );
        }
        break;
    }
  }
}
