import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// ML-based sky quality analysis using TensorFlow Lite.
///
/// Uses a MobileNetV2-based model trained on real sky photos.
/// Returns a score from 0 (heavy light pollution) to 100 (pristine dark sky).
class MlAnalysisService {
  Interpreter? _interpreter;
  bool _isLoaded = false;

  bool _loadFailed = false;

  /// Load the TFLite model from assets.
  Future<void> loadModel() async {
    if (_isLoaded || _loadFailed) return;

    try {
      _interpreter = await Interpreter.fromAsset('sky_quality_model.tflite');
      _isLoaded = true;
    } catch (e) {
      _loadFailed = true;
      // Model unavailable (e.g. simulator) — will use fallback score
    }
  }

  /// Analyze a sky photo and return a quality score (0-100).
  /// 0 = heavy light pollution, 100 = pristine dark sky.
  /// Returns -1 if ML model is unavailable (caller should use heuristic only).
  Future<int> analyzeImage(String imagePath) async {
    if (!_isLoaded && !_loadFailed) await loadModel();
    if (!_isLoaded) return -1;

    // Read and preprocess image
    final bytes = await File(imagePath).readAsBytes();
    var image = img.decodeImage(bytes);
    if (image == null) {
      throw Exception('Could not decode image');
    }

    // Resize to 224x224 (model input size)
    image = img.copyResize(image, width: 224, height: 224);

    // Convert to float32 array with MobileNetV2 preprocessing (scale to [-1, 1])
    final input = Float32List(1 * 224 * 224 * 3);
    int idx = 0;
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = image.getPixel(x, y);
        input[idx++] = (pixel.r.toDouble() / 127.5) - 1.0;
        input[idx++] = (pixel.g.toDouble() / 127.5) - 1.0;
        input[idx++] = (pixel.b.toDouble() / 127.5) - 1.0;
      }
    }

    // Reshape to [1, 224, 224, 3]
    final inputTensor = input.reshape([1, 224, 224, 3]);

    // Run inference
    final output = List.filled(1, List.filled(1, 0.0));
    _interpreter!.run(inputTensor, output);

    // Convert output (0.0-1.0) to score (0-100)
    final rawScore = output[0][0];
    final score = (rawScore * 100).round().clamp(0, 100);

    return score;
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isLoaded = false;
  }
}
