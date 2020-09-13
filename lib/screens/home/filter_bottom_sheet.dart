import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:offcampus/common/consts.dart';
import 'package:offcampus/widgets/widgets.dart';

typedef CallbackFunc = void Function(String string);

class FilterBottomSheet {
  static void show({
    @required BuildContext context,
    @required List<String> uniOptions,
    @required CallbackFunc uniCallback,
    @required String selectedUni,
    List<String> facultyOptions,
    CallbackFunc facultyCallback,
    String selectedFaculty,
  }) {
    assert(context != null);
    assert(uniOptions != null);
    assert(uniCallback != null);
    assert(selectedUni != null);

    showCustomModalBottomSheet(
      context: context,
      builder: (context, scrollController) => _ModalFit(
        uniOptions: uniOptions,
        uniCallback: uniCallback,
        selectedUni: selectedUni,
        facultyOptions: facultyOptions,
        facultyCallback: facultyCallback,
        selectedFaculty: selectedFaculty,
      ),
      containerWidget: (context, animation, child) {
        return FloatingModal(child: child);
      },
      expand: false,
    );
  }
}

class _ModalFit extends StatelessWidget {
  final List<String> uniOptions;
  final CallbackFunc uniCallback;
  final String selectedUni;
  final List<String> facultyOptions;
  final CallbackFunc facultyCallback;
  final String selectedFaculty;

  const _ModalFit({
    Key key,
    @required this.uniOptions,
    @required this.uniCallback,
    @required this.selectedUni,
    this.facultyOptions,
    this.facultyCallback,
    this.selectedFaculty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Text(
        'University',
        style:
            Theme.of(context).textTheme.subtitle1.apply(color: Colors.black54),
      ),
      ...uniOptions.map((uniOption) {
        return _OptionTile(
          option: uniOption,
          isSelected: uniOption == selectedUni,
          callback: uniCallback,
        );
      }).toList(),
      Text(
        'Faculty',
        style:
            Theme.of(context).textTheme.subtitle1.apply(color: Colors.black54),
      ),
    ];

    if (facultyOptions != null) {
      children.addAll(facultyOptions.map((facultyOption) {
        return _OptionTile(
          option: facultyOption,
          isSelected: facultyOption == selectedFaculty,
          callback: facultyCallback,
        );
      }));
    } else {
      children.add(Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          'Select a university to see the faculty options',
          style: TextStyle(color: Colors.black54),
        ),
      ));
    }

    return ListView(
      shrinkWrap: true,
      padding: kLayoutPadding,
      children: children,
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String option;
  final bool isSelected;
  final Function callback;

  const _OptionTile({
    Key key,
    @required this.option,
    @required this.isSelected,
    @required this.callback,
  })  : assert(option != null),
        assert(isSelected != null),
        assert(callback != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontWeight = isSelected ? FontWeight.bold : FontWeight.w300;

    return InkWell(
      onTap: () {
        callback(option);
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: Text(
          option,
          style: TextStyle(fontSize: 16, fontWeight: fontWeight),
        ),
      ),
    );
  }
}
