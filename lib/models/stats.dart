class StaffStats {
  final String staffName;
  final int registeredCount;
  final int resolvedCount;
  final double avgResolutionTime; // in hours

  StaffStats({
    required this.staffName,
    required this.registeredCount,
    required this.resolvedCount,
    required this.avgResolutionTime,
  });
}

class DailyStats {
  final DateTime date;
  final int registeredCount;
  final int resolvedCount;
  final int pendingCount;
  final double avgResolutionTime; // in hours
  final List<StaffStats> staffStats;

  DailyStats({
    required this.date,
    required this.registeredCount,
    required this.resolvedCount,
    required this.pendingCount,
    required this.avgResolutionTime,
    required this.staffStats,
  });
}