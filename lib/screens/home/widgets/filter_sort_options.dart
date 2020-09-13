import 'package:flutter/material.dart';
import 'package:offcampus/screens/home/widgets/filter_bottom_sheet.dart';

class FilterSortOptions extends StatelessWidget {
  final List<String> uniOptions;
  final Function uniCallback;
  final String selectedUni;
  final List<String> facultyOptions;
  final Function facultyCallback;
  final String selectedFaculty;

  const FilterSortOptions({
    Key key,
    @required this.uniOptions,
    @required this.uniCallback,
    @required this.selectedUni,
    this.facultyOptions,
    this.facultyCallback,
    this.selectedFaculty,
  })  : assert(uniOptions != null),
        assert(uniCallback != null),
        assert(selectedUni != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => FilterBottomSheet.show(
              context: context,
              uniOptions: uniOptions,
              uniCallback: uniCallback,
              selectedUni: selectedUni,
              facultyOptions: facultyOptions,
              facultyCallback: facultyCallback,
              selectedFaculty: selectedFaculty,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Filter',
                    style: TextStyle(color: Colors.black54),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sort',
                    style: TextStyle(color: Colors.black54),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
