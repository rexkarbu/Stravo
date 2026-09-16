import 'package:flutter/material.dart';
import 'package:stravo/app/theme/stravo_colors.dart';
import 'package:stravo/app/theme/stravo_typography.dart';
import 'package:stravo/core/widgets/stravo_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final List<Map<String, dynamic>> _garageBikes = const [
    {
      'name': 'Canyon Grizl CF SL 8',
      'type': 'Gravel Bike',
      'distance': '2,480 KM',
      'chainWear': 0.65, // 65% worn
      'tire': 'Maxxis Rambler 45c',
    },
    {
      'name': 'Specialized Allez Sprint',
      'type': 'Road Bike (Crit Machine)',
      'distance': '4,120 KM',
      'chainWear': 0.88, // 88% - needs replacement soon
      'tire': 'Continental GP5000 28c',
    },
    {
      'name': 'Trek Fuel EX 8',
      'type': 'Full Suspension MTB',
      'distance': '890 KM',
      'chainWear': 0.25,
      'tire': 'Bontrager XR4 2.4"',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StravoColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildProfileHeader(context)),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(child: _buildAthleteStats()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'GARASI SEPEDA & GEAR',
                      style: StravoTypography.caption.copyWith(
                        color: StravoColors.textSecondary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        '+ Tambah Sepeda',
                        style: StravoTypography.caption.copyWith(
                          color: StravoColors.orangePrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildBikeCard(_garageBikes[index]),
                  childCount: _garageBikes.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(child: _buildDataSovereigntyCard(context)),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Local Avatar (Cyber Neon Ring)
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: StravoColors.orangePrimary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: StravoColors.orangePrimary.withValues(alpha: 0.3),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 34,
              backgroundColor: StravoColors.surfaceElevated,
              child: Icon(Icons.person, size: 38, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Rayhan "Ray"', style: StravoTypography.h2),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: StravoColors.cyberGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'PRO LOCAL',
                        style: TextStyle(color: StravoColors.cyberGreen, fontSize: 9, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Gravel Grinder & Endurance Cyclist • Solo, ID',
                  style: StravoTypography.caption,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: StravoColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAthleteStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: StravoColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: StravoColors.glassBorder),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatColumn(label: 'BERAT BADAN', value: '68.5', unit: 'KG'),
          _StatDivider(),
          _StatColumn(label: 'MAX DETAK JANTUNG', value: '194', unit: 'BPM'),
          _StatDivider(),
          _StatColumn(label: 'FTP ESTIMASI', value: '265', unit: 'WATT'),
        ],
      ),
    );
  }

  Widget _buildBikeCard(Map<String, dynamic> bike) {
    final chainWear = bike['chainWear'] as double;
    final isChainCritical = chainWear >= 0.8;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: StravoColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: StravoColors.glassBorder),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(bike['name'], style: StravoTypography.bodyBold.copyWith(fontSize: 15)),
              Text(
                bike['distance'],
                style: StravoTypography.caption.copyWith(
                  color: StravoColors.orangePrimary,
                  fontWeight: FontWeight.w800,
                  fontFeatures: StravoTypography.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(bike['type'], style: StravoTypography.caption),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kesehatan Rantai & Transmisi',
                style: StravoTypography.caption.copyWith(fontSize: 11),
              ),
              Text(
                isChainCritical ? 'Perlu Ganti (${(chainWear * 100).toInt()}%)' : '${(chainWear * 100).toInt()}%',
                style: TextStyle(
                  color: isChainCritical ? StravoColors.neonPink : StravoColors.cyberGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: chainWear,
              backgroundColor: StravoColors.surfaceElevated,
              valueColor: AlwaysStoppedAnimation<Color>(
                isChainCritical ? StravoColors.neonPink : StravoColors.cyberGreen,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ban: ${bike['tire']}',
            style: StravoTypography.caption.copyWith(color: StravoColors.textDisabled, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSovereigntyCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StravoCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shield_outlined, color: StravoColors.cyberGreen, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Kedaulatan Data & Cadangan Offline',
                  style: StravoTypography.bodyBold,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Database Anda sepenuhnya tersimpan di memori lokal HP tanpa cloud tracking. Cadangkan atau pulihkan data riwayat dengan sekali sentuh.',
              style: StravoTypography.caption.copyWith(color: StravoColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.upload_file_outlined, size: 16, color: StravoColors.cyberGreen),
                    label: const Text('Backup DB', style: TextStyle(color: StravoColors.cyberGreen, fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: StravoColors.cyberGreen),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Database Stravo berhasil diekspor ke format JSON/SQLite!')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.restore_outlined, size: 16, color: StravoColors.orangePrimary),
                    label: const Text('Restore DB', style: TextStyle(color: StravoColors.orangePrimary, fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: StravoColors.orangePrimary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Membuka file picker untuk restore database...')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _StatColumn({required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: StravoTypography.caption.copyWith(fontSize: 9, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: StravoTypography.h3.copyWith(fontFeatures: StravoTypography.tabularFigures)),
            const SizedBox(width: 3),
            Text(unit, style: StravoTypography.caption.copyWith(fontSize: 10, color: StravoColors.textMuted)),
          ],
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: StravoColors.divider);
  }
}
