# date_picker_component

A component date picker using pure dart, based on datepicker polymer version.

## Usage

A simple usage example:

```dart

void main() {
 //Div Element in html
  Element el = querySelector("#sample_container_id");
  build(el);
}

build(Element parentElement) {
  
  DatePickerComponent datePicker = new DatePickerComponent();
  
  datePicker.showAt(parentElement);
  
  DateTime currentDate = datePicker.getCurrentDate();
  
  print(currentDate);
  
}
    
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
