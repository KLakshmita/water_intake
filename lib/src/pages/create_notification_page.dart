import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder_app/models/notification_data.dart';
import 'package:water_reminder_app/src/global_blocs/app_bloc.dart';
import 'package:water_reminder_app/src/global_blocs/notification_bloc.dart';
import 'package:water_reminder_app/src/widgets/buttons/custom_wide_flat_button.dart';
import 'package:water_reminder_app/src/widgets/custom_input_field.dart';

class CreateNotificationPage extends StatefulWidget {
  @override
  _CreateNotificationPageState createState() => _CreateNotificationPageState();
}

class _CreateNotificationPageState extends State<CreateNotificationPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final notificationBloc = Provider.of<AppBloc>(context).notificationBloc;
    return Scaffold(
       backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Create Water Remainder',
           style:  TextStyle(color: Color(0xFF03A9F4), fontSize: 25, ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset(
                            'assets/create_notification.png',
                            width: 300,
                            height: 300,
                          ),
                        ),
                      ),
                    ),
                    CustomInputField(
                      controller: _titleController,
                      hintText: 'Write Notification',
                      inputType: TextInputType.text,
                      autoFocus: true,
                    ),
                    SizedBox(height: 12),
                   /* CustomInputField(
                      controller: _descriptionController,
                      hintText: 'Description',
                      inputType: TextInputType.text,
                      autoFocus: true,
                    ),*/
                    SizedBox(height: 12),
                    RaisedButton(
                       color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      onPressed: selectTime,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.access_time),
                          SizedBox(width: 4),
                          Text(selectedTime.format(context)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CustomWideFlatButton(
            onPressed: () => createNotification(notificationBloc),
            backgroundColor: Colors.blue.shade300,
            foregroundColor: Colors.blue.shade900,
            isRoundedAtBottom: false,
          ),
        ],
      ),
    );
  }

  Future<void> selectTime() async {
    
    final time = await showTimePicker(
      context: context,
       
      initialTime: selectedTime,
    );
    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  void createNotification(NotificationBloc notificationBloc) {
    if (_formKey.currentState.validate()) {
      final title = _titleController.text;
      final description = _descriptionController.text;

      final notificationData = NotificationData(title, description, selectedTime.hour, selectedTime.minute);
      notificationBloc.addNotification(notificationData);
      Navigator.of(context).pop();
    }
  }
}
