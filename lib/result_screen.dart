import 'dart:async';

import 'package:flutter/cupertino.dart';

// ignore: camel_case_types, must_be_immutable
class Result_screen extends StatelessWidget {
  final String clasificacion;
  Timer? timer;
  Result_screen({super.key, required this.clasificacion});

  @override
  Widget build(BuildContext context) {
    timer = Timer(const Duration(seconds: 5), () {
      Navigator.pop(context);
    });

    return Center(
      child: Text(clasificacion),
    );
  }

  void dispose() {
    timer?.cancel();
  }
}
