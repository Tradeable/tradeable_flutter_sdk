enum PageId {
  allModule, //default
  overview,
  optionChain,
  technicals,
  events,
  other,
  sahiTechnicals,
  sahiOptionChain,
  sahiCandlestick,
  sahiMarketDepth
}

extension PageIdValue on PageId {
  int get value {
    switch (this) {
      case PageId.allModule:
        return 1;
      case PageId.overview:
        return 8;
      case PageId.optionChain:
        return 9;
      case PageId.technicals:
        return 10;
      case PageId.events:
        return 11;
      case PageId.other:
        return 12;
      case PageId.sahiTechnicals:
        return 18;
      case PageId.sahiOptionChain:
        return 17;
      case PageId.sahiCandlestick:
        return 16;
      case PageId.sahiMarketDepth:
        return 15;
    }
  }
}
