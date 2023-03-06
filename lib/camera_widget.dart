import 'dart:io';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:photo_translate/apis/recognition_api.dart';
import 'package:photo_translate/apis/translation_api.dart';

class CameraWidget extends StatefulWidget {
  final CameraDescription camera;
  const CameraWidget({required this.camera, super.key});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController cameraController;
  late Future<void> initCameraFn;
  String? shownText;

  @override
  void initState() {
    super.initState();
    cameraController = CameraController(
      widget.camera,
      ResolutionPreset.max,
    );
    initCameraFn = cameraController.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        FutureBuilder(
          future: initCameraFn,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CameraPreview(cameraController),
            );
          }),
        ),
        Positioned(
          bottom: 50,
          child: FloatingActionButton(
            onPressed: () async {
              final image = await cameraController.takePicture();
              final recognizedText = await RecognitionApi.recognizedText(
                InputImage.fromFile(
                  File(image.path),
                ),
              );
              if (recognizedText == null) return;
              final translatedText =
                  await TranslationApi.translateTest(recognizedText);
              setState(() {
                shownText = translatedText;
              });
            },
            child: const Icon(Icons.translate),
          ),
        ),
        if (shownText != null)
          SingleChildScrollView(
            child: Container(
              color: Color.fromARGB(115, 94, 40, 40),
              margin: const EdgeInsets.fromLTRB(20, 100, 20, 20),
              child: SelectableText(
                shownText!,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
