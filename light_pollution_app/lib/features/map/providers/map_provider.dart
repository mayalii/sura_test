import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/map_constants.dart';

class MapState {
  const MapState({
    this.showOverlay = true,
    this.overlayOpacity = MapConstants.defaultOverlayOpacity,
    this.selectedYear = MapConstants.defaultYear,
  });

  final bool showOverlay;
  final double overlayOpacity;
  final int selectedYear;

  MapState copyWith({
    bool? showOverlay,
    double? overlayOpacity,
    int? selectedYear,
  }) {
    return MapState(
      showOverlay: showOverlay ?? this.showOverlay,
      overlayOpacity: overlayOpacity ?? this.overlayOpacity,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }
}

class MapNotifier extends StateNotifier<MapState> {
  MapNotifier() : super(const MapState());

  void toggleOverlay() {
    state = state.copyWith(showOverlay: !state.showOverlay);
  }

  void setOverlayOpacity(double opacity) {
    state = state.copyWith(overlayOpacity: opacity);
  }

  void setYear(int year) {
    state = state.copyWith(selectedYear: year);
  }
}

final mapProvider = StateNotifierProvider<MapNotifier, MapState>((ref) {
  return MapNotifier();
});
