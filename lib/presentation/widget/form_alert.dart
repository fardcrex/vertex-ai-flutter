import 'package:flutter/material.dart';

class FormAlert extends StatefulWidget {
  static Future<String?> show(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return const FormAlert();
      },
    );
  }

  const FormAlert({super.key});

  @override
  State<FormAlert> createState() => _FormAlertState();
}

class _FormAlertState extends State<FormAlert> {
  String promptDescription = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ingrese una descripción'),
      content: Column(
        children: <Widget>[
          TextField(
            decoration: const InputDecoration(
              hintText: 'Agrega la descripción del proyecto',
              border: OutlineInputBorder(),
            ),
            maxLines: 7,
            onChanged: (value) => promptDescription = value,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(promptDescription);
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
