import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tradeable_flutter_sdk/src/models/flow_model.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_user_model.dart';
import 'package:tradeable_flutter_sdk/src/models/user_widgets_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/utils/flow_controller.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/widget_page.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/flows_bottom_sheet.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class TopicDetailPage extends StatefulWidget {
  final TopicUserModel? topic;
  final int? topicId;
  final int? courseId;

  const TopicDetailPage({super.key, this.topic, this.topicId, this.courseId});

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
      //flowId = _topicUserModel!.startFlow;
      if (flowId == null) {
        getFlows();
      }
      completedFlows = _topicUserModel!.progress.completed;
      totalFlows = _topicUserModel!.progress.total;
    } else if (widget.topicId != null) {
      _fetchTopicUserModel();
    }
  }

  Future<void> _fetchTopicUserModel() async {
    setState(() {
      _loading = true;
    });
    final topic =
        await API().fetchTopicById(widget.topicId!, moduleId: widget.courseId);
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
    final val = await API().fetchTopicById(_topicUserModel!.topicId,
        topicTagId: _topicUserModel!.topicContextType != null &&
                _topicUserModel!.topicContextType == TopicContextType.tag
            ? _topicUserModel!.topicContextId
            : null,
        moduleId: _topicUserModel!.topicContextType != null &&
                _topicUserModel!.topicContextType == TopicContextType.course
            ? _topicUserModel!.topicContextId
            : null);
    setState(() {
      if (_topicUserModel?.startFlow != null) {
        try {
          FlowModel? flowModel = val.flows
              ?.firstWhere((flow) => flow.id == _topicUserModel!.startFlow);
          if (flowModel != null && !flowModel.isCompleted) {
            flowId = _topicUserModel!.startFlow;
          } else {
            flowId ??= val.flows!
                .firstWhere((flow) => !flow.isCompleted,
                    orElse: () => val.flows!.first)
                .id;
          }
        } catch (e) {
          flowId ??= val.flows!
              .firstWhere((flow) => !flow.isCompleted,
                  orElse: () => val.flows!.first)
              .id;
        }
      } else {
        flowId ??= val.flows!
            .firstWhere((flow) => !flow.isCompleted,
                orElse: () => val.flows!.first)
            .id;
      }
      // start flow id present but incomplete then start with startFlow
      // statrt flow id present but complete then start with first incomplete
      // start flow id absent then start from first incomplete

      completedFlows = (val.flows ?? []).where((f) => f.isCompleted).length;
      totalFlows = (val.flows ?? []).length;
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
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? colors.background
            : widget.topic?.cardColor ?? Color(0xffF9F1EB),
        appBar: renderAppBar(),
        body: SafeArea(
          child: WidgetPage(
              topicUserModel: _topicUserModel,
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
                          completedFlowId: flowId ?? -1,
                        ),
                      ),
                    );
                  },
                );
              }),
        ));
  }

  AppBar renderAppBar() {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return AppBar(
      backgroundColor: colors.background,
      titleSpacing: 0,
      leading: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: Icon(Icons.arrow_back, size: 24, color: colors.backBtnColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(_topicUserModel?.name ?? "",
              minFontSize: 12,
              maxFontSize: 18,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colors.topicDetailsHeadersColor)),
          SizedBox(height: 4),
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
                      '$completedFlows/$totalFlows ${completedFlows == totalFlows ? "Completed" : "Ongoing..."}',
                      style: TextStyle(
                          fontSize: 10, color: colors.topicDetailsHeadersColor),
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
              border: Border.all(color: colors.topicDetailsHeadersColor)),
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
                        completedFlowId: -1,
                      ),
                    ),
                  );
                },
              );
            },
            child: SvgPicture.asset(
              "packages/tradeable_flutter_sdk/lib/assets/images/dashboard_menu.svg",
              colorFilter: ColorFilter.mode(
                  colors.topicDetailsHeadersColor, BlendMode.srcIn),
            ),
          ),
        )
      ],
    );
  }

  void updateFlowComplete() async {
    await API()
        .markFlowAsCompleted(
            flowId ?? 0,
            _topicUserModel?.topicId,
            _topicUserModel?.topicContextType == TopicContextType.tag
                ? _topicUserModel?.topicContextId
                : null,
            _topicUserModel?.topicContextType == TopicContextType.course
                ? _topicUserModel?.topicContextId
                : null)
        .then((val) {
      getFlows();
    });
  }
}
