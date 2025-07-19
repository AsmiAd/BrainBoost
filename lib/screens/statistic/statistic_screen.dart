import 'package:brain_boost/core/constants/app_colors.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

class StatisticScreen extends StatefulWidget {
  @override
  _StatisticScreenState createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  int _currentIndex = 0; // 0 for Statistics, 1 for Leaderboard
  String _timeRange = 'week'; // week, month, year
  String _subjectFilter = 'all'; // all subjects or specific ones
  List<String> subjects = ['Math', 'Science', 'History', 'Languages'];

  // Sample progress data
  final Map<String, List<StudyProgress>> _progressData = {
    'week': [
      StudyProgress('Mon', 45, 60),
      StudyProgress('Tue', 60, 60),
      StudyProgress('Wed', 30, 60),
      StudyProgress('Thu', 55, 60),
      StudyProgress('Fri', 75, 60),
      StudyProgress('Sat', 90, 120),
      StudyProgress('Sun', 60, 120),
    ],
    'month': [
      StudyProgress('Week 1', 320, 420),
      StudyProgress('Week 2', 400, 420),
      StudyProgress('Week 3', 380, 420),
      StudyProgress('Week 4', 450, 420),
    ],
    'year': [
      StudyProgress('Jan', 1800, 2400),
      StudyProgress('Feb', 2000, 2400),
      StudyProgress('Mar', 2200, 2400),
      StudyProgress('Apr', 2100, 2400),
      StudyProgress('May', 2300, 2400),
      StudyProgress('Jun', 2400, 2400),
      StudyProgress('Jul', 2500, 2400),
      StudyProgress('Aug', 2600, 2400),
      StudyProgress('Sep', 2400, 2400),
      StudyProgress('Oct', 2700, 2400),
      StudyProgress('Nov', 2800, 2400),
      StudyProgress('Dec', 3000, 2400),
    ],
  };

  // Sample leaderboard data
  final List<LeaderboardUser> _leaderboardData = [
    LeaderboardUser('Alex Johnson', 12540, 1, ''),
    LeaderboardUser('Maria Garcia', 11870, 2, ''),
    LeaderboardUser('You', 11230, 3, ''),
    LeaderboardUser('Sam Wilson', 9870, 4, ''),
    LeaderboardUser('Emma Davis', 8760, 5, ''),
    LeaderboardUser('James Brown', 7650, 6, ''),
    LeaderboardUser('Sophia Miller', 6540, 7, ''),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      
      backgroundColor: AppColors.background,
      appBar: AppBar(
         
        title: Text('Study Analytics', style: TextStyle(color: AppColors.primary),),
        backgroundColor: AppColors.white,
        centerTitle: true,
      ),

      body: Column(
        children: [
          // Top Navigation Bar
          Container(
            color: AppColors.white,
            child: Row(
              children: [
                Expanded(
                  child: _buildTabButton('Statistics', 0),
                ),
                Expanded(
                  child: _buildTabButton('Leaderboard', 1),
                ),
              ],
            ),
          ),
          // Content Area
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                // Statistics Screen
                SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: _buildStatisticsContent(),
                ),
                // Leaderboard Screen
                SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: _buildLeaderboardContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        backgroundColor: _currentIndex == index
            ? AppColors.primary.withOpacity(0.1)
            : Colors.transparent,
      ),
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Text(
        title,
        style: TextStyle(
          color: _currentIndex == index ? AppColors.primary : AppColors.grey,
          fontWeight:
              _currentIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildStatisticsContent() {
    final currentData = _progressData[_timeRange]!;
    final goalPercentage = _calculateGoalPercentage(currentData);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildTimeRangeDropdown(),
          ],
        ),
        SizedBox(height: 16),
        _buildProgressSummary(goalPercentage),
        SizedBox(height: 24),
        _buildSubjectFilter(),
        SizedBox(height: 16),
        _buildProgressChart(currentData),
        SizedBox(height: 24),
        _buildProgressInsights(currentData),
      ],
    );
  }

  Widget _buildLeaderboardContent() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.secondary),
              ),
              child: DropdownButton<String>(
                value: _timeRange,
                underline: Container(),
                icon: Icon(Icons.arrow_drop_down,
                    size: 1, color: AppColors.primary),
                dropdownColor: AppColors.white,
                items: [
                  DropdownMenuItem(
                      value: 'week',
                      child: Text(
                        'Weekly',
                        style:
                            TextStyle(color: AppColors.primary, fontSize: 15),
                      )),
                  DropdownMenuItem(
                    value: 'month',
                    child: Text(
                      'Monthly',
                      style: TextStyle(color: AppColors.primary, fontSize: 15),
                    ),
                  ),
                  DropdownMenuItem(
                      value: 'year',
                      child: Text(
                        'Yearly',
                        style:
                            TextStyle(fontSize: 15, color: AppColors.primary),
                      )),
                ],
                onChanged: (value) {
                  setState(() {
                    _timeRange = value!;
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        _buildLeaderboard(),
      ],
    );
  }

  Widget _buildTimeRangeDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary),
      ),
      child: DropdownButton<String>(
        value: _timeRange,
        underline: Container(),
        icon: Icon(Icons.arrow_drop_down, size: 20, color: AppColors.primary),
        dropdownColor: AppColors.white,
        items: [
          DropdownMenuItem(
              value: 'week',
              child: Text(
                'Weekly',
                style: TextStyle(fontSize: 15, color: AppColors.primary),
              )),
          DropdownMenuItem(
              value: 'month',
              child: Text('Monthly',
                  style: TextStyle(fontSize: 15, color: AppColors.primary))),
          DropdownMenuItem(
              value: 'year',
              child: Text('Yearly',
                  style: TextStyle(fontSize: 15, color: AppColors.primary))),
        ],
        onChanged: (value) {
          setState(() {
            _timeRange = value!;
          });
        },
      ),
    );
  }

  Widget _buildSubjectFilter() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.secondary),
      ),
      child: DropdownButtonFormField<String>(
        value: _subjectFilter,
        decoration: InputDecoration(
          labelText: 'Filter by Subject',
          labelStyle: TextStyle(color: AppColors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: TextStyle(color: AppColors.primary),
        dropdownColor: AppColors.white,
        items: [
          DropdownMenuItem(
              value: 'all',
              child: Text('All Subjects',
                  style: TextStyle(color: AppColors.text))),
          ...subjects.map((subject) => DropdownMenuItem(
                value: subject.toLowerCase(),
                child: Text(subject, style: TextStyle(color: AppColors.text)),
              )),
        ],
        onChanged: (value) {
          setState(() {
            _subjectFilter = value!;
          });
        },
      ),
    );
  }

  Widget _buildProgressSummary(double goalPercentage) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Your Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          SizedBox(height: 12),
          LinearProgressIndicator(
            value: goalPercentage / 100,
            minHeight: 12,
            backgroundColor: AppColors.secondary.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              goalPercentage >= 100 ? Colors.green : AppColors.primary,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Goal Completion',
                style: TextStyle(color: AppColors.grey),
              ),
              Text(
                '${goalPercentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      goalPercentage >= 100 ? Colors.green : AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChart(List<StudyProgress> data) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _timeRange == 'week'
                ? 'Weekly Study Progress'
                : _timeRange == 'month'
                    ? 'Monthly Study Progress'
                    : 'Yearly Study Progress',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          SizedBox(height: 12),
          Container(
            height: 250,
            child: charts.BarChart(
              [
                charts.Series<StudyProgress, String>(
                  id: 'Actual',
                  colorFn: (_, __) =>
                      charts.ColorUtil.fromDartColor(AppColors.primary),
                  domainFn: (StudyProgress progress, _) => progress.timePeriod,
                  measureFn: (StudyProgress progress, _) =>
                      progress.actualMinutes,
                  data: data,
                  labelAccessorFn: (StudyProgress progress, _) =>
                      '${progress.actualMinutes} min',
                ),
                charts.Series<StudyProgress, String>(
                  id: 'Goal',
                  colorFn: (_, __) => charts.ColorUtil.fromDartColor(
                      AppColors.grey.withOpacity(0.5)),
                  domainFn: (StudyProgress progress, _) => progress.timePeriod,
                  measureFn: (StudyProgress progress, _) =>
                      progress.goalMinutes,
                  data: data,
                  labelAccessorFn: (StudyProgress progress, _) =>
                      'Goal: ${progress.goalMinutes} min',
                ),
              ],
              animate: true,
              barGroupingType: charts.BarGroupingType.grouped,
              defaultRenderer: charts.BarRendererConfig(
                groupingType: charts.BarGroupingType.grouped,
                strokeWidthPx: 0,
              ),
              domainAxis: charts.OrdinalAxisSpec(
                renderSpec: charts.SmallTickRendererSpec(
                  labelRotation: _timeRange == 'year' ? 45 : 0,
                  labelStyle: charts.TextStyleSpec(
                    fontSize: 10,
                    color: charts.ColorUtil.fromDartColor(AppColors.text),
                  ),
                ),
              ),
              primaryMeasureAxis: charts.NumericAxisSpec(
                renderSpec: charts.GridlineRendererSpec(
                  labelStyle: charts.TextStyleSpec(
                    fontSize: 10,
                    color: charts.ColorUtil.fromDartColor(AppColors.text),
                  ),
                ),
              ),
              behaviors: [
                charts.ChartTitle('Time Period',
                    behaviorPosition: charts.BehaviorPosition.bottom,
                    titleOutsideJustification:
                        charts.OutsideJustification.middleDrawArea,
                    titleStyleSpec: charts.TextStyleSpec(
                      color: charts.ColorUtil.fromDartColor(AppColors.text),
                    )),
                charts.ChartTitle('Minutes',
                    behaviorPosition: charts.BehaviorPosition.start,
                    titleOutsideJustification:
                        charts.OutsideJustification.middleDrawArea,
                    titleStyleSpec: charts.TextStyleSpec(
                      color: charts.ColorUtil.fromDartColor(AppColors.text),
                    )),
                charts.SeriesLegend(
                  position: charts.BehaviorPosition.top,
                  outsideJustification: charts.OutsideJustification.start,
                  legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
                  entryTextStyle: charts.TextStyleSpec(
                    color: charts.ColorUtil.fromDartColor(AppColors.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressInsights(List<StudyProgress> data) {
    final totalMinutes = data.fold(0, (sum, item) => sum + item.actualMinutes);
    final goalMinutes = data.fold(0, (sum, item) => sum + item.goalMinutes);
    final averagePerDay = totalMinutes / data.length;
    final bestDay =
        data.reduce((a, b) => a.actualMinutes > b.actualMinutes ? a : b);
    final consistency =
        (data.where((p) => p.actualMinutes >= p.goalMinutes).length /
                data.length) *
            100;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress Insights',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          SizedBox(height: 12),
          _buildInsightRow(
              Icons.timer, 'Total Study Time', '${totalMinutes} minutes'),
          _buildInsightRow(Icons.flag, 'Goal Completion',
              '${(totalMinutes / goalMinutes * 100).toStringAsFixed(1)}%'),
          _buildInsightRow(Icons.trending_up, 'Daily Average',
              '${averagePerDay.toStringAsFixed(1)} minutes'),
          _buildInsightRow(
              Icons.star,
              'Best ${_timeRange == 'week' ? 'day' : _timeRange == 'month' ? 'week' : 'month'}',
              '${bestDay.timePeriod} (${bestDay.actualMinutes} min)'),
          _buildInsightRow(Icons.auto_awesome, 'Consistency',
              '${consistency.toStringAsFixed(1)}% days met goal'),
        ],
      ),
    );
  }

  Widget _buildInsightRow(IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                )),
          ),
          Text(value, style: TextStyle(color: AppColors.grey)),
        ],
      ),
    );
  }

  Widget _buildLeaderboard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Study Leaderboard',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'This ${_timeRange}',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
          SizedBox(height: 16),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _leaderboardData.length,
            separatorBuilder: (context, index) => Divider(height: 16),
            itemBuilder: (context, index) {
              final user = _leaderboardData[index];
              final isCurrentUser = user.name == 'You';

              return Container(
                decoration: isCurrentUser
                    ? BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      alignment: Alignment.center,
                      child: Text(
                        user.rank.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _getRankColor(user.rank),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      child: Text(
                        user.name.substring(0, 1),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        user.name,
                        style: TextStyle(
                          fontWeight: isCurrentUser
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isCurrentUser
                              ? AppColors.primary
                              : AppColors.text,
                        ),
                      ),
                    ),
                    Text(
                      '${user.points} pts',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 12),
          Text(
            'Points are calculated based on study time and consistency',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return AppColors.text;
    }
  }

  double _calculateGoalPercentage(List<StudyProgress> data) {
    final totalActual = data.fold(0, (sum, item) => sum + item.actualMinutes);
    final totalGoal = data.fold(0, (sum, item) => sum + item.goalMinutes);
    return (totalActual / totalGoal) * 100;
  }
}

class StudyProgress {
  final String timePeriod;
  final int actualMinutes;
  final int goalMinutes;

  StudyProgress(this.timePeriod, this.actualMinutes, this.goalMinutes);
}

class LeaderboardUser {
  final String name;
  final int points;
  final int rank;
  final String avatarUrl;

  LeaderboardUser(this.name, this.points, this.rank, this.avatarUrl);
}
