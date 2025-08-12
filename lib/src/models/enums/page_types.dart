enum PageId {
  axisOverview,
  axisOption,
  axisTechnical,
  axisScanners,
  axisWatchlist,
  axisFundamentals,
  axisOrderType,
  axisMiscellaneous,
  demo,
  axisFuture,
}

extension PageIdValue on PageId {
  static const Map<PageId, List<int>> _values = {
    PageId.axisOverview: [20, 5],
    PageId.axisOption: [21, 6],
    PageId.axisTechnical: [22, 7],
    PageId.axisScanners: [23, 8],
    PageId.axisWatchlist: [24, 9],
    PageId.axisFundamentals: [25, 10],
    PageId.axisOrderType: [26, 13],
    PageId.axisMiscellaneous: [27, 14],
    PageId.demo: [28, 15],
    PageId.axisFuture: [29, 17],
  };

  int get pageId => _values[this]![0];

  int get topicTagId => _values[this]![1];
}
