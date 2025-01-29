import 'package:tradeable_flutter_sdk/src/data/module_data.dart';
import 'package:tradeable_flutter_sdk/src/models/module.model.dart';

enum ModuleLabel {
  moneyness,
  options,
  supportAndResistance,
  introToTA,
  circuits,
  candlestickPatterns,
}

extension ModuleLabelValue on ModuleLabel {
  ModuleModel get value {
    switch (this) {
      case ModuleLabel.moneyness:
        return learnLevels[0];
      case ModuleLabel.options:
        return learnLevels[1];
      case ModuleLabel.supportAndResistance:
        return learnLevels[2];
      case ModuleLabel.introToTA:
        return learnLevels[3];
      case ModuleLabel.circuits:
        return learnLevels[4];
      case ModuleLabel.candlestickPatterns:
        return learnLevels[5];
    }
  }
}
