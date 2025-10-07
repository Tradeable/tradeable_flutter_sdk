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
  static const Map<PageId, int> _values = {
    PageId.axisOverview: 5,
    PageId.axisOption: 6,
    PageId.axisTechnical: 7,
    PageId.axisScanners: 8,
    PageId.axisWatchlist: 9,
    PageId.axisFundamentals: 10,
    PageId.axisOrderType: 13,
    PageId.axisMiscellaneous: 14,
    PageId.demo: 15,
    PageId.axisFuture: 17,
  };

  int get topicTagId => _values[this] ?? 0;
}
