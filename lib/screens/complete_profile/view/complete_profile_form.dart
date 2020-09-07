import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offcampus/common/consts.dart';
import 'package:offcampus/widgets/widgets.dart';

class CompleteProfileForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  File _image;
  final _imagePicker = ImagePicker();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: MyCard(
          child: Padding(
            padding: kLayoutPadding,
            child: Column(
              children: [
                Text('Add a profile picture'),
                WidgetPadding(),
                _buildSelectImage(),
                WidgetPadding(),
                TextField(
                  controller: _textController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Summary',
                    helperText:
                        'Add a summary about yourself so that others can learn more about you',
                    helperMaxLines: 2,
                  ),
                ),
                WidgetPadding(),
                RaisedButton(
                  onPressed: _image != null || _textController.text.isNotEmpty
                      ? () {}
                      : null,
                  color: Theme.of(context).primaryColor,
                  shape: StadiumBorder(),
                  child: Text('Save', style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectImage() {
    return Ink(
      width: 120.0,
      height: 120.0,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: InkWell(
        onTap: _getImage,
        borderRadius: BorderRadius.circular(100.0),
        child: _image == null
            ? Icon(Icons.camera_alt, size: 48.0)
            : ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Image.file(
                  _image,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }

  Future _getImage() async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
    setState(() => _image = File(pickedFile.path));
  }
}
