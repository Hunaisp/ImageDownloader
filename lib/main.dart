import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image_gallery_saver/image_gallery_saver.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Downloader Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ImageDownloaderExample(),
    );
  }
}

class ImageDownloaderExample extends StatefulWidget {
  const ImageDownloaderExample({Key? key}) : super(key: key);

  @override
  _ImageDownloaderExampleState createState() => _ImageDownloaderExampleState();
}

class _ImageDownloaderExampleState extends State<ImageDownloaderExample> {
  bool downloading = false;

  Future<void> _downloadAndSaveImage() async {
    setState(() {
      downloading = true;
    });

    const imageUrl = "https://image.lexica.art/full_jpg/e7793544-7a44-4430-a126-11c986d43d4b";

    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        // Get the app's documents directory to save the image
        final appDir = await getApplicationDocumentsDirectory();
        final file = File("${appDir.path}/image.jpg");

        // Write the image data to the file
        await file.writeAsBytes(response.bodyBytes);

        // Save the image to the gallery
        await ImageGallerySaver.saveFile(file.path);

        // Optional: Display a message or perform additional actions after downloading and saving
        print("Image downloaded and saved successfully to the gallery!");
      } else {
        print("Failed to download image. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error downloading and saving image: $error");
    }

    setState(() {
      downloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Downloader Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (downloading)
              const CircularProgressIndicator()
            else
              MaterialButton(
                onPressed: _downloadAndSaveImage,
                child: const Text(
                  "Download and Save Image",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
              )
          ],
        ),
      ),
    );
  }
}
