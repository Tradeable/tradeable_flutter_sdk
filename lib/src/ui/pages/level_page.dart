import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/level/level.model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_learn_widget/buy_sell_widget/buy_sell.dart';
import 'package:tradeable_learn_widget/candle_formation/candle_formation_model.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/user_story_model.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class LevelPage extends StatefulWidget {
  final int levelId;

  const LevelPage({super.key, required this.levelId});

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  late Level level;
  String title = "";
  bool isLoading = true;
  Node? currentNode;
  Recommendations? recommendations;
  double progress = 0.0;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Api().fetchLevelById(widget.levelId).then((val) {
      setState(() {
        isLoading = false;
        level = val;
        recommendations = level.recommendations;
        title = level.title;
      });
      findStartNode();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void findStartNode() {
    Node? startNode =
        level.graph!.firstWhere((node) => node.type == Type.start);
    setState(() {
      currentNode = startNode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: Theme.of(context).customTextStyles.mediumBold,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: colors.cardColorSecondary,
            valueColor:
                AlwaysStoppedAnimation<Color>(colors.borderColorPrimary),
          ),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : getViewByType(currentNode?.model ?? "End",
                currentNode?.data as Map<String, dynamic>?),
      ),
    );
  }

  Widget getViewByType(String levelType, Map<String, dynamic>? data) {
    switch (levelType) {
      case "End":
        return LevelCompleteScreen(recommendations: recommendations);
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
    Future.delayed(const Duration(milliseconds: 100)).then((v) {
      var endNodeId = currentNode!.edges?[0].endNodeId;

      for (int i = 0; i < level.graph!.length; i++) {
        if (level.graph![i].nodeId == endNodeId) {
          setState(() {
            currentNode = level.graph![i];
            currentIndex++;
            isLoading = false;
            progress = currentIndex / (level.graph!.length - 1);
          });
          break;
        }
      }
    });
  }
}
