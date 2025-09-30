import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/user_widgets_model.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/user_story_model.dart';
import 'package:tradeable_learn_widget/buy_sell_widget/buy_sell.dart';
import 'package:tradeable_learn_widget/dynamic_chart/dynamic_chart_main.dart';
import 'package:tradeable_learn_widget/dynamic_chart/dynamic_chart_model.dart';
import 'package:tradeable_learn_widget/candle_formation/candle_formation_model.dart';

class RecipePage extends StatefulWidget {
  final int flowId;
  const RecipePage({super.key, required this.flowId});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  int currentIndex = 0;
  bool showLoader = false;
  List<WidgetsModel>? widgets;
  bool fetchingData = true;

  @override
  void didUpdateWidget(covariant RecipePage oldWidget) {
    setState(() {
      widgets = [];
      if (widget.flowId != -1) {
        getFlowByFlowId(widget.flowId);
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  void getFlowByFlowId(int flowId) async {
    print("Fetching flow for id: $flowId");
    setState(() {
      widgets = [];
      fetchingData = true;
    });
    await API().fetchFlowById(null, flowId, 33).then((val) {
      setState(() {
        widgets = (val.widgets ?? [])
            .map((e) => WidgetsModel(data: e.data, modelType: e.modelType))
            .toList();
        fetchingData = false;
      });
    });
  }

  @override
  void initState() {
    if (widget.flowId != -1) {
      getFlowByFlowId(widget.flowId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: showLoader || fetchingData
            ? const CircularProgressIndicator()
            : (widgets == null || widgets!.isEmpty)
                ? const Text("No data found")
                : getViewByType(widgets![currentIndex].modelType,
                    widgets![currentIndex].data),
      ),
    );
  }

  Widget getViewByType(String levelType, Map<String, dynamic>? data) {
    switch (levelType) {
      case "End":
        // return LevelCompleteScreen(recommendations: recommendations);
        return Container();
      case "Edu_Corner":
        // case "EduCornerV1":
        return EduCornerV2Main(
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
        return DynamicChartWidget(
            model: DynamicChartModel.fromJson(data),
            onNextClick: () {
              onNextClick();
            });
      // case "option_trade_demo":
      //   return SampleUserflowScreen(
      //       data: SampleUserflowModel.fromJson(data),
      //       onNextClick: () => onNextClick());
      case "order_type_v1":
        return OrderScreen(
            model: OrderTypeV1.fromJson(data), onNextClick: onNextClick);
      default:
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: Text("Unsupported Type: $levelType"),
        );
    }
  }

  void onNextClick() {
    if (currentIndex < (widgets?.length ?? 0) - 1) {
      setState(() {
        showLoader = true;
      });

      Future.delayed(const Duration(milliseconds: 1000)).then((_) {
        setState(() {
          currentIndex++;
          showLoader = false;
        });
      });
    }
  }
}
