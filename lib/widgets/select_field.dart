import 'package:flutter/material.dart';

class SelectField extends StatelessWidget {
  final String label;
  final String selected;
  final Function onTap;

  const SelectField({Key key, @required this.label, this.selected, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(30.0);

    return Ink(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: borderRadius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        selected ?? 'Select',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.grey)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
