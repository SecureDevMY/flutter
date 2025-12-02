import 'package:flutter/material.dart';

void main() {
  runApp(const BudgetTrackerApp());
}

class BudgetTrackerApp extends StatelessWidget {
  const BudgetTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Budget Tracker - Analysis Screen',
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const AnalysisScreen(),
    );
  }
}

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  String selectedPeriod = 'Daily';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1CD8A0),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopSection(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildPeriodSelector(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildIncomeExpensesChart(),
                            const SizedBox(height: 25),
                            _buildIncomeExpensesSummary(),
                            const SizedBox(height: 25),
                            const Text(
                              'My Targets',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 15),
                            _buildTargetsRow(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      )
                    )
                  ],
                ),
              )
            )
          ],
        )
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildTopSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          //Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              const Text(
                'Analysis',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                  size: 24,
                ),
              )
            ],
          ),

          const SizedBox(height: 30),

          //Balance and Expenses Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.arrow_outward, color: Colors.black87, size: 18),
                        SizedBox(width: 5),
                        Text(
                          'Total Balance',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '\$7,783.00',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                )
              ),
              Container(
                width: 2,
                height: 50,
                color: Colors.white54,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.south_west, color: Colors.black87, size: 18),
                        SizedBox(width: 5),
                        Text(
                          'Total Expense',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '-\$1,187.40',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5B5BFF),
                      ),
                    )
                  ],
                )
              )
            ],
          ),

          const SizedBox(height: 20),

          //Progress Bar
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.3,
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: Text(
                          '30%',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 15,
                    top: 12,
                    child: const Text(
                      '\$20,000.00',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    )
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.black87, size: 18),
                  SizedBox(width: 8),
                  Text(
                    '30% Of Your Expenses, Looks Good.',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFD4EDD7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildPeriodButton('Daily'),
          _buildPeriodButton('Weekly'),
          _buildPeriodButton('Monthly'),
          _buildPeriodButton('Year'),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    final isSelected = selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedPeriod = period;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1CD8A0) : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            period,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ),
      )
    );
  }

  Widget _buildIncomeExpensesChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFD4EDD7),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Income & Expenses',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1CD8A0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1CD8A0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                      size: 22,
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          _buildBarChart(),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    final List<Map<String, dynamic>> data = [
      {'day': 'Mon', 'income': 3000, 'expense': 8000},
      {'day': 'Tue', 'income': 500, 'expense': 1000},
      {'day': 'Wed', 'income': 8000, 'expense': 3000},
      {'day': 'Thu', 'income': 500, 'expense': 5000},
      {'day': 'Fri', 'income': 12000, 'expense': 10000},
      {'day': 'Sat', 'income': 1000, 'expense': 500},
      {'day': 'Sun', 'income': 1000, 'expense': 6000},
    ];

    final maxValue = 15000.0;

    return Column(
      children: [
        //Y-axis labels
        SizedBox(
          height: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('15k', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text('10k', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text('5k', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text('1k', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: data.map((item) {
                    return _buildBarPair(
                      item['income'] as int,
                      item ['expense'] as int,
                      maxValue,
                    );
                  }).toList(),
                )
              )
            ],
          ),
        ),
        const SizedBox(height: 5),
        //X-Axis labels
        Row(
          children: [
            const SizedBox(width: 45),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: data.map((item) {
                  return Text(
                    item['day'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87, 
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }).toList(),
              )
            )
          ],
        )
      ],
    );
  }

  Widget _buildBarPair(int income, int expense, double maxValue) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 8,
          height: (income/maxValue *150).clamp(5, 150),
          decoration: BoxDecoration(
            color: const Color(0xFF5B5BFF),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 3),
        Container(
          width: 8,
          height: (expense / maxValue * 150).clamp(5, 150),
          decoration: BoxDecoration(
            color: const Color(0xFF1CD8A0),
            borderRadius: BorderRadius.circular(4),
          ),
        )
      ],
    );
  }

  Widget _buildIncomeExpensesSummary() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1CD8A0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_outward,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Income',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  '\$4,120.00',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          )
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B5BFF).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.south_west, 
                    color: Color(0xFF5B5BFF),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Expense',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  '\$1,187.40',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5B5BFF),
                  ),
                )
              ],
            ),
          )
        )
      ],
    );
  }

  Widget _buildTargetsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildTargetCard('Travel', 0.3, 'Travel'),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildTargetCard('Car', 0.7, 'Car'),
        ),
      ],
    );
  }

  Widget _buildTargetCard(String title, double progress, String label) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7CB8FF), Color(0xFF5B9FFF)],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 15),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        color: Color(0xFFE8F5E9),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, false),
          _buildNavItem(Icons.query_stats, true),
          _buildNavItem(Icons.swap_horiz, false),
          _buildNavItem(Icons.layers_outlined, false),
          _buildNavItem(Icons.person_outline, false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1CD8A0) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        icon,
        color: Colors.black,
        size: 28,
      ),
    );
  }
}
