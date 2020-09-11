import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offcampus/blocs/auth/auth.dart';
import 'package:offcampus/common/consts.dart';
import 'package:offcampus/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompleteProfileForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _imagePicker = ImagePicker();
  final _textController = TextEditingController();
  File _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: Padding(
        padding: kLayoutPadding,
        child: Column(
          children: [
            Text('Add a profile picture'),
            WidgetPadding(),
            _buildSelectImage(),
            WidgetPadding(),
            _buildTextField(),
            WidgetPadding(),
            SizedBox(
                height: 36.0,
                child:
                    _isLoading ? CircularProgressIndicator() : _buildButton()),
          ],
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

  Widget _buildTextField() {
    return TextField(
      controller: _textController,
      maxLines: 4,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Summary',
        helperText:
            'Add a summary about yourself so that others can learn more about you',
        helperMaxLines: 2,
      ),
    );
  }

  Widget _buildButton() {
    final user = context.bloc<AuthBloc>().state.user;

    return RaisedButton(
      onPressed: _image != null && _textController.text.isNotEmpty
          ? () {
              setState(() => _isLoading = true);
              context
                  .bloc<AuthBloc>()
                  .add(UpdateProfile(user.id, _image, _textController.text));
            }
          : null,
      color: Theme.of(context).primaryColor,
      shape: StadiumBorder(),
      child: Text('Save', style: TextStyle(color: Colors.white)),
    );
  }

  Future _getImage() async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
    setState(() => _image = File(pickedFile.path));
  }
}
