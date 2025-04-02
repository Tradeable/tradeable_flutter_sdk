import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/user_widgets_model.dart';
import 'package:tradeable_flutter_sdk/src/network/kagr_api.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/flow_controller.dart';
import 'package:tradeable_learn_widget/atm_itm_dropdown_widget/atm_itm_dropdown_data_model.dart';
import 'package:tradeable_learn_widget/atm_itm_dropdown_widget/atm_itm_dropdown_widget_main.dart';
import 'package:tradeable_learn_widget/banana_widget/banana_model.dart';
import 'package:tradeable_learn_widget/banana_widget/banana_widget.dart';
import 'package:tradeable_learn_widget/bucket_widgetv1/bucket_container.dart';
import 'package:tradeable_learn_widget/bucket_widgetv1/models/bucket_model.dart';
import 'package:tradeable_learn_widget/buy_sell_widget/buy_sell.dart';
import 'package:tradeable_learn_widget/calender_widget/calender_model.dart';
import 'package:tradeable_learn_widget/calender_widget/calender_question.dart';
import 'package:tradeable_learn_widget/candle_body_select/candle_body_select.dart';
import 'package:tradeable_learn_widget/candle_body_select/candle_body_select_model.dart';
import 'package:tradeable_learn_widget/candle_formation/candle_formation.dart';
import 'package:tradeable_learn_widget/candle_formation/candle_formation_model.dart';
import 'package:tradeable_learn_widget/candle_formation_v2/candle_formation_v2_main.dart';
import 'package:tradeable_learn_widget/candle_formation_v2/candle_formation_v2_model.dart';
import 'package:tradeable_learn_widget/candle_match_the_pair/candle_part_match.dart';
import 'package:tradeable_learn_widget/candle_match_the_pair/match_the_pair_model.dart';
import 'package:tradeable_learn_widget/candle_select_question/candle_select_model.dart';
import 'package:tradeable_learn_widget/candle_select_question/candle_select_question.dart';
import 'package:tradeable_learn_widget/column_match/column_data_model.dart';
import 'package:tradeable_learn_widget/column_match/column_match.dart';
import 'package:tradeable_learn_widget/demand_supply_educorner/demand_supply_educorner_main.dart';
import 'package:tradeable_learn_widget/demand_supply_educorner/demand_supply_educorner_model.dart';
import 'package:tradeable_learn_widget/drag_and_drop_match_widget/drag_and_drop_match.dart';
import 'package:tradeable_learn_widget/dynamic_chart/dynamic_chart_main.dart';
import 'package:tradeable_learn_widget/dynamic_chart/dynamic_chart_model.dart';
import 'package:tradeable_learn_widget/edu_cornerv1/edu_corner_model.dart';
import 'package:tradeable_learn_widget/edu_cornerv1/edu_corner_v1.dart';
import 'package:tradeable_learn_widget/en1_matchthepair/en1_model.dart';
import 'package:tradeable_learn_widget/en1_matchthepair/en1_widget.dart';
import 'package:tradeable_learn_widget/expandable_edutile_widget/expandable_edutile_main.dart';
import 'package:tradeable_learn_widget/expandable_edutile_widget/expandable_edutile_model.dart';
import 'package:tradeable_learn_widget/fno_buy_story/option_intro_model.dart';
import 'package:tradeable_learn_widget/fno_buy_story/page_intro.dart';
import 'package:tradeable_learn_widget/fno_buy_story/price_decrease.dart';
import 'package:tradeable_learn_widget/fno_buy_story/price_decrease_model.dart';
import 'package:tradeable_learn_widget/formula_placeholder_widget/formula_placeholder_model.dart';
import 'package:tradeable_learn_widget/formula_placeholder_widget/formula_placeholder_widget.dart';
import 'package:tradeable_learn_widget/horizontal_line_question/horizontal_line_model.dart';
import 'package:tradeable_learn_widget/horizontal_line_question/horizontal_line_question.dart';
import 'package:tradeable_learn_widget/horizontal_line_v1/horizontal_line_model_v1.dart';
import 'package:tradeable_learn_widget/horizontal_line_v1/horizontal_line_question_v1.dart';
import 'package:tradeable_learn_widget/image_mcq/image_mcq.dart';
import 'package:tradeable_learn_widget/image_mcq/image_mcq_model.dart';
import 'package:tradeable_learn_widget/index_page/index_page.dart';
import 'package:tradeable_learn_widget/index_page/index_page_model.dart';
import 'package:tradeable_learn_widget/info_reel/info_reel.dart';
import 'package:tradeable_learn_widget/info_reel/info_reel_model.dart';
import 'package:tradeable_learn_widget/ladder_widget/ladder_data_model.dart';
import 'package:tradeable_learn_widget/ladder_widget/ladder_widget_main.dart';
import 'package:tradeable_learn_widget/ls11/ls11.dart';
import 'package:tradeable_learn_widget/ls11/ls11_model.dart';
import 'package:tradeable_learn_widget/markdown_preview_widget/markdown_preview_model.dart';
import 'package:tradeable_learn_widget/markdown_preview_widget/markdown_preview_widget.dart';
import 'package:tradeable_learn_widget/mcq_candle_question/mcq_candle_model.dart';
import 'package:tradeable_learn_widget/mcq_candle_question/mcq_candle_question.dart';
import 'package:tradeable_learn_widget/mcq_question/mcq_model.dart';
import 'package:tradeable_learn_widget/mcq_question/mcq_question.dart';
import 'package:tradeable_learn_widget/multiple_mcq_select/multiple_mcq_model.dart';
import 'package:tradeable_learn_widget/multiple_mcq_select/multiple_mcq_question.dart';
import 'package:tradeable_learn_widget/range_grid_widget/range_grid_model.dart';
import 'package:tradeable_learn_widget/range_grid_widget/range_grid_widget.dart';
import 'package:tradeable_learn_widget/reading_option_chain/reading_option_chain.dart';
import 'package:tradeable_learn_widget/rr_widget/rr_model.dart';
import 'package:tradeable_learn_widget/rr_widget/rr_question.dart';
import 'package:tradeable_learn_widget/trend_line/models/trendline_model.dart';
import 'package:tradeable_learn_widget/trend_line/trend_line.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/user_story_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/user_story_ui_main.dart';
import 'package:tradeable_learn_widget/video_educorner/video_educorner.dart';
import 'package:tradeable_learn_widget/video_educorner/video_educorner_model.dart';
import 'package:tradeable_learn_widget/web_info_reel/web_info_reel.dart';
import 'package:tradeable_learn_widget/web_info_reel/webpage_model.dart';

class WidgetPage extends StatefulWidget {
  final int topicId;
  final int flowId;

  const WidgetPage({super.key, required this.topicId, required this.flowId});

  @override
  State<WidgetPage> createState() => _WidgetPageState();
}

class _WidgetPageState extends State<WidgetPage> {
  int currentIndex = 0;
  bool isLoading = false;
  List<WidgetsModel>? widgets;

  @override void didUpdateWidget(covariant WidgetPage oldWidget) {
    if(oldWidget.flowId!=widget.flowId) {
      setState(() {
        widgets = [];
        getFlowByFlowId(widget.flowId);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    getFlowByFlowId(widget.flowId);
    super.initState();
  }

  void getFlowByFlowId(int flowId) async {
    setState(() {
      widgets = [];
    });
    await KagrApi().fetchFlowById(widget.topicId, flowId, 33).then((val) {
      setState(() {
        widgets = (val.widgets ?? [])
            .map((e) => WidgetsModel(data: e.data, modelType: e.modelType))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: (widgets ?? []).isNotEmpty
            ? isLoading
                ? CircularProgressIndicator()
                : getViewByType(widgets![currentIndex].modelType,
                    widgets![currentIndex].data)
            : CircularProgressIndicator());
  }

  Widget getViewByType(String levelType, Map<String, dynamic>? data) {
    switch (levelType) {
      case "End":
      // return LevelCompleteScreen(recommendations: recommendations);
      case "Edu_Corner":
        // case "EduCornerV1":
        return EduCornerV1(
            model: EduCornerModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "CA1.1":
        return CandleBodySelect(
            model: CandlePartSelectModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "ladder_question":
        return LadderWidgetMain(
            ladderModel: LadderModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "call_put_atm":
        return ATMWidget(
            model: ATMWidgetModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "expandableEduTileModelData":
        return ExpandableEduTileMain(
            model: ExpandableEduTileModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "CA1.2":
        return CandlePartMatchLink(
            model: CandleMatchThePairModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "EN1":
        return EN1(
            model: EN1Model.fromJson(data), onNextClick: () => onNextClick());
      case "MultipleCandleSelect_STATIC":
      case "MultipleCandleSelect_DYNAMIC":
        return CandleSelectQuestion(
            model: CandleSelectModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "MCQ_STATIC":
      case "MCQ_DYNAMIC":
        return MCQQuestion(
            model: MCQModel.fromJson(data), onNextClick: () => onNextClick());
      case "HorizontalLine_STATIC":
      case "HorizontalLine_DYNAMIC":
      case "MultipleHorizontalLine_STATIC":
      case "MultipleHorizontalLine_DYNAMIC":
        return HorizontalLineQuestion(
            model: HorizontalLineModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "MCQ_CANDLE":
        return MCQCandleQuestion(
            model: MCQCandleModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "video_educorner":
        return VideoEduCorner(
            model: VideoEduCornerModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "drag_and_drop_match":
      case "fno_scenario_1":
        return DragAndDropMatch(
            model: LadderModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "Bucket_containerv1":
      case "drag_drop_logo":
        return BucketContainerV1(
            model: BucketContainerModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "content_preview":
        return MarkdownPreviewWidget(
            model: MarkdownPreviewModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "Calender_Question":
        return CalenderQuestion(
            model: CalenderQuestionModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "formula_placeholder":
        return FormulaPlaceholderWidget(
            model: FormulaPlaceHolderModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "candle_formationv2":
        return CandleFormationV2Main(
            model: CandleFormationV2Model.fromJson(data),
            onNextClick: () => onNextClick());
      case "multiple_select_mcq":
        return MultipleMCQSelect(
            model: MultipleMCQModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "trend_line":
        return TrendLineWidget(
            model: TrendLineModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "supply_demand_educorner":
        return DemandSuplyEduCornerMain(
            model: DemandSupplyEduCornerModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "user_story":
        return UserStoryUIMain(
            model: UserStoryModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "horizontal_line_v1":
        return HorizontalLineQuestionV1(
            model: HorizontalLineModelV1.fromJson(data),
            onNextClick: () => onNextClick());
      case "Buy_Sell":
        return BuySellV1();
      case "Reading_Option_Chain":
        return ReadingOptionChain(onNextClick: () => onNextClick());
      case "scenario_intro":
        return ScenarioIntroWidget(
            model: OptionIntroModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "fno_buy_page_3":
        return PriceDecreased(
            model: PriceDecreaseModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "index_page":
        return IndexPage(
            model: IndexPageModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "info":
        return InfoReel(
            model: InfoReelModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "webpage":
        return WebInfoReel(
            model: WebpageModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "LS11":
        return LS11(
            model: LS11Model.fromJson(data), onNextClick: () => onNextClick());
      case "RR_DYNAMIC":
        return RRQuestion(
            model: RRModel.fromJson(data), onNextClick: () => onNextClick());
      case "candle_formation":
        return CandleFormation(
            model: CandleFormationModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "banana_widget":
        return BananaWidget(
            model: BananaModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "image_mcq":
        return ImageMcq(
            model: ImageMCQModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "column_match":
        return ColumnMatch(
            model: ColumnModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "range_grid_slider":
        return RatingWidget(
            model: RangeGridSliderModel.fromJson(data),
            onNextClick: () => onNextClick());
      case "dynamic_chart":
        log(data.toString());
        return DynamicChartWidget(
            model: DynamicChartModel.fromJson(data),
            onNextClick: () => onNextClick());
      default:
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: Text("Unsupported Type: $levelType"),
        );
    }
  }

  void onNextClick() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration(milliseconds: 100)).then((val) {
      setState(() {
        if (currentIndex < widgets!.length - 1) {
          currentIndex++;
          isLoading = false;
        } else {
          FlowController().openFlowsList(highlightNextFlow: true);
          isLoading = false;
          currentIndex = 0;
        }
      });
    });
  }
}
