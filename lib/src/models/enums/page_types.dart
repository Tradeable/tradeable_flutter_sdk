enum PageId {
  // allModule, //default
  // overview,
  // optionChain,
  // technicals,
  // events,
  // other,
  // sahiTechnicals,
  // sahiOptionChain,
  // sahiCandlestick,
  // sahiMarketDepth,
  // trends,
  axisOverview,
  axisOption,
  axisTechnical,
  axisScanners,
  axisWatchlist,
  axisFundamentals,
  axisOrderType,
  axisMiscellaneous
}

extension PageIdValue on PageId {
  static const Map<PageId, List<int>> _values = {
    // PageId.allModule: [1, 1],
    // PageId.overview: [8, 102],
    // PageId.optionChain: [9, 103],
    // PageId.technicals: [10, 104],
    // PageId.events: [11, 105],
    // PageId.other: [12, 106],
    // PageId.sahiTechnicals: [18, 107],
    // PageId.sahiOptionChain: [17, 108],
    // PageId.sahiCandlestick: [16, 109],
    // PageId.sahiMarketDepth: [15, 110],
    // PageId.trends: [19, 111],
    PageId.axisOverview: [20, 5],
    PageId.axisOption: [21, 6],
    PageId.axisTechnical: [22, 7],
    PageId.axisScanners: [23, 8],
    PageId.axisWatchlist: [24, 9],
    PageId.axisFundamentals: [25, 10],
    PageId.axisOrderType: [26, 13],
    PageId.axisMiscellaneous: [27, 14]
  };

  int get pageId => _values[this]![0];

  int get topicTagId => _values[this]![1];
}
