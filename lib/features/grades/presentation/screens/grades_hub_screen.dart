import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_themes.dart';
import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../averages/presentation/screens/averages_screen.dart';
import '../../../simulation/presentation/screens/simulation_screen.dart';
import '../../../statistics/presentation/screens/statistics_screen.dart';
import '../providers/grades_provider.dart';
import '../widgets/grades_list_content.dart';
import '../widgets/period_selector.dart';

/// Écran principal regroupant Notes, Moyennes, Stats et Simulateur
class GradesHubScreen extends ConsumerStatefulWidget {
  const GradesHubScreen({super.key});

  @override
  ConsumerState<GradesHubScreen> createState() => _GradesHubScreenState();
}

class _GradesHubScreenState extends ConsumerState<GradesHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Uint8List? _photoBytes;
  bool _photoLoading = false;
  String? _lastPhotoUrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gradesStateProvider.notifier).fetchGrades();
      _loadPhoto();

      ref.listenManual(
        authStateProvider.select((s) => s.selectedChild?.id),
        (previous, next) {
          if (next != null && next != previous) {
            _photoBytes = null;
            _lastPhotoUrl = null;
            _loadPhoto();
          }
        },
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPhoto() async {
    final authState = ref.read(authStateProvider);
    final selectedChild = authState.selectedChild;

    if (selectedChild?.photo == null || selectedChild!.photo!.isEmpty) {
      return;
    }

    var photoUrl = selectedChild.photo!;
    if (photoUrl.startsWith('//')) {
      photoUrl = 'https:$photoUrl';
    }

    if (photoUrl == _lastPhotoUrl && _photoBytes != null) {
      return;
    }

    setState(() {
      _photoLoading = true;
      _lastPhotoUrl = photoUrl;
    });

    try {
      final dio = Dio();
      final response = await dio.get<List<int>>(
        photoUrl,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'User-Agent': ApiConstants.userAgent,
            'Referer': 'https://www.ecoledirecte.com/',
            'Accept': 'image/*',
            'Origin': 'https://www.ecoledirecte.com',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          _photoBytes = Uint8List.fromList(response.data!);
          _photoLoading = false;
        });
      } else {
        setState(() => _photoLoading = false);
      }
    } catch (e) {
      setState(() => _photoLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(currentPaletteProvider);
    final gradesState = ref.watch(gradesStateProvider);
    final authState = ref.watch(authStateProvider);
    final selectedChild = authState.selectedChild;
    final isIOS = Platform.isIOS;

    ImageProvider? childPhoto;
    if (_photoBytes != null) {
      childPhoto = MemoryImage(_photoBytes!);
    }

    return PlatformScaffold(
      backgroundColor: palette.backgroundSecondary,
      appBar: PlatformAppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _photoLoading
              ? CircleAvatar(
                  backgroundColor: palette.backgroundTertiary,
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: palette.textMuted,
                    ),
                  ),
                )
              : childPhoto != null
                  ? ClipOval(
                      child: Image(
                        image: childPhoto,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: palette.backgroundTertiary,
                      child: Text(
                        selectedChild?.prenom.isNotEmpty == true
                            ? selectedChild!.prenom[0].toUpperCase()
                            : '?',
                        style: ChanelTypography.titleMedium.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ),
        ),
        title: Text(
          selectedChild?.prenom.toUpperCase() ?? 'MES NOTES',
          style: ChanelTypography.titleMedium.copyWith(
            letterSpacing: ChanelTypography.letterSpacingWider,
            color: palette.textPrimary,
          ),
        ),
        material: (_, __) => MaterialAppBarData(
          centerTitle: true,
          elevation: 0,
          backgroundColor: palette.backgroundPrimary,
          bottom: TabBar(
            controller: _tabController,
            labelColor: palette.primary,
            unselectedLabelColor: palette.textMuted,
            indicatorColor: palette.primary,
            indicatorWeight: 3,
            labelStyle: ChanelTypography.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: ChanelTypography.labelMedium,
            tabs: const [
              Tab(text: 'Notes'),
              Tab(text: 'Moyennes'),
              Tab(text: 'Stats'),
              Tab(text: 'Simulateur'),
            ],
          ),
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          border: null,
          backgroundColor: palette.backgroundPrimary,
        ),
      ),
      body: Column(
        children: [
          // Segmented control pour iOS (dans le body car CupertinoNavigationBar ne supporte pas bottom)
          if (isIOS)
            Container(
              color: palette.backgroundPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: ChanelTheme.spacing4,
                vertical: ChanelTheme.spacing2,
              ),
              child: _CupertinoTabBar(
                controller: _tabController,
                palette: palette,
              ),
            ),

          // Sélecteur de période (uniquement sur l'onglet Notes)
          AnimatedBuilder(
            animation: _tabController,
            builder: (context, child) {
              if (_tabController.index != 0 || gradesState.periods.isEmpty) {
                return const SizedBox.shrink();
              }
              return Container(
                color: palette.backgroundPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: ChanelTheme.spacing4,
                  vertical: ChanelTheme.spacing2,
                ),
                child: PeriodSelector(
                  periods: gradesState.periods,
                  selectedPeriod: gradesState.selectedPeriod,
                  onPeriodChanged: (period) {
                    ref.read(gradesStateProvider.notifier).selectPeriod(period);
                  },
                  palette: palette,
                ),
              );
            },
          ),

          // Contenu des tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Liste des notes
                GradesListContent(palette: palette),

                // Tab 2: Moyennes (extrait de AveragesScreen)
                const _AveragesTab(),

                // Tab 3: Statistiques (extrait de StatisticsScreen)
                const _StatisticsTab(),

                // Tab 4: Simulateur
                const _SimulatorTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tab bar style Cupertino
class _CupertinoTabBar extends StatelessWidget {
  final TabController controller;
  final AppColorPalette palette;

  const _CupertinoTabBar({
    required this.controller,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return CupertinoSlidingSegmentedControl<int>(
          groupValue: controller.index,
          backgroundColor: palette.backgroundTertiary,
          thumbColor: palette.backgroundCard,
          children: {
            0: _buildSegment('Notes', 0),
            1: _buildSegment('Moyennes', 1),
            2: _buildSegment('Stats', 2),
            3: _buildSegment('Simulateur', 3),
          },
          onValueChanged: (index) {
            if (index != null) {
              controller.animateTo(index);
            }
          },
        );
      },
    );
  }

  Widget _buildSegment(String text, int index) {
    final isSelected = controller.index == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Text(
        text,
        style: ChanelTypography.labelSmall.copyWith(
          color: isSelected ? palette.primary : palette.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}

/// Onglet Moyennes (version embarquée)
class _AveragesTab extends ConsumerWidget {
  const _AveragesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Réutilise le contenu de AveragesScreen sans son scaffold
    return const AveragesScreenContent();
  }
}

/// Onglet Statistiques (version embarquée)
class _StatisticsTab extends ConsumerWidget {
  const _StatisticsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const StatisticsScreenContent();
  }
}

/// Onglet Simulateur (version embarquée)
class _SimulatorTab extends ConsumerWidget {
  const _SimulatorTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SimulationScreenContent();
  }
}
