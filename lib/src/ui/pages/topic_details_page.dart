import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_user_model.dart';
import 'package:tradeable_flutter_sdk/src/models/user_widgets_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/flow_controller.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/widget_page.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/flows_bottom_sheet.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class TopicDetailPage extends StatefulWidget {
  final TopicUserModel? topic;
  final int? topicId;

  const TopicDetailPage({super.key, this.topic, this.topicId});

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  bool isExpanded = false;
  List<WidgetsModel>? widgets;
  int? flowId;
  TopicUserModel? _topicUserModel;
  bool _loading = false;

  int completedFlows = 0;
  int totalFlows = 0;

  @override
  void initState() {
    super.initState();
    if (widget.topic != null) {
      _topicUserModel = widget.topic;
      flowId = _topicUserModel!.startFlow;
      if (flowId == null) {
        getFlows();
      }
      completedFlows = _topicUserModel!.progress.completed ?? 0.toInt();
      totalFlows = _topicUserModel!.progress.total ?? 0.toInt();
    } else if (widget.topicId != null) {
      _fetchTopicUserModel();
    }
  }

  Future<void> _fetchTopicUserModel() async {
    setState(() {
      _loading = true;
    });
    final topic = await API().fetchTopicById(widget.topicId!, 33);
    _topicUserModel = TopicUserModel.fromTopic(topic);
    flowId = _topicUserModel!.startFlow;
    if (flowId == null) {
      await getFlows();
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> getFlows() async {
    if (_topicUserModel == null) return;
    final val = await API()
        .fetchTopicById(_topicUserModel!.topicId, _topicUserModel!.topicTagId);
    setState(() {
      flowId ??= val.flows!.first.id;
      completedFlows = (val.flows ?? []).where((f) => f.isCompleted).length;
      totalFlows = (val.flows ?? []).length;
      print(completedFlows);
      print(totalFlows);
    });
    FlowController().registerCallback((highlightNextFlow) {
      setState(() {
        isExpanded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    if (_topicUserModel == null || _loading) {
      return Scaffold(
        backgroundColor: colors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
        backgroundColor: widget.topic?.cardColor ?? Colors.white,
        appBar: renderAppBar(),
        body: SafeArea(
          child: WidgetPage(
              topicId: _topicUserModel!.topicId,
              flowId: flowId ?? -1,
              onMenuClick: () {
                updateFlowComplete();
                showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  barrierColor: Colors.black.withAlpha((0.3 * 255).round()),
                  context: context,
                  builder: (context) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 100,
                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                        ),
                        child: FlowsBottomSheet(
                          topic: _topicUserModel!,
                          onFlowItemClicked: (id) => setState(() {
                            flowId = id;
                          }),
                        ),
                      ),
                    );
                  },
                );
              }),
        ));
    // return Scaffold(
    //   backgroundColor: colors.background,
    //   body: SafeArea(
    //     child: Stack(
    //       children: [
    //         Positioned.fill(
    //           child: Container(
    //             margin: const EdgeInsets.only(top: 80),
    //             padding: const EdgeInsets.all(10),
    //             child: WidgetPage(
    //                 topicId: _topicUserModel!.topicId, flowId: flowId ?? -1),
    //           ),
    //         ),
    //         Positioned(
    //           top: 0,
    //           left: 0,
    //           right: 0,
    //           child: TopicHeaderWidget(
    //             topic: _topicUserModel!,
    //             onBack: () => Navigator.of(context).pop(),
    //             onExpandChanged: (expanded) {
    //               isExpanded = expanded.isExpanded;
    //               if (!isExpanded) {
    //                 setState(() {
    //                   flowId = expanded.flowId;
    //                   _topicUserModel!.startFlow = flowId;
    //                 });
    //               }
    //             },
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  PreferredSizeWidget renderAppBar() {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return AppBar(
      backgroundColor: colors.background,
      titleSpacing: 0,
      leading: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: Icon(Icons.arrow_back, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_topicUserModel?.name ?? "",
              style: TextStyle(fontWeight: FontWeight.bold)),
          _topicUserModel != null
              ? Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(12),
                        minHeight: 6,
                        color: colors.progressIndColor1,
                        backgroundColor: colors.progressIndColor2,
                        value: completedFlows / totalFlows,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$completedFlows/$totalFlows Ongoing...',
                      style: TextStyle(fontSize: 10, color: Colors.black),
                    ),
                  ],
                )
              : Container()
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colors.borderColorSecondary)),
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                barrierColor: Colors.black.withAlpha((0.3 * 255).round()),
                builder: (context) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 100,
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                      ),
                      child: FlowsBottomSheet(
                        topic: _topicUserModel!,
                        onFlowItemClicked: (id) => setState(() {
                          flowId = id;
                        }),
                      ),
                    ),
                  );
                },
              );
            },
            child: SvgPicture.asset(
                "packages/tradeable_flutter_sdk/lib/assets/images/dashboard_menu.svg"),
          ),
        )
      ],
    );
  }

  void updateFlowComplete() async {
    await API()
        .markFlowAsCompleted(
      flowId ?? 0,
      _topicUserModel!.topicId,
      _topicUserModel!.topicTagId,
    )
        .then((val) {
      getFlows();
    });
  }
}
