import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/topic_user_model.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/user_widgets_model.dart';
import 'package:tradeable_flutter_sdk/src/network/kagr_api.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/topic_header_page.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/widget_page.dart';

class TopicDetailPage extends StatefulWidget {
  final int moduleId;
  final TopicUserModel topic;

  const TopicDetailPage(
      {super.key, required this.moduleId, required this.topic});

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<bool> isExpanded = ValueNotifier(false);
  List<WidgetsModel>? widgets;

  void getFlowByFlowId(int flowId) async {
    setState(() {
      widgets = [];
    });
    await KagrApi()
        .fetchFlowById(widget.topic.topicId, flowId, widget.moduleId, 1)
        .then((val) {
      setState(() {
        widgets = (val.widgets ?? [])
            .map((e) => WidgetsModel(data: e.data, modelType: e.modelType))
            .toList();
      });
    });
  }

  @override
  void initState() {
    getFlowByFlowId(widget.topic.startFlow);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2A2929),
      body: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    TopicHeaderWidget(
                      topic: widget.topic,
                      moduleId: widget.moduleId,
                      onBack: () => Navigator.of(context).pop(),
                      onExpandChanged: (expanded) {
                        isExpanded.value = expanded.isExpanded;
                        if (expanded.flowId != widget.topic.startFlow) {
                          getFlowByFlowId(expanded.flowId);
                        }
                      },
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: isExpanded,
                      builder: (context, expanded, child) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            final slideAnimation = Tween<Offset>(
                              begin: const Offset(-1, 0),
                              end: Offset.zero,
                            ).animate(animation);
                            return SlideTransition(
                                position: slideAnimation, child: child);
                          },
                          child: expanded
                              ? const SizedBox.shrink()
                              // : Container(
                              //     height: constraints.maxHeight * 0.8,
                              //     margin: const EdgeInsets.symmetric(
                              //         horizontal: 10),
                              //     padding: const EdgeInsets.all(10),
                              //     child: ContainerLayoutWidget(
                              //       childWidget:
                              //           WidgetPage(widgets: widgets ?? []),
                              //     ),
                              //   ),
                              : Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  padding: const EdgeInsets.all(10),
                                  height: constraints.maxHeight * 0.88,
                                  child: WidgetPage(widgets: widgets ?? [])),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
            // ValueListenableBuilder<bool>(
            //   valueListenable: isExpanded,
            //   builder: (_, expanded, __) => expanded
            //       ? const SizedBox.shrink()
            //       : Positioned(
            //           bottom: 10,
            //           left: 20,
            //           right: 20,
            //           child: DoubleLayerButtonWidget(
            //               onClick: () {}, text: "Skip", isDisabled: true),
            //         ),
            // ),
          ],
        ),
      ),
    );
  }
}
