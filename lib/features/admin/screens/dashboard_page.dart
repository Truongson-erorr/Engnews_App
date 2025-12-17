import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    "Khách",
                    "1.245",
                    Icons.people_alt_rounded,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildStatCard(
                    "Bài viết",
                    "320",
                    Icons.article_rounded,
                    Colors.deepPurple,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildStatCard(
                    "Truy cập",
                    "5.890",
                    Icons.show_chart_rounded,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),

            const Text(
              "Biểu đồ truy cập tuần",
              style: TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            _chartContainer(
              LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const days = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"];
                          if (value < 0 || value > 6) return const SizedBox();
                          return Text(
                            days[value.toInt()],
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 10,
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      barWidth: 4,
                      color: Colors.blue.shade600,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.15),
                      ),
                      dotData: const FlDotData(show: false),
                      spots: const [
                        FlSpot(0, 3),
                        FlSpot(1, 4),
                        FlSpot(2, 6),
                        FlSpot(3, 7),
                        FlSpot(4, 6),
                        FlSpot(5, 8),
                        FlSpot(6, 9),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 35),

            const Text(
              "Tỷ lệ phân loại bài viết",
              style: TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            _chartContainer(
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      value: 40,
                      color: Colors.blue.shade400,
                      title: "Tin tức",
                      radius: 60,
                      titleStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      value: 30,
                      color: Colors.green.shade400,
                      title: "Blog",
                      radius: 60,
                      titleStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      value: 15,
                      color: Colors.orange.shade400,
                      title: "Podcast",
                      radius: 60,
                      titleStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      value: 15,
                      color: Colors.red.shade400,
                      title: "Khác",
                      radius: 60,
                      titleStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _chartContainer(Widget child) {
    return Container(
      height: 260,
      padding: const EdgeInsets.all(18),
      decoration: _boxDecoration(),
      child: child,
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 18),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(221, 140, 140, 140),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800, 
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: Colors.black12.withOpacity(0.08),
          blurRadius: 12,
          spreadRadius: 1,
          offset: const Offset(2, 4),
        )
      ],
    );
  }
}
