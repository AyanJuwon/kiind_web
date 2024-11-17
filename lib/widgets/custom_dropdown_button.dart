import 'package:flutter/material.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final T value;
  final Function onChanged;
  final Color? borderColor;
  final Color? dropdownColor;

  const CustomDropdownButton(
      {Key? key,
      this.borderColor,
      this.dropdownColor,
      required this.items,
      required this.value,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: borderColor != null
                      ? borderColor!
                      : Colors.black.withOpacity(0.4),
                  width: 1),
              borderRadius: BorderRadius.circular(8)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 18)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          dropdownColor: dropdownColor,
          items: items,
          onChanged: (value) => onChanged(value),
          value: value,
          elevation: 0,
        ),
      ),
    );
  }
}
