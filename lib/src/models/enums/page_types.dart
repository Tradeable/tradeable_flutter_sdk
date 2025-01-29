enum PageId {
  allModule, //default
  overview,
  optionChain,
  technicals,
  events,
  other,
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
    }
  }
}
