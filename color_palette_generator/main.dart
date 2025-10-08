import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Palette Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ColorPaletteScreen(),
    );
  }
}

class ColorPaletteScreen extends StatefulWidget {
  const ColorPaletteScreen({super.key});

  @override
  State<ColorPaletteScreen> createState() => _ColorPaletteScreenState();
}

class _ColorPaletteScreenState extends State<ColorPaletteScreen> {
  XFile? _imageFile;
  PaletteGenerator? _paletteGenerator;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
          _isLoading = true;
        });
        
        await _generatePalette();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _generatePalette() async {
    if (_imageFile == null) return;

    try {
      ImageProvider imageProvider;
      
      if (kIsWeb) {
        // For web, use NetworkImage with the XFile path
        imageProvider = NetworkImage(_imageFile!.path);
      } else {
        // For mobile, use FileImage
        imageProvider = FileImage(File(_imageFile!.path));
      }

      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        imageProvider,
        maximumColorCount: 20,
      );

      setState(() {
        _paletteGenerator = paletteGenerator;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating palette: $e')),
      );
    }
  }

  void _copyColorToClipboard(Color color) {
    final hexColor = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied $hexColor to clipboard')),
    );
  }

  Widget _buildColorCard(Color color, String label) {
    final hexColor = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
    
    return GestureDetector(
      onTap: () => _copyColorToClipboard(color),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hexColor,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (_imageFile == null) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[400]!, width: 2),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No image selected',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: kIsWeb
          ? Image.network(
              _imageFile!.path,
              height: 300,
              fit: BoxFit.cover,
            )
          : Image.file(
              File(_imageFile!.path),
              height: 300,
              fit: BoxFit.cover,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Palette Generator'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImageWidget(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Choose from Gallery'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  if (!kIsWeb) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Take Photo'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else if (_paletteGenerator != null) ...[
                const Text(
                  'Extracted Colors',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                  children: [
                    if (_paletteGenerator!.dominantColor != null)
                      _buildColorCard(
                        _paletteGenerator!.dominantColor!.color,
                        'Dominant',
                      ),
                    if (_paletteGenerator!.vibrantColor != null)
                      _buildColorCard(
                        _paletteGenerator!.vibrantColor!.color,
                        'Vibrant',
                      ),
                    if (_paletteGenerator!.lightVibrantColor != null)
                      _buildColorCard(
                        _paletteGenerator!.lightVibrantColor!.color,
                        'Light Vibrant',
                      ),
                    if (_paletteGenerator!.darkVibrantColor != null)
                      _buildColorCard(
                        _paletteGenerator!.darkVibrantColor!.color,
                        'Dark Vibrant',
                      ),
                    if (_paletteGenerator!.mutedColor != null)
                      _buildColorCard(
                        _paletteGenerator!.mutedColor!.color,
                        'Muted',
                      ),
                    if (_paletteGenerator!.lightMutedColor != null)
                      _buildColorCard(
                        _paletteGenerator!.lightMutedColor!.color,
                        'Light Muted',
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'All Colors',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _paletteGenerator!.colors.length,
                  itemBuilder: (context, index) {
                    final color = _paletteGenerator!.colors.toList()[index];
                    final hexColor = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
                    final luminance = color.computeLuminance();
                    final textColor = luminance > 0.5 ? Colors.black : Colors.white;
                    
                    return GestureDetector(
                      onTap: () => _copyColorToClipboard(color),
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              hexColor,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
