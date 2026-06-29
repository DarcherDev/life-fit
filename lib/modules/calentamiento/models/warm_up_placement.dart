enum WarmUpPlacement {
  start,
  end;

  static WarmUpPlacement fromJson(String? value) {
    if (value == 'end') {
      return WarmUpPlacement.end;
    }
    return WarmUpPlacement.start;
  }

  String toJson() => name;
}
