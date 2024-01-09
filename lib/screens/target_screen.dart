import 'package:flutter/material.dart';
import 'package:nutritrack/utils/colors.dart';
import 'package:nutritrack/widgets/select_goal_bottom_sheet.dart';
import 'package:nutritrack/widgets/stream_builders/goal_stream_builder.dart';

class TargetScreen extends StatefulWidget {
  const TargetScreen({super.key});

  @override
  State<TargetScreen> createState() => _TargetScreenState();
}

class _TargetScreenState extends State<TargetScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Your Goal",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
              ),
            ),
            IconButton(
              onPressed: () => showModalBottomSheet(
                  // elevation: 10,
                  isScrollControlled: true,
                  useSafeArea: true,
                  context: context,
                  builder: (context) {
                    return const SelectGoalBottomSheet();
                  }),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(
          height: 32,
        ),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: black,
            border: Border.all(width: 0, style: BorderStyle.none),
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(
                10.0,
              ),
              color: white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 5,
                ),
              ],
            ),
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: black,
            unselectedLabelColor: white,
            tabs: const [
              Tab(
                child: Text(
                  "Active",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "Completed",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "Failed",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
              controller: _tabController,
              clipBehavior: Clip.none,
              children: const [
                GoalStreamBuilder(status: "active"),
                GoalStreamBuilder(status: "completed"),
                GoalStreamBuilder(status: "failed"),
              ]),
        )
      ]),
    );
  }
}
