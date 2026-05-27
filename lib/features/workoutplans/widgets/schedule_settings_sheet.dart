import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/models/workout_plan_model.dart';

class ScheduleSettingsSheet extends StatefulWidget {
  final WorkoutPlanModel plan;

  const ScheduleSettingsSheet({super.key, required this.plan});

  @override
  State<ScheduleSettingsSheet> createState() => _ScheduleSettingsSheetState();
}

class _ScheduleSettingsSheetState extends State<ScheduleSettingsSheet> {
  late DateTime _selectedStartDate;
  late List<int> _selectedRestDays;

  bool get _hasExistingSchedule =>
      widget.plan.startDate != null || widget.plan.restDays.isNotEmpty;

  final List<String> _weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  final List<int> _weekDayValues = [1, 2, 3, 4, 5, 6, 7]; // Dart weekday values

  @override
  void initState() {
    super.initState();
    _selectedStartDate = widget.plan.startDate ?? DateTime.now();
    _selectedRestDays = List<int>.from(widget.plan.restDays);
  }

  Future<void> _pickStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              surface: const Color.fromARGB(255, 29, 28, 28),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedStartDate = picked;
      });
    }
  }

  void _toggleRestDay(int weekday) {
    setState(() {
      if (_selectedRestDays.contains(weekday)) {
        _selectedRestDays.remove(weekday);
      } else {
        _selectedRestDays.add(weekday);
      }
    });
  }

  void _saveSettings() {
    final updatedPlan = widget.plan.copyWith(
      startDate: _selectedStartDate,
      restDays: _selectedRestDays,
    );
    Navigator.pop(context, updatedPlan);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.grey,
          image: DecorationImage(
            image: AssetImage("assets/img/bg3.jpg"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Text(
                  'Schedule Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Montserrat",
                  ),
                ),
                SizedBox(height: 24),

                // Start Date Section
                Text(
                  'Start Date',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Montserrat",
                  ),
                ),
                SizedBox(height: 12),
                GestureDetector(
                  onTap: _pickStartDate,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_selectedStartDate.year}-${_selectedStartDate.month.toString().padLeft(2, '0')}-${_selectedStartDate.day.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 28),
                // Rest Days Section
                Row(
                  children: [
                    Text(
                      'Rest Days',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.edit, size: 18, color: Colors.white70),
                    SizedBox(width: 6),
                    Text(
                      'Tap days to change',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(_weekDays.length, (index) {
                    final weekday = _weekDayValues[index];
                    final dayName = _weekDays[index];
                    final isSelected = _selectedRestDays.contains(weekday);

                    return GestureDetector(
                      onTap: () => _toggleRestDay(weekday),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          dayName.substring(0, 3),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 32),

                // Summary
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Summary',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Montserrat",
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Plan starts: ${_selectedStartDate.toString().split(' ')[0]}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontFamily: "Montserrat",
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Rest days: ${_selectedRestDays.isEmpty ? 'None' : _selectedRestDays.map((d) => _weekDays[d - 1]).join(', ')}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontFamily: "Montserrat",
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.1),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveSettings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _hasExistingSchedule
                              ? 'View Schedule'
                              : 'Save & View Schedule',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
