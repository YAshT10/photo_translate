import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:photo_translate/camera_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PHOTO TRANSLATE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: FutureBuilder<List<CameraDescription>>(
          future: availableCameras(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(
                child: Text('Error'),
              );
            }
            final cameras = snapshot.data!.first;

            return SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CameraWidget(camera: cameras),
            );
          }),
        ),
      ),
    );
  }
}
