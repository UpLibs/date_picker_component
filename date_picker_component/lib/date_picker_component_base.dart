// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// TODO: Put public facing types in this file.

part of date_picker_component;

class DatePickerCore {

     int firstDayOfWeek ;
     List<String> monthTexts = [] ;
     List<String> weekdayTexts = [] ;
     DateTime today = new DateTime.now() ;
     bool showDiv = false ;
     Timer timer ;
     String inputid = "" ;
     String inputplaceholder = "" ;
     int inputmaxlength = 9999 ;
     String value ;
     DateTime date = new DateTime.now() ;
     List<List<int>> calendarList = [] ;
     
     bool ready = false ;
     
     bool lastHourMinutes = false ;
     
     DatePickerCore(){
       init();
     }
    
    init(){
      
      findSystemLocale().then((_) {
        initializeDateFormatting(Intl.systemLocale, null).then((_) {
          _initializeTexts(new DateFormat.E().dateSymbols);
          ready = true;
        });
      });
      
    }

    //TODO
    onPropertyDateChange() {
      // date
      _calculateCalendarList();
    }
    
    //TODO
    onPropertyFirstDayOfWeekChange() {
      // firstDayOfWeek
      _calculateCalendarList();
    }

    _calculateCalendarList() {
      if (date == null || firstDayOfWeek == null) return;
      DateTime first = new DateTime(date.year, date.month, 1);
      DateTime last = new DateTime(date.year, date.month + 1, 1).subtract(new Duration(days: 1));
      calendarList.clear();
      List<int> weekList = [null, null, null, null, null, null, null];
      int pos = first.weekday - firstDayOfWeek;
      if (pos >= 7) pos -= 7;
      if (pos < 0) pos += 7;
      for (int i = 1; i <= last.day; i++) {
        weekList[pos] = i;
        pos++;
        if (pos >= 7) {
          calendarList.add(weekList);
          weekList = [null, null, null, null, null, null, null];
          pos = 0;
        }
      }
      if (pos > 0) calendarList.add(weekList);
    }

    bool isToday(int day) {
      if (date.year == today.year && date.month == today.month && day == today.day) return true; else return false;
    }
    
    void chooseDay(int day) {
      
      if(lastHourMinutes) {
       date = new DateTime(date.year, date.month, day, 23, 59, 59);
      }
      else {
       date = new DateTime(date.year, date.month, day);
      }
      
      value = date.toString().substring(0, 10);
      showDiv = false;
      //new
      onPropertyDateChange();
    }
    
    void onValueChange([String valueAux = null]) {
      
      if(valueAux != null) {
        try {
          date = DateTime.parse(valueAux);
          value = valueAux;
        } catch (exception, stackTrace) {
        //print('Invalid format');
        //          var formatter = new DateFormat('dd/MM/yyyy');
        //          String formatted = formatter.format(date);
        //          value = formatted;
        }
      }
      else {    
        
        try {
         date = DateTime.parse(value);
        } catch (e) {
         date = new DateTime.now();
        }
      }
      
      if(lastHourMinutes) {
        date = new DateTime(date.year, date.month, date.day, 23, 59, 59);
      }
      
      onPropertyDateChange();
    }
    
    void show() {
      onValueChange();
      showDiv = !showDiv;
    }
    
    void close(Event e, var detail, Element sender) {
      showDiv = false;
    }
    
    void previousYear() {
      date = new DateTime(date.year - 1, date.month, 1);
      value = date.toString().substring(0, 10);
      onValueChange();
    }
    
    void nextYear() {
      date = new DateTime(date.year + 1, date.month, 1);
      value = date.toString().substring(0, 10);
      onValueChange();
    }
    
    void previousMonth() {
      date = new DateTime(date.year, date.month - 1, 1);
      value = date.toString().substring(0, 10);
      onValueChange();
    }
    
    void nextMonth() {
      date = new DateTime(date.year, date.month + 1, 1);
      value = date.toString().substring(0, 10);
      onValueChange();
    }
    
    void setDate(DateTime dateAux){
        date = new DateTime(dateAux.year, dateAux.month, dateAux.day, dateAux.hour, dateAux.minute, dateAux.second);
        value = date.toString().substring(0, 10);
        onValueChange();  
    }
    
    void _initializeTexts(DateSymbols ds) {
      value = date.toString().substring(0, 10);
      firstDayOfWeek = ds.FIRSTDAYOFWEEK;
      weekdayTexts.clear();
      for (int i = 0; i < 7; i++) {
        int k = firstDayOfWeek + i;
        if (k >= 7) k = k - 7;
        weekdayTexts.add(ds.STANDALONESHORTWEEKDAYS[k]);
      }
      monthTexts.clear();
      monthTexts.addAll(ds.STANDALONESHORTMONTHS);
      _calculateCalendarList();
    }
    
}