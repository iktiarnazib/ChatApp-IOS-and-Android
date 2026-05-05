import 'package:flutter/material.dart';

class UpdateUsername extends StatefulWidget {
  const UpdateUsername({super.key});

  @override
  State<UpdateUsername> createState() => _UpdateUsernameState();
}

class _UpdateUsernameState extends State<UpdateUsername> {
  TextEditingController usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Username')),
      body: Column(
        children: [
          TextFormField(controller: usernameController),
          SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {},

            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('UPDATE USERNAME'),
          ),
        ],
      ),
    );
  }
}
