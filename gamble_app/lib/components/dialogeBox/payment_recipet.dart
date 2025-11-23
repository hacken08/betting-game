import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:gamble_app/components/buttons.dart';
import 'package:gamble_app/components/chat/chatbox.dart';
import 'package:gamble_app/utils/utilsmethod.dart';
import 'package:go_router/go_router.dart';

openRacpietDialoge(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => Container(
      child: Text("thi si container"),
    ),
  );
}

showDatePickerCalendar(
  BuildContext context, {
  DateTime? prevSelectedDateTime,
  void Function(DateTime date)? onDateSelect,
}) {
  DateTime selectDate =
      prevSelectedDateTime == null ? DateTime.now() : prevSelectedDateTime;

  return showDialog(
    context: context,
    builder: (context) {
      final size = MediaQuery.of(context).size;

      final config = CalendarDatePicker2Config(
        selectedDayHighlightColor: Colors.amber[900],
        weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        weekdayLabelTextStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        firstDayOfWeek: 1,
        controlsHeight: 30,
        calendarType: CalendarDatePicker2Type.single,
        dayMaxWidth: 42,
        animateToDisplayedMonthDate: true,
        controlsTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        dayTextStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        disabledDayTextStyle: const TextStyle(
          color: Colors.grey,
        ),
        centerAlignModePicker: true,
        useAbbrLabelForMonthModePicker: true,
        modePickersGap: 5,
        firstDate: DateTime.now().subtract(const Duration(days: 365 * 3)),
        lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
        selectableDayPredicate: (day) =>
            day.difference(DateTime.now()).isNegative,
      );

      return Material(
        type: MaterialType.transparency,
        child: Center(
          child: SizedBox(
            width: size.width * 0.9, // Adjust dialog width if needed
            // height: size.height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 13),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      CalendarDatePicker2(
                        displayedMonthDate: selectDate,
                        config: config,
                        value: [selectDate],
                        onValueChanged: (dates) => selectDate = dates[0],
                      ),
                      // const SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SelectionButon(
                            label: "Close",
                            onButtonClick: () => context.pop(),
                            customDecoration: BoxDecoration(border: Border()),
                          ),
                          SelectionButon(
                            label: " Ok ",
                            onButtonClick: () {
                              if (onDateSelect == null) {
                                context.pop();
                                return;
                              }
                              onDateSelect(selectDate);
                              context.pop();
                            },
                            newStyle: TextStyle(color: Colors.white),
                            customDecoration: BoxDecoration(
                                color: Colors.amber[900], border: Border()),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
