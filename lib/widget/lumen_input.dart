import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Lumen Design System — Text Input
///
/// Dark:  12px radius, outline border that glows blue on focus
/// Light: 4px radius, 2px blue border on focus, no glow
class LumenInput extends StatefulWidget {
  const LumenInput({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helper,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.autofocus = false,
    this.enabled   = true,
    this.readOnly  = false,
    this.maxLines  = 1,
  });

  final TextEditingController? controller;
  final String?                label;
  final String?                hint;
  final String?                helper;
  final String?                errorText;
  final IconData?              prefixIcon;
  final Widget?                suffixIcon;
  final bool                   obscureText;
  final TextInputType?         keyboardType;
  final ValueChanged<String>?  onChanged;
  final ValueChanged<String>?  onSubmitted;
  final TextInputAction?       textInputAction;
  final bool                   autofocus;
  final bool                   enabled;
  final bool                   readOnly;
  final int                    maxLines;

  @override
  State<LumenInput> createState() => _LumenInputState();
}

class _LumenInputState extends State<LumenInput> {
  late final FocusNode _focus;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode()
      ..addListener(() => setState(() => _isFocused = _focus.hasFocus));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs     = Theme.of(context).colorScheme;
    final radius = isDark ? LumenRadius.inputDark : LumenRadius.inputLight;

    // Dark theme adds a soft glow on focus
    final BoxDecoration? wrapperDecoration = (isDark && _isFocused)
        ? BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color:      LumenDarkColors.primary.withValues(alpha: 0.25),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          )
        : null;

    final field = TextFormField(
      controller:      widget.controller,
      focusNode:       _focus,
      obscureText:     widget.obscureText,
      keyboardType:    widget.keyboardType,
      onChanged:       widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      textInputAction: widget.textInputAction,
      autofocus:       widget.autofocus,
      enabled:         widget.enabled,
      readOnly:        widget.readOnly,
      maxLines:        widget.obscureText ? 1 : widget.maxLines,
      style:           Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText:   widget.label,
        hintText:    widget.hint,
        helperText:  widget.helper,
        errorText:   widget.errorText,
        prefixIcon:  widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon:  widget.suffixIcon,
      ),
    );

    return wrapperDecoration != null
        ? DecoratedBox(decoration: wrapperDecoration, child: field)
        : field;
  }
}

/// Search field variant with clear button
class LumenSearchField extends StatefulWidget {
  const LumenSearchField({
    super.key,
    this.controller,
    this.hint = 'Search…',
    this.onChanged,
    this.onClear,
  });

  final TextEditingController? controller;
  final String                 hint;
  final ValueChanged<String>?  onChanged;
  final VoidCallback?          onClear;

  @override
  State<LumenSearchField> createState() => _LumenSearchFieldState();
}

class _LumenSearchFieldState extends State<LumenSearchField> {
  late final TextEditingController _ctrl;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _ctrl = widget.controller ?? TextEditingController();
    _ctrl.addListener(() => setState(() => _hasText = _ctrl.text.isNotEmpty));
  }

  @override
  void dispose() {
    if (widget.controller == null) _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LumenInput(
      controller:  _ctrl,
      hint:        widget.hint,
      prefixIcon:  Icons.search_rounded,
      keyboardType: TextInputType.text,
      onChanged:   widget.onChanged,
      suffixIcon: _hasText
          ? IconButton(
              icon:    const Icon(Icons.close_rounded),
              onPressed: () {
                _ctrl.clear();
                widget.onClear?.call();
                widget.onChanged?.call('');
              },
            )
          : null,
    );
  }
}

// ─── Offline / Sync Status Banner ─────────────────────────────────────────────

enum LumenConnectivityStatus { online, syncing, offline }

/// Persistent bottom/top status bar for offline mode indication.
/// Amber for syncing, desaturated grey for offline, transparent when online.
class LumenOfflineBanner extends StatelessWidget {
  const LumenOfflineBanner({
    super.key,
    required this.status,
  });

  final LumenConnectivityStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == LumenConnectivityStatus.online) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tt     = Theme.of(context).textTheme;

    final (bgColor, fgColor, icon, label) = switch (status) {
      LumenConnectivityStatus.syncing => (
        (isDark ? LumenDarkColors.syncingAmber : LumenLightColors.warningIndicator)
            .withValues(alpha: 0.15),
        isDark ? LumenDarkColors.syncingAmber : LumenLightColors.warningIndicator,
        Icons.cloud_sync_outlined,
        'SYNCING',
      ),
      LumenConnectivityStatus.offline => (
        (isDark ? LumenDarkColors.outline : LumenLightColors.outline)
            .withValues(alpha: 0.15),
        isDark ? LumenDarkColors.outline : LumenLightColors.outline,
        Icons.cloud_off_outlined,
        'OFFLINE MODE',
      ),
      LumenConnectivityStatus.online  => (Colors.transparent, Colors.transparent,
          Icons.cloud_done_outlined, ''),
    };

    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: LumenSpacing.containerPadding,
        vertical:   LumenSpacing.elementGap / 2,
      ),
      color: bgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: LumenSpacing.iconSizeSmall, color: fgColor),
          const SizedBox(width: LumenSpacing.elementGap / 2),
          Text(
            label,
            style: tt.labelMedium?.copyWith(color: fgColor),
          ),
          if (status == LumenConnectivityStatus.syncing) ...[
            const SizedBox(width: LumenSpacing.xs),
            SizedBox(
              width: 10, height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: fgColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
