import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/stats.dart';
import '../utils/format_utils.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimePeriod = 'Today';
  bool _isLoading = true;
  List<DailyStats> _statsData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadStats();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadStats() async {
    // Simulate data loading
    await Future.delayed(Duration(seconds: 1));
    
    setState(() {
      // Mock data - replace with Firebase data later
      _statsData = [
        DailyStats(
          date: DateTime.now(),
          registeredCount: 24,
          resolvedCount: 18,
          pendingCount: 6,
          avgResolutionTime: 2.3,
          staffStats: [
            StaffStats(
              staffName: 'Dr. Smith',
              registeredCount: 10,
              resolvedCount: 8,
              avgResolutionTime: 2.1,
            ),
            StaffStats(
              staffName: 'Dr. Johnson',
              registeredCount: 8,
              resolvedCount: 6,
              avgResolutionTime: 2.5,
            ),
            StaffStats(
              staffName: 'Dr. Williams',
              registeredCount: 6,
              resolvedCount: 4,
              avgResolutionTime: 2.7,
            ),
          ],
        ),
        DailyStats(
          date: DateTime.now().subtract(Duration(days: 1)),
          registeredCount: 19,
          resolvedCount: 15,
          pendingCount: 4,
          avgResolutionTime: 2.5,
          staffStats: [
            StaffStats(
              staffName: 'Dr. Smith',
              registeredCount: 8,
              resolvedCount: 7,
              avgResolutionTime: 2.2,
            ),
            StaffStats(
              staffName: 'Dr. Johnson',
              registeredCount: 7,
              resolvedCount: 5,
              avgResolutionTime: 2.6,
            ),
            StaffStats(
              staffName: 'Dr. Williams',
              registeredCount: 4,
              resolvedCount: 3,
              avgResolutionTime: 2.8,
            ),
          ],
        ),
      ];
      _isLoading = false;
    });
  }

  void _changeTimePeriod(String period) {
    setState(() {
      _selectedTimePeriod = period;
      _isLoading = true;
    });
    _loadStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Overview'),
            Tab(text: 'Staff'),
            Tab(text: 'Timeline'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildTimePeriodSelector(),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(),
                      _buildStaffTab(),
                      _buildTimelineTab(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePeriodSelector() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTimePeriodChip('Today'),
          _buildTimePeriodChip('Week'),
          _buildTimePeriodChip('Month'),
          _buildTimePeriodChip('Custom'),
        ],
      ),
    );
  }

  Widget _buildTimePeriodChip(String period) {
    final isSelected = _selectedTimePeriod == period;
    
    return ChoiceChip(
      label: Text(period),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          _changeTimePeriod(period);
        }
      },
      backgroundColor: Colors.white,
      selectedColor: Colors.blue[100],
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue[800] : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildOverviewTab() {
    // Get combined stats based on the selected time period
    final totalRegistered = _statsData.fold(0, (sum, item) => sum + item.registeredCount);
    final totalResolved = _statsData.fold(0, (sum, item) => sum + item.resolvedCount);
    final totalPending = _statsData.fold(0, (sum, item) => sum + item.pendingCount);
    final avgResolutionTime = _statsData.isEmpty
        ? 0.0
        : _statsData.fold(0.0, (sum, item) => sum + item.avgResolutionTime) / _statsData.length;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(totalRegistered, totalResolved, totalPending),
          SizedBox(height: 24),
          _buildResolutionTimeCard(avgResolutionTime),
          SizedBox(height: 24),
          _buildResolutionRateCard(totalResolved, totalRegistered),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(int registered, int resolved, int pending) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Summary',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Registered',
                count: registered,
                color: Colors.blue,
                icon: Icons.receipt_long,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                title: 'Resolved',
                count: resolved,
                color: Colors.green,
                icon: Icons.check_circle,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                title: 'Pending',
                count: pending,
                color: Colors.orange,
                icon: Icons.pending_actions,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 12),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResolutionTimeCard(double avgTime) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Average Resolution Time',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer, color: Colors.blue, size: 28),
                SizedBox(width: 12),
                Text(
                  '${avgTime.toStringAsFixed(1)} hours',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResolutionRateCard(int resolved, int total) {
    final percentage = total == 0 ? 0.0 : (resolved / total * 100);
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resolution Rate',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pie_chart, color: Colors.green, size: 28),
                SizedBox(width: 12),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 10,
            ),
            SizedBox(height: 8),
            Text(
              '$resolved of $total concerns resolved',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffTab() {
    // Combine staff data across all days
    Map<String, StaffStats> staffStatsMap = {};
    
    for (var daily in _statsData) {
      for (var staff in daily.staffStats) {
        if (staffStatsMap.containsKey(staff.staffName)) {
          var existing = staffStatsMap[staff.staffName]!;
          staffStatsMap[staff.staffName] = StaffStats(
            staffName: staff.staffName,
            registeredCount: existing.registeredCount + staff.registeredCount,
            resolvedCount: existing.resolvedCount + staff.resolvedCount,
            avgResolutionTime: (existing.avgResolutionTime + staff.avgResolutionTime) / 2,
          );
        } else {
          staffStatsMap[staff.staffName] = staff;
        }
      }
    }
    
    // Sort staff by most resolved
    List<StaffStats> sortedStaff = staffStatsMap.values.toList()
      ..sort((a, b) => b.resolvedCount.compareTo(a.resolvedCount));
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Staff Performance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ...sortedStaff.map((staff) => _buildStaffCard(staff)).toList(),
        ],
      ),
    );
  }

  Widget _buildStaffCard(StaffStats staff) {
    final resolutionRate = staff.registeredCount == 0
        ? 0.0
        : (staff.resolvedCount / staff.registeredCount * 100);
    
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(staff.staffName[0]),
                  backgroundColor: Colors.blue[100],
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        staff.staffName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Avg. resolution: ${staff.avgResolutionTime.toStringAsFixed(1)} hrs',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _buildStatIndicator(
                  label: 'Registered',
                  value: staff.registeredCount.toString(),
                  color: Colors.blue,
                ),
                SizedBox(width: 16),
                _buildStatIndicator(
                  label: 'Resolved',
                  value: staff.resolvedCount.toString(),
                  color: Colors.green,
                ),
                SizedBox(width: 16),
                _buildStatIndicator(
                  label: 'Rate',
                  value: '${resolutionRate.toStringAsFixed(1)}%',
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatIndicator({
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTab() {
    // Sort stats by date (newest first)
    List<DailyStats> sortedStats = [..._statsData]
      ..sort((a, b) => b.date.compareTo(a.date));
    
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: sortedStats.length,
      itemBuilder: (context, index) {
        final stats = sortedStats[index];
        return _buildDayCard(stats);
      },
    );
  }

  Widget _buildDayCard(DailyStats stats) {
    final dateStr = DateFormat.yMMMd().format(stats.date);
    final isToday = DateFormat.yMd().format(stats.date) == 
                    DateFormat.yMd().format(DateTime.now());
    
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  dateStr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 8),
                if (isToday)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'TODAY',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _buildDailyStatItem(
                  value: stats.registeredCount.toString(),
                  label: 'Registered',
                  color: Colors.blue,
                ),
                _buildDailyStatItem(
                  value: stats.resolvedCount.toString(),
                  label: 'Resolved',
                  color: Colors.green,
                ),
                _buildDailyStatItem(
                  value: stats.pendingCount.toString(),
                  label: 'Pending',
                  color: Colors.orange,
                ),
                _buildDailyStatItem(
                  value: '${stats.avgResolutionTime.toStringAsFixed(1)} hrs',
                  label: 'Avg Time',
                  color: Colors.purple,
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Top Performer: ${_getTopPerformer(stats.staffStats)}',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTopPerformer(List<StaffStats> staffStats) {
    if (staffStats.isEmpty) return 'None';
    
    // Sort by resolved count
    final sorted = [...staffStats]..sort((a, b) => b.resolvedCount.compareTo(a.resolvedCount));
    return sorted.first.staffName;
  }

  Widget _buildDailyStatItem({
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}