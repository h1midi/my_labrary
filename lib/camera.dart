import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:my_library/isar_services.dart';

import 'book.dart';
import 'main.dart';

class Camera extends StatefulWidget {
  const Camera({super.key, required this.newBook, required this.service});
  final Book newBook;
  final IsarService service;
  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    if (cameras.isNotEmpty) {
      controller = CameraController(
        cameras[0],
        ResolutionPreset.medium,
      );
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              debugPrint('The user did not grant the camera permission!');
              break;
            default:
              debugPrint('Error: ${e.code}\nError Message: ${e.description}');
              break;
          }
        }
      });
    } else {
      debugPrint('No available cameras');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: CameraPreview(
            controller!,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 28.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(40)),
              onPressed: () async {
                if (controller!.value.isTakingPicture) {
                  return;
                }
                if (!controller!.value.isInitialized) {
                  return;
                }
                try {
                  await controller!.setFlashMode(FlashMode.auto);
                  XFile file = await controller!.takePicture();
                  widget.newBook.coverUrl = file.path;
                  await widget.service.saveBook(widget.newBook);
                  Navigator.pushNamed(context, '/', arguments: widget.service);
                  // controller!.dispose();
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
              child: const Text('Take Picture'),
            ),
          ),
        ),
      ]),
    );
  }
}
