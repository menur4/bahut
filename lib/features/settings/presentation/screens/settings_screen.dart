import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/services/background_sync_service.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/app_themes.dart';
import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../calendar_sync/presentation/providers/calendar_sync_provider.dart';
import '../../../sync/presentation/providers/background_sync_provider.dart';

/// Écran des paramètres
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _notificationsEnabled = false;
  bool _canUseBiometrics = false;
  bool _isLoading = true;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final notificationService = ref.read(notificationServiceProvider);
    final enabled = await notificationService.areNotificationsEnabled();

    // Vérifier si la biométrie est disponible
    bool canUseBio = false;
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      canUseBio = canCheck && isSupported;
    } catch (_) {}

    // Charger la version de l'application
    final packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      _notificationsEnabled = enabled;
      _canUseBiometrics = canUseBio;
      _appVersion = 'v${packageInfo.version}';
      _isLoading = false;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final notificationService = ref.read(notificationServiceProvider);

    if (value) {
      // Demander les permissions
      await notificationService.initialize();
      final granted = await notificationService.requestPermissions();
      if (!granted) {
        // Permission refusée
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Veuillez autoriser les notifications dans les paramètres'),
            ),
          );
        }
        return;
      }
    }

    await notificationService.setNotificationsEnabled(value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  Future<void> _logout() async {
    final confirmed = await showPlatformDialog<bool>(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          PlatformDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          PlatformDialogAction(
            onPressed: () => Navigator.of(context).pop(true),
            cupertino: (_, __) => CupertinoDialogActionData(
              isDestructiveAction: true,
            ),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(authStateProvider.notifier).logout();
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(currentPaletteProvider);

    return PlatformScaffold(
      backgroundColor: palette.backgroundSecondary,
      appBar: PlatformAppBar(
        title: Text(
          'PARAMÈTRES',
          style: ChanelTypography.titleMedium.copyWith(
            letterSpacing: ChanelTypography.letterSpacingWider,
            color: palette.textPrimary,
          ),
        ),
        material: (_, __) => MaterialAppBarData(
          centerTitle: true,
          elevation: 0,
          backgroundColor: palette.backgroundPrimary,
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          border: null,
          backgroundColor: palette.backgroundPrimary,
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: palette.primary),
            )
          : ListView(
              padding: const EdgeInsets.all(ChanelTheme.spacing4),
              children: [
                // Section Apparence
                _buildSectionHeader('APPARENCE', palette),
                const SizedBox(height: ChanelTheme.spacing2),
                _buildSettingsCard([
                  // Sélecteur de palette de couleurs
                  Consumer(
                    builder: (context, ref, _) {
                      final currentTheme = ref.watch(appThemeTypeProvider);
                      return _SettingsTile(
                        icon: Icons.palette,
                        title: 'Couleurs',
                        subtitle: currentTheme.label,
                        onTap: () => _showColorThemePicker(context, ref, currentTheme),
                        palette: palette,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Prévisualisation des couleurs
                            _ThemePreviewDots(themeType: currentTheme),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.chevron_right,
                              color: palette.textMuted,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 72),
                  // Mode clair/sombre
                  Consumer(
                    builder: (context, ref, _) {
                      final themeMode = ref.watch(themeModeProvider);
                      return _SettingsTile(
                        icon: themeMode.icon,
                        title: 'Mode d\'affichage',
                        subtitle: themeMode.label,
                        onTap: () => _showThemePicker(context, ref, themeMode, palette),
                        palette: palette,
                        trailing: Icon(
                          Icons.chevron_right,
                          color: palette.textMuted,
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 72),
                  // Thème automatique jour/nuit
                  Consumer(
                    builder: (context, ref, _) {
                      final autoConfig = ref.watch(autoThemeConfigProvider);
                      return _SettingsTile(
                        icon: Icons.schedule,
                        title: 'Thème automatique',
                        subtitle: autoConfig.isEnabled
                            ? 'Clair ${autoConfig.lightStartHour}h - Sombre ${autoConfig.darkStartHour}h'
                            : 'Désactivé',
                        onTap: () => _showAutoThemeDialog(context, ref, autoConfig, palette),
                        palette: palette,
                        trailing: PlatformSwitch(
                          value: autoConfig.isEnabled,
                          onChanged: (value) {
                            ref.read(hapticServiceProvider).selectionClick();
                            ref.read(autoThemeConfigProvider.notifier).setEnabled(value);
                          },
                          material: (_, __) => MaterialSwitchData(
                            activeColor: palette.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ], palette),
                const SizedBox(height: ChanelTheme.spacing6),

                // Section Sécurité
                if (_canUseBiometrics) ...[
                  _buildSectionHeader('SÉCURITÉ', palette),
                  const SizedBox(height: ChanelTheme.spacing2),
                  _buildSettingsCard([
                    _SettingsTile(
                      icon: Icons.fingerprint,
                      title: 'Déverrouillage biométrique',
                      subtitle: 'Face ID / Touch ID',
                      palette: palette,
                      trailing: Consumer(
                        builder: (context, ref, _) {
                          final biometricEnabled = ref.watch(
                            authStateProvider.select((s) => s.biometricEnabled),
                          );
                          return PlatformSwitch(
                            value: biometricEnabled,
                            onChanged: (value) {
                              ref.read(hapticServiceProvider).selectionClick();
                              ref.read(authStateProvider.notifier).setBiometricEnabled(value);
                            },
                            material: (_, __) => MaterialSwitchData(
                              activeColor: palette.primary,
                            ),
                          );
                        },
                      ),
                    ),
                  ], palette),
                  const SizedBox(height: ChanelTheme.spacing6),
                ],

                // Section Accessibilité
                _buildSectionHeader('ACCESSIBILITÉ', palette),
                const SizedBox(height: ChanelTheme.spacing2),
                _buildSettingsCard([
                  _SettingsTile(
                    icon: Icons.vibration,
                    title: 'Retour haptique',
                    subtitle: 'Vibrations lors des interactions',
                    palette: palette,
                    trailing: Consumer(
                      builder: (context, ref, _) {
                        final hapticEnabled = ref.watch(hapticEnabledProvider);
                        return PlatformSwitch(
                          value: hapticEnabled,
                          onChanged: (value) {
                            ref.read(hapticEnabledProvider.notifier).setEnabled(value);
                            // Feedback de confirmation si on active
                            if (value) {
                              ref.read(hapticServiceProvider).mediumImpact();
                            }
                          },
                          material: (_, __) => MaterialSwitchData(
                            activeColor: palette.primary,
                          ),
                        );
                      },
                    ),
                  ),
                ], palette),
                const SizedBox(height: ChanelTheme.spacing6),

                // Section Synchronisation Globale
                _buildSyncSection(palette),

                const SizedBox(height: ChanelTheme.spacing6),

                // Section Compte
                _buildSectionHeader('COMPTE', palette),
                const SizedBox(height: ChanelTheme.spacing2),
                _buildSettingsCard([
                  _SettingsTile(
                    icon: Icons.logout,
                    title: 'Déconnexion',
                    subtitle: 'Se déconnecter de l\'application',
                    onTap: _logout,
                    palette: palette,
                    trailing: Icon(
                      Icons.chevron_right,
                      color: palette.textMuted,
                    ),
                  ),
                ], palette),

                const SizedBox(height: ChanelTheme.spacing6),

                // Version
                Center(
                  child: Text(
                    'Bahut $_appVersion',
                    style: ChanelTypography.labelSmall.copyWith(
                      color: palette.textMuted,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSyncSection(AppColorPalette palette) {
    return Consumer(
      builder: (context, ref, _) {
        final syncState = ref.watch(backgroundSyncProvider);
        final syncNotifier = ref.read(backgroundSyncProvider.notifier);
        final calendarState = ref.watch(calendarSyncStateProvider);
        final calendarNotifier = ref.read(calendarSyncStateProvider.notifier);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('SYNCHRONISATION', palette),
            const SizedBox(height: ChanelTheme.spacing2),

            // Toggle principal de sync en arrière-plan
            _buildSettingsCard([
              _SettingsTile(
                icon: Icons.sync,
                title: 'Synchronisation automatique',
                subtitle: 'Synchroniser les données en arrière-plan',
                palette: palette,
                trailing: PlatformSwitch(
                  value: syncState.isEnabled,
                  onChanged: (value) {
                    ref.read(hapticServiceProvider).selectionClick();
                    syncNotifier.setEnabled(value);
                  },
                  material: (_, __) => MaterialSwitchData(
                    activeColor: palette.primary,
                  ),
                ),
              ),
            ], palette),

            // Options si sync activée
            if (syncState.isEnabled) ...[
              const SizedBox(height: ChanelTheme.spacing3),

              // Fréquence
              _buildSettingsCard([
                _SettingsTile(
                  icon: Icons.timer,
                  title: 'Fréquence',
                  subtitle: syncState.frequency.label,
                  onTap: () => _showSyncFrequencyPicker(context, syncState.frequency, syncNotifier, palette),
                  palette: palette,
                  trailing: Icon(
                    Icons.chevron_right,
                    color: palette.textMuted,
                  ),
                ),
              ], palette),

              const SizedBox(height: ChanelTheme.spacing3),

              // Section Notes
              _buildSettingsCard([
                _SettingsTile(
                  icon: Icons.grade,
                  title: 'Synchroniser les notes',
                  subtitle: 'Vérifier les nouvelles notes',
                  palette: palette,
                  trailing: PlatformSwitch(
                    value: syncState.syncGrades,
                    onChanged: (value) => syncNotifier.setSyncGrades(value),
                    material: (_, __) => MaterialSwitchData(
                      activeColor: palette.primary,
                    ),
                  ),
                ),
                if (syncState.syncGrades) ...[
                  const Divider(height: 1, indent: 72),
                  _SettingsTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Être notifié des nouvelles notes',
                    palette: palette,
                    trailing: PlatformSwitch(
                      value: syncState.notifyNewGrades,
                      onChanged: (value) => syncNotifier.setNotifyNewGrades(value),
                      material: (_, __) => MaterialSwitchData(
                        activeColor: palette.primary,
                      ),
                    ),
                  ),
                  if (syncState.notifyNewGrades) ...[
                    const Divider(height: 1, indent: 72),
                    _SettingsTile(
                      icon: Icons.notification_add_outlined,
                      title: 'Tester les notifications',
                      subtitle: 'Envoyer une notification de test',
                      palette: palette,
                      onTap: () async {
                        final notificationService = ref.read(notificationServiceProvider);
                        await notificationService.initialize();
                        await notificationService.showNewGradesNotification(
                          count: 2,
                          gradeDetails: ['Maths: 15/20', 'Anglais: 17/20'],
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Notification de test envoyée'),
                              backgroundColor: palette.success,
                            ),
                          );
                        }
                      },
                      trailing: Icon(
                        Icons.send,
                        color: palette.textMuted,
                        size: 20,
                      ),
                    ),
                  ],
                ],
              ], palette),

              const SizedBox(height: ChanelTheme.spacing3),

              // Section Calendrier
              _buildSettingsCard([
                _SettingsTile(
                  icon: Icons.calendar_month,
                  title: 'Synchroniser le calendrier',
                  subtitle: calendarState.isLoadingCalendars
                      ? 'Chargement des calendriers...'
                      : 'Ajouter les événements au calendrier',
                  palette: palette,
                  trailing: calendarState.isLoadingCalendars
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: palette.primary,
                          ),
                        )
                      : PlatformSwitch(
                          value: calendarState.isEnabled,
                          onChanged: (value) {
                            calendarNotifier.toggleSync(value);
                            syncNotifier.setSyncCalendar(value);
                          },
                          material: (_, __) => MaterialSwitchData(
                            activeColor: palette.primary,
                          ),
                        ),
                ),
              ], palette),

              // Options calendrier si activé
              if (calendarState.isEnabled) ...[
                const SizedBox(height: ChanelTheme.spacing3),
                _buildSettingsCard([
                  // Devoirs
                  _SettingsTile(
                    icon: Icons.assignment,
                    title: 'Devoirs',
                    subtitle: 'Synchroniser les devoirs à faire',
                    palette: palette,
                    trailing: PlatformSwitch(
                      value: calendarState.syncHomework,
                      onChanged: (value) => calendarNotifier.toggleHomework(value),
                      material: (_, __) => MaterialSwitchData(
                        activeColor: palette.primary,
                      ),
                    ),
                  ),
                  const Divider(height: 1, indent: 72),
                  // Contrôles
                  _SettingsTile(
                    icon: Icons.quiz,
                    title: 'Contrôles',
                    subtitle: 'Synchroniser les évaluations',
                    palette: palette,
                    trailing: PlatformSwitch(
                      value: calendarState.syncTests,
                      onChanged: (value) => calendarNotifier.toggleTests(value),
                      material: (_, __) => MaterialSwitchData(
                        activeColor: palette.primary,
                      ),
                    ),
                  ),
                  const Divider(height: 1, indent: 72),
                  // Emploi du temps
                  _SettingsTile(
                    icon: Icons.schedule,
                    title: 'Emploi du temps',
                    subtitle: 'Synchroniser les cours',
                    palette: palette,
                    trailing: PlatformSwitch(
                      value: calendarState.syncSchedule,
                      onChanged: (value) => calendarNotifier.toggleSchedule(value),
                      material: (_, __) => MaterialSwitchData(
                        activeColor: palette.primary,
                      ),
                    ),
                  ),
                ], palette),

                // Sélection du calendrier
                const SizedBox(height: ChanelTheme.spacing3),
                _buildSettingsCard([
                  _SettingsTile(
                    icon: Icons.event_note,
                    title: 'Calendrier cible',
                    subtitle: calendarState.availableCalendars.isEmpty
                        ? 'Aucun calendrier trouvé'
                        : calendarState.selectedCalendarName ?? 'Sélectionner',
                    onTap: calendarState.availableCalendars.isEmpty
                        ? () => calendarNotifier.refreshCalendars()
                        : () => _showCalendarPicker(
                            context,
                            calendarState.availableCalendars,
                            calendarState.selectedCalendarId,
                            calendarNotifier,
                            palette,
                          ),
                    palette: palette,
                    trailing: calendarState.availableCalendars.isEmpty
                        ? Icon(
                            Icons.refresh,
                            color: palette.textMuted,
                          )
                        : Icon(
                            Icons.chevron_right,
                            color: palette.textMuted,
                          ),
                  ),
                ], palette),
              ],

              // Bouton sync manuelle et status
              const SizedBox(height: ChanelTheme.spacing3),
              _buildSettingsCard([
                _SettingsTile(
                  icon: syncState.isSyncing ? Icons.sync : Icons.sync,
                  title: 'Synchroniser maintenant',
                  subtitle: syncState.isSyncing
                      ? 'Synchronisation en cours...'
                      : 'Dernière sync: ${syncNotifier.lastSyncFormatted}',
                  onTap: syncState.isSyncing ? null : () => syncNotifier.syncNow(),
                  palette: palette,
                  trailing: syncState.isSyncing
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: palette.primary,
                          ),
                        )
                      : Icon(
                          Icons.chevron_right,
                          color: palette.textMuted,
                        ),
                ),
              ], palette),

              // Message d'erreur
              if (syncState.errorMessage != null || calendarState.errorMessage != null) ...[
                const SizedBox(height: ChanelTheme.spacing2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: ChanelTheme.spacing2),
                  child: Text(
                    syncState.errorMessage ?? calendarState.errorMessage ?? '',
                    style: ChanelTypography.bodySmall.copyWith(
                      color: palette.error,
                    ),
                  ),
                ),
              ],
            ],
          ],
        );
      },
    );
  }

  void _showSyncFrequencyPicker(
    BuildContext context,
    SyncFrequency currentFrequency,
    BackgroundSyncNotifier notifier,
    AppColorPalette palette,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: palette.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ChanelTheme.radiusLg)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(ChanelTheme.spacing4),
              child: Text(
                'Fréquence de synchronisation',
                style: ChanelTypography.titleMedium.copyWith(
                  color: palette.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1),
            ...SyncFrequency.values.map((frequency) => ListTile(
              leading: Icon(
                frequency == currentFrequency
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: frequency == currentFrequency
                    ? palette.primary
                    : palette.textMuted,
              ),
              title: Text(
                frequency.label,
                style: TextStyle(color: palette.textPrimary),
              ),
              onTap: () {
                notifier.setFrequency(frequency);
                Navigator.pop(context);
              },
            )),
            const SizedBox(height: ChanelTheme.spacing4),
          ],
        ),
      ),
    );
  }

  void _showColorThemePicker(
    BuildContext context,
    WidgetRef ref,
    AppThemeType currentTheme,
  ) {
    final currentPalette = ref.read(currentPaletteProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: currentPalette.backgroundCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ChanelTheme.radiusLg)),
      ),
      builder: (context) => SafeArea(
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: currentPalette.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(ChanelTheme.spacing4),
                child: Text(
                  'Choisir un thème',
                  style: ChanelTypography.titleMedium.copyWith(
                    color: currentPalette.textPrimary,
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: AppThemeType.values.length,
                  itemBuilder: (context, index) {
                    final theme = AppThemeType.values[index];
                    final themePalette = AppThemes.getPalette(theme);
                    final isSelected = theme == currentTheme;

                    return InkWell(
                      onTap: () {
                        ref.read(appThemeTypeProvider.notifier).setThemeType(theme);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ChanelTheme.spacing4,
                          vertical: ChanelTheme.spacing3,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? themePalette.primary.withValues(alpha: 0.1)
                              : null,
                          border: Border(
                            left: BorderSide(
                              color: isSelected ? themePalette.primary : Colors.transparent,
                              width: 4,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Prévisualisation des couleurs
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: themePalette.borderLight,
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(11),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(color: themePalette.primary),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(color: themePalette.secondary),
                                          ),
                                          Expanded(
                                            child: Container(color: themePalette.accent),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: ChanelTheme.spacing3),
                            // Infos du thème
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        theme.icon,
                                        size: 18,
                                        color: isSelected
                                            ? themePalette.primary
                                            : currentPalette.textSecondary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        theme.label,
                                        style: ChanelTypography.titleSmall.copyWith(
                                          color: isSelected
                                              ? themePalette.primary
                                              : currentPalette.textPrimary,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    theme.description,
                                    style: ChanelTypography.bodySmall.copyWith(
                                      color: currentPalette.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Checkmark
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: themePalette.primary,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref, ThemeMode currentMode, AppColorPalette palette) {
    showModalBottomSheet(
      context: context,
      backgroundColor: palette.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ChanelTheme.radiusLg)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(ChanelTheme.spacing4),
              child: Text(
                'Mode d\'affichage',
                style: ChanelTypography.titleMedium.copyWith(
                  color: palette.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1),
            ...ThemeMode.values.map((mode) => ListTile(
              leading: Icon(
                mode == currentMode
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: mode == currentMode
                    ? palette.primary
                    : palette.textMuted,
              ),
              title: Text(
                mode.label,
                style: TextStyle(color: palette.textPrimary),
              ),
              trailing: Icon(mode.icon, color: palette.textSecondary),
              onTap: () {
                ref.read(themeModeProvider.notifier).setThemeMode(mode);
                Navigator.pop(context);
              },
            )),
            const SizedBox(height: ChanelTheme.spacing4),
          ],
        ),
      ),
    );
  }

  void _showCalendarPicker(
    BuildContext context,
    List<Calendar> calendars,
    String? selectedId,
    CalendarSyncNotifier notifier,
    AppColorPalette palette,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: palette.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ChanelTheme.radiusLg)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(ChanelTheme.spacing4),
              child: Text(
                'Choisir un calendrier',
                style: ChanelTypography.titleMedium.copyWith(
                  color: palette.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1),
            ...calendars.map((calendar) => ListTile(
              leading: Icon(
                calendar.id == selectedId
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: calendar.id == selectedId
                    ? palette.primary
                    : palette.textMuted,
              ),
              title: Text(
                calendar.name ?? 'Calendrier',
                style: TextStyle(color: palette.textPrimary),
              ),
              onTap: () {
                notifier.selectCalendar(calendar.id!, calendar.name);
                Navigator.pop(context);
              },
            )),
            const SizedBox(height: ChanelTheme.spacing4),
          ],
        ),
      ),
    );
  }

  void _showAutoThemeDialog(
    BuildContext context,
    WidgetRef ref,
    AutoThemeConfig config,
    AppColorPalette palette,
  ) {
    int lightHour = config.lightStartHour;
    int darkHour = config.darkStartHour;

    showModalBottomSheet(
      context: context,
      backgroundColor: palette.backgroundCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ChanelTheme.radiusLg)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(ChanelTheme.spacing4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: palette.borderLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: ChanelTheme.spacing4),
                Text(
                  'Thème automatique',
                  style: ChanelTypography.titleMedium.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: ChanelTheme.spacing2),
                Text(
                  'Le thème changera automatiquement selon l\'heure de la journée.',
                  style: ChanelTypography.bodySmall.copyWith(
                    color: palette.textTertiary,
                  ),
                ),
                const SizedBox(height: ChanelTheme.spacing6),

                // Thème clair
                Row(
                  children: [
                    Icon(Icons.light_mode, color: palette.warning, size: 24),
                    const SizedBox(width: ChanelTheme.spacing3),
                    Expanded(
                      child: Text(
                        'Thème clair à partir de',
                        style: ChanelTypography.bodyMedium.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ChanelTheme.spacing3,
                        vertical: ChanelTheme.spacing2,
                      ),
                      decoration: BoxDecoration(
                        color: palette.backgroundTertiary,
                        borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                      ),
                      child: DropdownButton<int>(
                        value: lightHour,
                        underline: const SizedBox(),
                        isDense: true,
                        dropdownColor: palette.backgroundCard,
                        style: ChanelTypography.bodyMedium.copyWith(
                          color: palette.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        items: List.generate(24, (i) => i).map((hour) {
                          return DropdownMenuItem(
                            value: hour,
                            child: Text('${hour.toString().padLeft(2, '0')}h'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() => lightHour = value);
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: ChanelTheme.spacing4),

                // Thème sombre
                Row(
                  children: [
                    Icon(Icons.dark_mode, color: palette.primary, size: 24),
                    const SizedBox(width: ChanelTheme.spacing3),
                    Expanded(
                      child: Text(
                        'Thème sombre à partir de',
                        style: ChanelTypography.bodyMedium.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ChanelTheme.spacing3,
                        vertical: ChanelTheme.spacing2,
                      ),
                      decoration: BoxDecoration(
                        color: palette.backgroundTertiary,
                        borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                      ),
                      child: DropdownButton<int>(
                        value: darkHour,
                        underline: const SizedBox(),
                        isDense: true,
                        dropdownColor: palette.backgroundCard,
                        style: ChanelTypography.bodyMedium.copyWith(
                          color: palette.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        items: List.generate(24, (i) => i).map((hour) {
                          return DropdownMenuItem(
                            value: hour,
                            child: Text('${hour.toString().padLeft(2, '0')}h'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() => darkHour = value);
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: ChanelTheme.spacing6),

                // Prévisualisation
                Container(
                  padding: const EdgeInsets.all(ChanelTheme.spacing3),
                  decoration: BoxDecoration(
                    color: palette.backgroundTertiary,
                    borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wb_sunny, color: palette.warning, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${lightHour.toString().padLeft(2, '0')}h',
                        style: ChanelTypography.labelSmall.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: ChanelTheme.spacing2),
                        child: Icon(Icons.arrow_forward, color: palette.textMuted, size: 14),
                      ),
                      Icon(Icons.nightlight_round, color: palette.primary, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${darkHour.toString().padLeft(2, '0')}h',
                        style: ChanelTypography.labelSmall.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: ChanelTheme.spacing6),

                // Boutons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Annuler',
                          style: TextStyle(color: palette.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(width: ChanelTheme.spacing3),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final notifier = ref.read(autoThemeConfigProvider.notifier);
                          notifier.setLightStartHour(lightHour);
                          notifier.setDarkStartHour(darkHour);
                          if (!config.isEnabled) {
                            notifier.setEnabled(true);
                          }
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: palette.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Appliquer'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, AppColorPalette palette) {
    return Padding(
      padding: const EdgeInsets.only(left: ChanelTheme.spacing2),
      child: Text(
        title,
        style: ChanelTypography.labelSmall.copyWith(
          color: palette.textMuted,
          letterSpacing: ChanelTypography.letterSpacingWider,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children, AppColorPalette palette) {
    return Container(
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
        border: Border.all(color: palette.borderLight),
      ),
      child: Column(children: children),
    );
  }
}

/// Widget de prévisualisation des couleurs du thème (3 points)
class _ThemePreviewDots extends StatelessWidget {
  final AppThemeType themeType;

  const _ThemePreviewDots({required this.themeType});

  @override
  Widget build(BuildContext context) {
    final palette = AppThemes.getPalette(themeType);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(palette.primary),
        const SizedBox(width: 4),
        _buildDot(palette.secondary),
        const SizedBox(width: 4),
        _buildDot(palette.accent),
      ],
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final AppColorPalette? palette;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette ?? AppThemes.classique;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
      child: Padding(
        padding: const EdgeInsets.all(ChanelTheme.spacing4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: p.backgroundTertiary,
                borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
              ),
              child: Icon(
                icon,
                color: p.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: ChanelTheme.spacing3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: ChanelTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: p.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: ChanelTypography.bodySmall.copyWith(
                      color: p.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
