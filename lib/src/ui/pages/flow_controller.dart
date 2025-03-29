class FlowController {
  static final FlowController _instance = FlowController._internal();

  Function(bool)? _openFlowsCallback;

  factory FlowController() {
    return _instance;
  }

  FlowController._internal();

  void registerCallback(Function(bool) callback) {
    _openFlowsCallback = callback;
  }

  void openFlowsList({required bool highlightNextFlow}) {
    if (_openFlowsCallback != null) {
      _openFlowsCallback!(highlightNextFlow);
    }
  }
}
