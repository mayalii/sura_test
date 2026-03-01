import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:light_pollution_app/l10n/app_localizations.dart';
import 'package:light_pollution_app/core/theme/app_fonts.dart';
import '../../../core/constants/map_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/panel_theme.dart';
import '../models/dark_sky_site.dart';
import '../providers/map_provider.dart';
import '../providers/explore_provider.dart';
import '../widgets/light_pollution_legend.dart';
import '../widgets/map_controls.dart';
import '../widgets/location_detail_panel.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final MapController _mapController = MapController();
  bool _showLegend = false;
  LatLng? _markerPosition;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  bool _sheetOpen = false;

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_onSheetChanged);
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetChanged);
    _sheetController.dispose();
    super.dispose();
  }

  void _onSheetChanged() {
    if (_sheetController.isAttached && _sheetController.size <= 0.05) {
      setState(() {
        _sheetOpen = false;
        _markerPosition = null;
      });
    }
  }

  void _onMapTap(LatLng point) {
    setState(() => _markerPosition = point);
    ref.read(exploreProvider.notifier).selectLocation(point);
    _openSheet();
  }

  void _moveToLocation(double lat, double lng) {
    final point = LatLng(lat, lng);
    setState(() => _markerPosition = point);
    _mapController.move(point, 8);
  }

  void _openSheet() {
    if (!_sheetOpen) {
      setState(() => _sheetOpen = true);
    }
    // Animate to ~45% height
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_sheetController.isAttached) {
        _sheetController.animateTo(
          0.45,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onDarkSkyPinTap(DarkSkySite site) {
    _onMapTap(site.latLng);
    final l10n = AppLocalizations.of(context)!;
    final font = AppFonts.style(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (ctx) => Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 120, left: 24, right: 24),
          child: Material(
            borderRadius: BorderRadius.circular(16),
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.navy,
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isArabic ? site.nameAr : site.name,
                          style: font(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.bortleClassInfo(
                      site.bortleClass,
                      isArabic ? site.certificationAr : site.certification,
                    ),
                    style: font(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.go('/reserve');
                      },
                      icon: const Icon(Icons.calendar_month, size: 18),
                      label: Text(l10n.reserveTrip),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _toggleSheet() {
    if (_sheetOpen && _sheetController.isAttached && _sheetController.size > 0.05) {
      // Dismiss completely
      _sheetController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _openSheet();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);
    final l10n = AppLocalizations.of(context)!;
    final font = AppFonts.style(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          l10n.explore,
          style: font(
            color: AppColors.navy,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showLegend ? Icons.info : Icons.info_outline,
              color: AppColors.navy,
            ),
            onPressed: () => setState(() => _showLegend = !_showLegend),
            tooltip: l10n.toggleLegend,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Full-screen map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: MapConstants.defaultCenter,
              initialZoom: MapConstants.defaultZoom,
              minZoom: 2,
              maxZoom: 10,
              onTap: (tapPosition, point) => _onMapTap(point),
            ),
            children: [
              TileLayer(
                urlTemplate: MapConstants.osmTileUrl,
                userAgentPackageName: 'com.sura.light_pollution_app',
              ),
              if (mapState.showOverlay)
                Opacity(
                  opacity: mapState.overlayOpacity,
                  child: TileLayer(
                    urlTemplate: MapConstants.lightPollutionTileUrl(
                        mapState.selectedYear),
                    userAgentPackageName: 'com.sura.light_pollution_app',
                    tileSize: MapConstants.tileSize.toDouble(),
                    zoomOffset: MapConstants.zoomOffset.toDouble(),
                    maxZoom: 8,
                    errorTileCallback: (tile, error, stackTrace) {},
                  ),
                ),
              // Dark sky site pins (always visible)
              MarkerLayer(
                markers: darkSkySites
                    .map(
                      (site) => Marker(
                        point: site.latLng,
                        width: 36,
                        height: 36,
                        child: GestureDetector(
                          onTap: () => _onDarkSkyPinTap(site),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.navy,
                            ),
                            child: const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              // User tap marker
              if (_markerPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _markerPosition!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_pin,
                        color: Color(0xFF6C63FF),
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Map controls (top right)
          Positioned(
            top: 8,
            right: 8,
            child: MapControls(),
          ),

          // Zoom controls (+ / -)
          Positioned(
            bottom: 100,
            left: 12,
            child: Column(
              children: [
                _ZoomButton(
                  icon: Icons.add,
                  onPressed: () {
                    final zoom = _mapController.camera.zoom + 1;
                    _mapController.move(
                      _mapController.camera.center,
                      zoom.clamp(2, 10),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _ZoomButton(
                  icon: Icons.remove,
                  onPressed: () {
                    final zoom = _mapController.camera.zoom - 1;
                    _mapController.move(
                      _mapController.camera.center,
                      zoom.clamp(2, 10),
                    );
                  },
                ),
              ],
            ),
          ),

          // Legend (bottom left)
          if (_showLegend)
            const Positioned(
              bottom: 8,
              left: 8,
              child: LightPollutionLegend(),
            ),

          // Floating button to open/close panel
          Positioned(
            right: 16,
            bottom: _sheetOpen ? 16 + (MediaQuery.of(context).size.height * 0.12) : 16,
            child: FloatingActionButton.small(
              heroTag: 'explore_panel_btn',
              backgroundColor: PanelColors.background,
              onPressed: _toggleSheet,
              child: Icon(
                _sheetOpen ? Icons.keyboard_arrow_down : Icons.explore,
                color: PanelColors.accent,
              ),
            ),
          ),

          // Draggable bottom sheet
          if (_sheetOpen)
            DraggableScrollableSheet(
              controller: _sheetController,
              initialChildSize: 0.12,
              minChildSize: 0.0,
              maxChildSize: 0.92,
              snap: true,
              snapSizes: const [0.0, 0.12, 0.45, 0.92],
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: PanelColors.background,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: LocationDetailPanel(
                    onSearchSelected: _moveToLocation,
                    scrollController: scrollController,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  const _ZoomButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shape: const CircleBorder(),
      color: AppColors.white,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.navy, size: 24),
        ),
      ),
    );
  }
}
