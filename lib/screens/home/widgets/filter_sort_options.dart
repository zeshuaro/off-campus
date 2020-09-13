import 'package:flutter/material.dart';
import 'package:offcampus/common/consts.dart';
import 'package:offcampus/screens/home/widgets/filter_bottom_sheet.dart';
import 'package:offcampus/widgets/widgets.dart';

class FilterSortOptions extends StatelessWidget {
  final List<String> uniOptions;
  final Function uniCallback;
  final String selectedUni;
  final List<String> facultyOptions;
  final Function facultyCallback;
  final String selectedFaculty;
  final String sortBy;
  final Function sortCallback;

  const FilterSortOptions({
    Key key,
    @required this.uniOptions,
    @required this.uniCallback,
    @required this.selectedUni,
    this.facultyOptions,
    this.facultyCallback,
    this.selectedFaculty,
    this.sortBy,
    this.sortCallback,
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
            onTap: () => MyBottomSheet.show(
              context: context,
              options: kSortOptions,
              callback: sortCallback,
              selected: sortBy,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    sortBy,
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
