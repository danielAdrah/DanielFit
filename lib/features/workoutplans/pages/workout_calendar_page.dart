// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../core/theme.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/gearless_app_bar.dart';
import '../../../core/models/workout_plan_model.dart';
import '../data/bloc/workout_plan_bloc.dart';
import '../data/bloc/workout_plan_event.dart';
import '../data/bloc/workout_plan_state.dart';
import '../data/models/workout_schedule_entry.dart';

class WorkoutCalendarPage extends StatefulWidget {
  const WorkoutCalendarPage({
    super.key,
    this.workoutPlan,
    this.horizonDays = 60,
  });

  final WorkoutPlanModel? workoutPlan;
  final int horizonDays;

  @override
  State<WorkoutCalendarPage> createState() => _WorkoutCalendarPageState();
}

class _WorkoutCalendarPageState extends State<WorkoutCalendarPage> {
  final List<Appointment> _events = [];
  List<WorkoutScheduleEntry> _scheduleEntries = [];
  DateTime _selectedDate = DateTime.now();
  WorkoutScheduleEntry? _selectedEntry;

  List<Appointment> get _selectedDayEvents {
    final selectedDay = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    return _events.where((event) {
      final eventDay = DateTime(
        event.startTime.year,
        event.startTime.month,
        event.startTime.day,
      );
      return eventDay == selectedDay;
    }).toList();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  WorkoutScheduleEntry? _findEntryForAppointment(Appointment event) {
    for (final entry in _scheduleEntries) {
      final entryDate = DateTime(
        entry.date.year,
        entry.date.month,
        entry.date.day,
      );
      final eventDate = DateTime(
        event.startTime.year,
        event.startTime.month,
        event.startTime.day,
      );

      if (entry.isRestDay && event.location == 'rest') {
        if (entryDate == eventDate) return entry;
      }

      if (entryDate == eventDate && entry.workoutDay?.id == event.location) {
        return entry;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  @override
  void didUpdateWidget(WorkoutCalendarPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.workoutPlan?.id != widget.workoutPlan?.id ||
        oldWidget.workoutPlan?.startDate != widget.workoutPlan?.startDate ||
        oldWidget.workoutPlan?.restDays != widget.workoutPlan?.restDays) {
      _loadSchedule();
    }
  }

  void _loadSchedule() {
    if (widget.workoutPlan != null) {
      try {
        context.read<WorkoutPlanBloc>().add(
          GenerateWorkoutPlanScheduleEvent(
            widget.workoutPlan!.id,
            scheduleStartDate: widget.workoutPlan!.startDate ?? DateTime.now(),
            horizonDays: widget.horizonDays,
          ),
        );
      } catch (e) {
        // BLoC not available, fallback to sample
        _initializeSampleEvents();
      }
    } else {
      _initializeSampleEvents();
    }
  }

  void _initializeSampleEvents() {
    _events.clear();
    _events.addAll([
      Appointment(
        startTime: DateTime.now().add(const Duration(days: 1, hours: 9)),
        endTime: DateTime.now().add(const Duration(days: 1, hours: 10)),
        subject: 'Sample Chest Day',
        color: AppColors.primary,
        isAllDay: true,
        location: 'sample',
      ),
      Appointment(
        startTime: DateTime.now().add(const Duration(days: 3, hours: 9)),
        endTime: DateTime.now().add(const Duration(days: 3, hours: 10)),
        subject: 'Sample Rest Day',
        color: Colors.grey,
        isAllDay: true,
        location: 'rest',
      ),
    ]);
  }

  List<Appointment> _buildAppointments(
    List<WorkoutScheduleEntry> scheduleEntries,
  ) {
    return scheduleEntries.map((entry) {
      final appointmentTime = DateTime(
        entry.date.year,
        entry.date.month,
        entry.date.day,
        8,
      );

      return Appointment(
        startTime: appointmentTime,
        endTime: appointmentTime.add(const Duration(hours: 1)),
        subject: entry.subject,
        color: entry.isRestDay ? Colors.grey : AppColors.primary,
        isAllDay: true,
        location: entry.isRestDay ? 'rest' : entry.workoutDay!.id,
        notes: entry.targetMuscles,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    final Appointment? selectedAppointment = _selectedDayEvents.isNotEmpty
        ? _selectedDayEvents.first
        : null;

    return BlocListener<WorkoutPlanBloc, WorkoutPlanState>(
      listener: (context, state) {
        if (state is WorkoutPlanScheduleLoaded) {
          setState(() {
            _scheduleEntries = state.scheduleEntries;
            _events
              ..clear()
              ..addAll(_buildAppointments(_scheduleEntries));
          });
        }
      },
      child: AppBackground(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  stretch: true,
                  expandedHeight: width * 0.25,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: GearlessAppBar(width: width),
                  ),
                ),
                SliverToBoxAdapter(
                  child: FadeInRight(
                    delay: Duration(milliseconds: 600),
                    child: Stack(
                      children: [
                        // decoration container
                        Container(
                          height: 400,
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/img/bg3.jpg'),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              width: 1.5,
                              color: AppColors.primary,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.6),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                                spreadRadius: -3,
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.1),
                                blurRadius: 6,
                                offset: Offset(0, -3),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Container(),
                        ),
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              height: 400,
                              margin: EdgeInsets.all(20),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 400,
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: SfCalendar(
                            view: CalendarView.month,
                            dataSource: MeetingDataSource(_events),
                            todayHighlightColor: AppColors.primary,
                            viewHeaderHeight: 30,
                            viewHeaderStyle: ViewHeaderStyle(
                              dayTextStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            cellBorderColor: AppColors.primary.withOpacity(0.5),
                            headerStyle: CalendarHeaderStyle(
                              textAlign: TextAlign.center,
                              backgroundColor: AppColors.primary.withOpacity(
                                0.4,
                              ),
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            monthViewSettings: MonthViewSettings(
                              showAgenda: false,
                              appointmentDisplayMode:
                                  MonthAppointmentDisplayMode.indicator,
                              monthCellStyle: MonthCellStyle(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                                leadingDatesTextStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                                trailingDatesTextStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              ),
                              agendaStyle: AgendaStyle(
                                appointmentTextStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                dateTextStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            selectionDecoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.18),
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            onTap: (CalendarTapDetails details) {
                              final selectedDate = details.date;
                              final appointment =
                                  details.appointments != null &&
                                      details.appointments!.isNotEmpty
                                  ? details.appointments!.first as Appointment
                                  : null;

                              setState(() {
                                if (selectedDate != null) {
                                  _selectedDate = selectedDate;
                                }
                                _selectedEntry = appointment != null
                                    ? _findEntryForAppointment(appointment)
                                    : null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: height * 0.02)),
                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: FadeInLeft(
                          delay: Duration(milliseconds: 750),
                          child: Text(
                            "What we have to day: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              fontFamily: "Montserrat",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: height * 0.02)),
                //card to display events
                SliverToBoxAdapter(
                  child: FadeInLeft(
                    delay: Duration(milliseconds: 750),
                    child: Stack(
                      children: [
                        Container(
                          width: width,
                          margin: EdgeInsetsGeometry.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/img/bg3.jpg'),
                              fit: BoxFit.cover,
                            ),

                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.6),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                                spreadRadius: -3,
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.1),
                                blurRadius: 6,
                                offset: Offset(0, -3),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedEntry != null
                                    ? _selectedEntry!.isRestDay
                                          ? 'Rest Day'
                                          : _selectedEntry!
                                                    .workoutDay
                                                    ?.dayName ??
                                                'Workout Day'
                                    : selectedAppointment != null
                                    ? selectedAppointment.subject
                                    : _isSameDay(_selectedDate, DateTime.now())
                                    ? 'Event'
                                    : 'todayEvent ${_formatDate(_selectedDate)}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                              SizedBox(height: 10),
                              if (_selectedEntry != null) ...[
                                Text(
                                  _selectedEntry!.isRestDay
                                      ? 'Recovery day for your body(Eat and Sleep ma Nigga).'
                                      : 'Target muscles: ${_selectedEntry!.targetMuscles}',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Date: ${_formatDate(_selectedEntry!.date)}',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ] else if (selectedAppointment != null) ...[
                                Text(
                                  selectedAppointment.notes!.isNotEmpty
                                      ? 'Target muscles: ${selectedAppointment.notes}'
                                      : 'Target muscles information unavailable',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Date: ${_formatDate(_selectedDate)}',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  'No Events',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            // width: width,
                            // height: 60,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
