import 'package:flutter/material.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool _notifications  = true;
  bool _soundEffects   = true;
  bool _dailyReminder  = false;
  bool _parentalLock   = true;
  String _plan         = 'Free';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Profile card ─────────────────────────────────────────
          _ProfileCard(plan: _plan),
          const SizedBox(height: 24),

          // ── Subscription / Payment ────────────────────────────────
          _sectionLabel('Subscription & Payment'),
          const SizedBox(height: 12),
          _PlanCard(
            currentPlan: _plan,
            onUpgrade: () => _showUpgradeSheet(context),
          ),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.receipt_long_rounded,
            color: const Color(0xFF7C83FD),
            title: 'Billing History',
            subtitle: 'View past invoices & receipts',
            onTap: () => _showComingSoon(context, 'Billing History'),
          ),
          _SettingsTile(
            icon: Icons.credit_card_rounded,
            color: const Color(0xFF4ECDC4),
            title: 'Payment Method',
            subtitle: 'Manage cards & payment options',
            onTap: () => _showComingSoon(context, 'Payment Method'),
          ),
          const SizedBox(height: 24),

          // ── Child settings ────────────────────────────────────────
          _sectionLabel('Child Settings'),
          const SizedBox(height: 12),
          _ToggleTile(
            icon: Icons.lock_rounded,
            color: const Color(0xFFFF6B6B),
            title: 'Parental Lock',
            subtitle: 'Require PIN to open parent panel',
            value: _parentalLock,
            onChanged: (v) => setState(() => _parentalLock = v),
          ),
          _SettingsTile(
            icon: Icons.timer_rounded,
            color: const Color(0xFFFF8C42),
            title: 'Screen Time Limit',
            subtitle: 'Set daily usage limits per activity',
            onTap: () => _showTimeLimitSheet(context),
          ),
          _SettingsTile(
            icon: Icons.child_care_rounded,
            color: const Color(0xFF06D6A0),
            title: 'Child Profile',
            subtitle: 'Edit name, age & avatar',
            onTap: () => _showComingSoon(context, 'Child Profile'),
          ),
          const SizedBox(height: 24),

          // ── App preferences ───────────────────────────────────────
          _sectionLabel('App Preferences'),
          const SizedBox(height: 12),
          _ToggleTile(
            icon: Icons.notifications_rounded,
            color: const Color(0xFF7C83FD),
            title: 'Push Notifications',
            subtitle: 'Activity reminders & achievements',
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
          ),
          _ToggleTile(
            icon: Icons.volume_up_rounded,
            color: const Color(0xFF4ECDC4),
            title: 'Sound Effects',
            subtitle: 'Play sounds during activities',
            value: _soundEffects,
            onChanged: (v) => setState(() => _soundEffects = v),
          ),
          _ToggleTile(
            icon: Icons.alarm_rounded,
            color: const Color(0xFFFF8C42),
            title: 'Daily Learning Reminder',
            subtitle: 'Remind child to play at set time',
            value: _dailyReminder,
            onChanged: (v) => setState(() => _dailyReminder = v),
          ),
          _SettingsTile(
            icon: Icons.language_rounded,
            color: const Color(0xFFFF6B9D),
            title: 'Language',
            subtitle: 'English (US)',
            onTap: () => _showComingSoon(context, 'Language'),
          ),
          const SizedBox(height: 24),

          // ── Support ───────────────────────────────────────────────
          _sectionLabel('Support & Legal'),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.help_outline_rounded,
            color: const Color(0xFF7C83FD),
            title: 'Help & FAQ',
            subtitle: 'Get answers to common questions',
            onTap: () => _showComingSoon(context, 'Help & FAQ'),
          ),
          _SettingsTile(
            icon: Icons.star_outline_rounded,
            color: const Color(0xFFFF8C42),
            title: 'Rate KidSteps',
            subtitle: 'Love the app? Leave a review!',
            onTap: () => _showComingSoon(context, 'Rate KidSteps'),
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            color: const Color(0xFF4ECDC4),
            title: 'Privacy Policy',
            subtitle: 'How we handle your data',
            onTap: () => _showComingSoon(context, 'Privacy Policy'),
          ),
          _SettingsTile(
            icon: Icons.description_outlined,
            color: Colors.grey,
            title: 'Terms of Service',
            subtitle: 'Read our terms & conditions',
            onTap: () => _showComingSoon(context, 'Terms of Service'),
          ),
          const SizedBox(height: 24),

          // ── Danger zone ───────────────────────────────────────────
          _SettingsTile(
            icon: Icons.logout_rounded,
            color: const Color(0xFFFF6B6B),
            title: 'Sign Out',
            subtitle: 'Log out of your account',
            onTap: () => _showComingSoon(context, 'Sign Out'),
            showArrow: false,
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'KidSteps v1.0.0',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: Color(0xFF2D3142),
          letterSpacing: 0.4,
        ),
      );

  void _showComingSoon(BuildContext ctx, String feature) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text('$feature — coming soon!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 90),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showUpgradeSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _UpgradeSheet(
        currentPlan: _plan,
        onSelect: (p) {
          setState(() => _plan = p);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showTimeLimitSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _TimeLimitSheet(),
    );
  }
}

// ── Profile card ──────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.plan});
  final String plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8C42)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B6B).withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: const Center(child: Text('👨‍👩‍👦', style: TextStyle(fontSize: 26))),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Smith Family',
                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
                SizedBox(height: 3),
                Text('parent@example.com',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              plan == 'Free' ? '🆓 Free' : '⭐ $plan',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Plan card ─────────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.currentPlan, required this.onUpgrade});
  final String currentPlan;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final isFree = currentPlan == 'Free';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isFree ? Colors.grey.shade200 : const Color(0xFFFFD600),
          width: isFree ? 1 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('💎', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isFree ? 'Upgrade to Premium' : 'Premium Plan Active ✅',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF2D3142)),
                ),
                const SizedBox(height: 3),
                Text(
                  isFree
                      ? 'Unlock all activities, no ads, full reports'
                      : 'All features unlocked — enjoy KidSteps!',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          if (isFree) ...[
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: onUpgrade,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8C42),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              ),
              child: const Text('Upgrade'),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Generic tiles ─────────────────────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showArrow = true,
  });

  final IconData icon;
  final Color color;
  final String title, subtitle;
  final VoidCallback onTap;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF2D3142))),
                      const SizedBox(height: 2),
                      Text(subtitle,
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
                if (showArrow)
                  Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color color;
  final String title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF2D3142))),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeThumbColor: Colors.white,
              activeTrackColor: color,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Upgrade bottom sheet ──────────────────────────────────────────────────────

class _UpgradeSheet extends StatelessWidget {
  const _UpgradeSheet({required this.currentPlan, required this.onSelect});
  final String currentPlan;
  final ValueChanged<String> onSelect;

  static const _plans = [
    _Plan(
      name: 'Free',
      price: '\$0',
      period: 'forever',
      color: Color(0xFF9E9E9E),
      features: ['2 activities', 'Basic reports', 'Ads included'],
      emoji: '🆓',
    ),
    _Plan(
      name: 'Monthly',
      price: '\$4.99',
      period: '/ month',
      color: Color(0xFF7C83FD),
      features: ['All 4 activities', 'Full analytics', 'No ads', 'Priority support'],
      emoji: '🌟',
    ),
    _Plan(
      name: 'Yearly',
      price: '\$29.99',
      period: '/ year  · Save 50%',
      color: Color(0xFFFF8C42),
      features: ['Everything in Monthly', 'Offline mode', 'Multi-child profiles', 'Early access features'],
      emoji: '💎',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(height: 18),
          const Text('Choose Your Plan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF2D3142))),
          const SizedBox(height: 4),
          Text('Unlock the full KidSteps experience',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          const SizedBox(height: 20),
          ..._plans.map((p) => _PlanTile(
                plan: p,
                selected: currentPlan == p.name,
                onTap: () => onSelect(p.name),
              )),
          const SizedBox(height: 8),
          Text('Cancel anytime · Secure payment via Stripe',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({required this.plan, required this.selected, required this.onTap});
  final _Plan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? plan.color.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? plan.color : Colors.grey.shade200,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(plan.emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(plan.name,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: selected ? plan.color : const Color(0xFF2D3142))),
                      const SizedBox(width: 8),
                      Text(plan.price,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: plan.color)),
                      const SizedBox(width: 4),
                      Text(plan.period,
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: plan.features.map((f) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded, size: 12, color: plan.color),
                        const SizedBox(width: 3),
                        Text(f, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      ],
                    )).toList(),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle_rounded, color: plan.color),
          ],
        ),
      ),
    );
  }
}

class _Plan {
  const _Plan({
    required this.name,
    required this.price,
    required this.period,
    required this.color,
    required this.features,
    required this.emoji,
  });

  final String name, price, period, emoji;
  final Color color;
  final List<String> features;
}

// ── Time limit bottom sheet ───────────────────────────────────────────────────

class _TimeLimitSheet extends StatefulWidget {
  const _TimeLimitSheet();

  @override
  State<_TimeLimitSheet> createState() => _TimeLimitSheetState();
}

class _TimeLimitSheetState extends State<_TimeLimitSheet> {
  final _limits = {
    'Numbers': 30.0,
    'Reading': 20.0,
    'Puzzles': 15.0,
    'Drawing': 25.0,
  };
  final _colors = {
    'Numbers': const Color(0xFFFF8C42),
    'Reading': const Color(0xFFFF6B6B),
    'Puzzles': const Color(0xFF7C83FD),
    'Drawing': const Color(0xFF06D6A0),
  };
  final _emojis = {'Numbers': '🔢', 'Reading': '📖', 'Puzzles': '🧩', 'Drawing': '🎨'};

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(height: 18),
          const Text('Screen Time Limits',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF2D3142))),
          const SizedBox(height: 4),
          Text('Set daily max minutes per activity',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          const SizedBox(height: 20),
          ..._limits.keys.map((name) {
            final color  = _colors[name]!;
            final emoji  = _emojis[name]!;
            final value  = _limits[name]!;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(name,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2D3142))),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('${value.round()} min',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700, color: color)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: color,
                      thumbColor: color,
                      inactiveTrackColor: color.withValues(alpha: 0.18),
                      overlayColor: color.withValues(alpha: 0.12),
                      trackHeight: 5,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                    ),
                    child: Slider(
                      value: value,
                      min: 5,
                      max: 60,
                      divisions: 11,
                      onChanged: (v) => setState(() => _limits[name] = v),
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C83FD),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Save Limits', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
