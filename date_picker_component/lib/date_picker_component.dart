// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The date_picker_component library.
///
/// This is an awesome library. More dartdocs go here.
library date_picker_component;

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_browser.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbols.dart';
import 'dart:async';
import 'dart:html';

part './date_picker_component_base.dart' ;
// TODO: Export any libraries intended for clients of this package.

class DatePickerComponent {

  SpanElement containerSpan ;
  SpanElement parentSpan ;
  
  /* Date Picker  */
  DivElement datePickerDiv ;
  DivElement yearMonthDiv ;
  
  ButtonElement previousMonthButton ;
  LabelElement labelMonth ;
  ButtonElement nextMonthButton ;
  
  ButtonElement previousYearButton ;
  LabelElement labelYear ;
  ButtonElement nextYearButton ;
  
  DivElement innerDiv ;
  TableElement innerTable ;
  TableSectionElement tableTBody ;
  SpanElement pickerSpan ;
  InputElement xDateInputPicker ;
  
  DatePickerCore core ;
  
  String _marginTop = '10px';
  
  
  /* Controls */
  
  DatePickerComponent() {
    core = new DatePickerCore() ;
  }
  
  onReady(Timer timer) {
    if(core.ready) {
      init() ;
      initListeners() ;
      parent.append(containerSpan) ;
      timer.cancel() ;
    }
  }
  
  init() {
    
    containerSpan = new SpanElement() ;
    
    parentSpan = new SpanElement() 
     ..style.display = 'xdateinput_container' 
     ..style.position = 'relative' ;
    
    datePickerDiv = new DivElement() 
    ..style.position = 'absolute' 
    ..style.marginTop = _marginTop
    ..style.position = 'absolute' 
    ..style.padding = '5px 5px 5px 5px'
    ..style.zIndex = '999'
    ..style.border = '1px solid'
    ..style.backgroundColor = '#fff' ;
    
    yearMonthDiv = new DivElement() 
    ..style.textAlign = 'center'
    ..style.whiteSpace = 'no-wrap' ;
    
    previousMonthButton = new ButtonElement()
    ..innerHtml = "&larr;"
    ..style.display = 'inline' 
    ..onMouseOver.listen((ev) => onMouseHoverListener(ev,previousMonthButton)) ;
    
    nextMonthButton = new ButtonElement()
     ..innerHtml = "&rarr;"
     ..style.display = 'inline' 
     ..onMouseOver.listen((ev) => onMouseHoverListener(ev,nextMonthButton)) ;
    
    labelMonth = new LabelElement()
     ..text = core.monthTexts[core.date.month - 1] ;
    
    previousYearButton = new ButtonElement()
     ..innerHtml = "&larr;"
     ..style.display = 'inline' 
     ..onMouseOver.listen((ev) => onMouseHoverListener(ev,previousYearButton)) ;
    
    nextYearButton = new ButtonElement()
     ..innerHtml = "&rarr;"
     ..style.display = 'inline' 
     ..onMouseOver.listen((ev) => onMouseHoverListener(ev,nextYearButton)) ;
    
    labelYear = new LabelElement()
      ..text = core.date.year.toString() ;
    
    innerDiv = new DivElement() ;
                       
    innerTable = new TableElement() ;
    
    pickerSpan = new SpanElement()
    ..style.cursor = 'pointer' ;
    
    xDateInputPicker = new InputElement() 
    ..style.display = 'inline'
    ..onMouseOver.listen((ev) => onMouseHoverListener(ev,xDateInputPicker)) ;
    
    ///////////// HEAD /////////////
    
    TableSectionElement createTHead = innerTable.createTHead() ;
    
    List<Element> weekDaysEl = new List<Element>() ;
    
    core.weekdayTexts.forEach((weekText) {
      weekDaysEl.add(new Element.tag('th')
          ..text = weekText
          ..style.textAlign = 'center');
    });
    
    createTHead.insertRow(0)
    ..nodes.addAll(weekDaysEl);
    
    //////////// BODY //////////////
    
    tableTBody = innerTable.createTBody();
    
    updateTableBody();
    
    pickerSpan..innerHtml = '&darr;';
    datePickerDiv.hidden = true;
    
    xDateInputPicker.id = core.inputid;
    xDateInputPicker.maxLength = core.inputmaxlength;
    xDateInputPicker.disabled = true;
    
    xDateInputPicker.onChange.listen((ev) => core.onValueChange());
        
    //////////////////////////////////////////////////////////////////////
    
    innerDiv.append(innerTable);
    
    yearMonthDiv.append(previousMonthButton);
    yearMonthDiv.append(labelMonth);
    yearMonthDiv.append(nextMonthButton);
    yearMonthDiv.append(previousYearButton);
    yearMonthDiv.append(labelYear);
    yearMonthDiv.append(nextYearButton);

    datePickerDiv.append(yearMonthDiv);
    datePickerDiv.append(innerDiv);
    
    parentSpan.append(datePickerDiv);    
    
    containerSpan.append(parentSpan);
    containerSpan.append(pickerSpan);    
    containerSpan.append(xDateInputPicker);
  }
  
  void _showCalendar([bool isDayClick = true]) {    
    
    if(!isDayClick) core.show() ;
    
    if(core.showDiv) {
      pickerSpan..innerHtml = '&uarr;' ;
      datePickerDiv.hidden = false ;
    }
    else
    {
      pickerSpan..innerHtml = '&darr;' ;
      datePickerDiv.hidden = true ;
    }
  }
  
  updateTableBody() {
    
    if(tableTBody != null) tableTBody.remove() ;
    
    tableTBody = innerTable.createTBody() ;
    
    int i = 0 ;
    
    core.calendarList.forEach((listWeeks) {
      
      TableRowElement insertRow = tableTBody.insertRow(i++) ;
      
      List<int> weekList = listWeeks ;
      int aux = 0 ;
      
      weekList.forEach((day) {
        
        TableCellElement tableCellElement = insertRow.insertCell(aux++)
        ..style.textAlign = 'center' ;  
        
        if(day != null){

          DivElement divElem = new DivElement()
          ..text = day.toString()
          ..style.cursor = 'pointer';
          
          divElem..onMouseOver.listen((ev) => onMouseHoverListener(ev,divElem));
          
          if(core.isToday(day)){
            divElem..style.fontWeight = 'bold'
                   ..style.border = '1px solid' ;
          } 
                
          divElem.onClick.listen((event) {
            core.chooseDay(day) ;
            xDateInputPicker..value = core.value;
            xDateInputPicker..text = core.value;
            xDateInputPicker.id = core.inputid;
            xDateInputPicker.maxLength = core.inputmaxlength;
            _showCalendar();
          });
          
          tableCellElement.append(divElem) ;
          
        }
        
      });

    });
  }
  
  initListeners() {
    
    pickerSpan.onClick.listen((event) {
      _showCalendar(false) ;
      if(core.showDiv){
        updateTableBody() ;        
        labelMonth.text = core.monthTexts[core.date.month - 1] ;
        labelYear.text = core.date.year.toString() ;
      }
    }) ;
    
    previousMonthButton.onClick.listen((e) {
      core.previousMonth() ;
      labelMonth.text = core.monthTexts[core.date.month - 1] ;
      labelYear.text = core.date.year.toString() ;
      updateTableBody() ;
    }) ;
    
    nextMonthButton.onClick.listen((e) { 
      core.nextMonth() ;
      labelMonth.text = core.monthTexts[core.date.month - 1] ;
      labelYear.text = core.date.year.toString() ;
      updateTableBody() ;
    }) ;
    
    previousYearButton.onClick.listen((e) { 
      core.previousYear() ;
      labelYear.text = core.date.year.toString() ;
      updateTableBody() ;
    }) ;
    
    nextYearButton.onClick.listen((e) {
      core.nextYear() ;
      labelYear.text = core.date.year.toString() ;
      updateTableBody() ;
    }) ;    
    
  }
  
  setDate(DateTime date) {
    if(core.ready){
     core.setDate(date) ;
     xDateInputPicker..value = core.value ;
     xDateInputPicker..text = core.value ;
    }
  }
  
  setMarginTop(String margin) {
    _marginTop = margin ;
  }
  
  Element parent;
  showAt(Element parent) {
    this.parent = parent;
    Timer timer = new Timer.periodic(new Duration(milliseconds: 500), onReady);
  }
  
  onMouseHoverListener(MouseEvent event,[Element el]) {
    el..style.display = 'pointer' ;
  }
  
  DateTime getCurrentDate() {
   return core.date;
  }
  
}