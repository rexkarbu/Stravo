// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ActivitiesTable extends Activities
    with TableInfo<$ActivitiesTable, Activity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gearIdMeta = const VerificationMeta('gearId');
  @override
  late final GeneratedColumn<String> gearId = GeneratedColumn<String>(
    'gear_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sportTypeMeta = const VerificationMeta(
    'sportType',
  );
  @override
  late final GeneratedColumn<String> sportType = GeneratedColumn<String>(
    'sport_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalDistanceMetersMeta =
      const VerificationMeta('totalDistanceMeters');
  @override
  late final GeneratedColumn<double> totalDistanceMeters =
      GeneratedColumn<double>(
        'total_distance_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _elapsedTimeSecondsMeta =
      const VerificationMeta('elapsedTimeSeconds');
  @override
  late final GeneratedColumn<int> elapsedTimeSeconds = GeneratedColumn<int>(
    'elapsed_time_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _movingTimeSecondsMeta = const VerificationMeta(
    'movingTimeSeconds',
  );
  @override
  late final GeneratedColumn<int> movingTimeSeconds = GeneratedColumn<int>(
    'moving_time_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _elevationGainMetersMeta =
      const VerificationMeta('elevationGainMeters');
  @override
  late final GeneratedColumn<double> elevationGainMeters =
      GeneratedColumn<double>(
        'elevation_gain_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _elevationLossMetersMeta =
      const VerificationMeta('elevationLossMeters');
  @override
  late final GeneratedColumn<double> elevationLossMeters =
      GeneratedColumn<double>(
        'elevation_loss_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _maxElevationMetersMeta =
      const VerificationMeta('maxElevationMeters');
  @override
  late final GeneratedColumn<double> maxElevationMeters =
      GeneratedColumn<double>(
        'max_elevation_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _minElevationMetersMeta =
      const VerificationMeta('minElevationMeters');
  @override
  late final GeneratedColumn<double> minElevationMeters =
      GeneratedColumn<double>(
        'min_elevation_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _avgSpeedMpsMeta = const VerificationMeta(
    'avgSpeedMps',
  );
  @override
  late final GeneratedColumn<double> avgSpeedMps = GeneratedColumn<double>(
    'avg_speed_mps',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _maxSpeedMpsMeta = const VerificationMeta(
    'maxSpeedMps',
  );
  @override
  late final GeneratedColumn<double> maxSpeedMps = GeneratedColumn<double>(
    'max_speed_mps',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _avgGapMpsMeta = const VerificationMeta(
    'avgGapMps',
  );
  @override
  late final GeneratedColumn<double> avgGapMps = GeneratedColumn<double>(
    'avg_gap_mps',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avgCadenceMeta = const VerificationMeta(
    'avgCadence',
  );
  @override
  late final GeneratedColumn<int> avgCadence = GeneratedColumn<int>(
    'avg_cadence',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avgHeartRateMeta = const VerificationMeta(
    'avgHeartRate',
  );
  @override
  late final GeneratedColumn<int> avgHeartRate = GeneratedColumn<int>(
    'avg_heart_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxHeartRateMeta = const VerificationMeta(
    'maxHeartRate',
  );
  @override
  late final GeneratedColumn<int> maxHeartRate = GeneratedColumn<int>(
    'max_heart_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estimatedEnergyKjMeta = const VerificationMeta(
    'estimatedEnergyKj',
  );
  @override
  late final GeneratedColumn<int> estimatedEnergyKj = GeneratedColumn<int>(
    'estimated_energy_kj',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gravelPercentageMeta = const VerificationMeta(
    'gravelPercentage',
  );
  @override
  late final GeneratedColumn<double> gravelPercentage = GeneratedColumn<double>(
    'gravel_percentage',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _asphaltPercentageMeta = const VerificationMeta(
    'asphaltPercentage',
  );
  @override
  late final GeneratedColumn<double> asphaltPercentage =
      GeneratedColumn<double>(
        'asphalt_percentage',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _primaryPhotoPathMeta = const VerificationMeta(
    'primaryPhotoPath',
  );
  @override
  late final GeneratedColumn<String> primaryPhotoPath = GeneratedColumn<String>(
    'primary_photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    gearId,
    title,
    description,
    sportType,
    status,
    startTime,
    endTime,
    totalDistanceMeters,
    elapsedTimeSeconds,
    movingTimeSeconds,
    elevationGainMeters,
    elevationLossMeters,
    maxElevationMeters,
    minElevationMeters,
    avgSpeedMps,
    maxSpeedMps,
    avgGapMps,
    avgCadence,
    avgHeartRate,
    maxHeartRate,
    estimatedEnergyKj,
    gravelPercentage,
    asphaltPercentage,
    primaryPhotoPath,
    isFavorite,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<Activity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('gear_id')) {
      context.handle(
        _gearIdMeta,
        gearId.isAcceptableOrUnknown(data['gear_id']!, _gearIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('sport_type')) {
      context.handle(
        _sportTypeMeta,
        sportType.isAcceptableOrUnknown(data['sport_type']!, _sportTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sportTypeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('total_distance_meters')) {
      context.handle(
        _totalDistanceMetersMeta,
        totalDistanceMeters.isAcceptableOrUnknown(
          data['total_distance_meters']!,
          _totalDistanceMetersMeta,
        ),
      );
    }
    if (data.containsKey('elapsed_time_seconds')) {
      context.handle(
        _elapsedTimeSecondsMeta,
        elapsedTimeSeconds.isAcceptableOrUnknown(
          data['elapsed_time_seconds']!,
          _elapsedTimeSecondsMeta,
        ),
      );
    }
    if (data.containsKey('moving_time_seconds')) {
      context.handle(
        _movingTimeSecondsMeta,
        movingTimeSeconds.isAcceptableOrUnknown(
          data['moving_time_seconds']!,
          _movingTimeSecondsMeta,
        ),
      );
    }
    if (data.containsKey('elevation_gain_meters')) {
      context.handle(
        _elevationGainMetersMeta,
        elevationGainMeters.isAcceptableOrUnknown(
          data['elevation_gain_meters']!,
          _elevationGainMetersMeta,
        ),
      );
    }
    if (data.containsKey('elevation_loss_meters')) {
      context.handle(
        _elevationLossMetersMeta,
        elevationLossMeters.isAcceptableOrUnknown(
          data['elevation_loss_meters']!,
          _elevationLossMetersMeta,
        ),
      );
    }
    if (data.containsKey('max_elevation_meters')) {
      context.handle(
        _maxElevationMetersMeta,
        maxElevationMeters.isAcceptableOrUnknown(
          data['max_elevation_meters']!,
          _maxElevationMetersMeta,
        ),
      );
    }
    if (data.containsKey('min_elevation_meters')) {
      context.handle(
        _minElevationMetersMeta,
        minElevationMeters.isAcceptableOrUnknown(
          data['min_elevation_meters']!,
          _minElevationMetersMeta,
        ),
      );
    }
    if (data.containsKey('avg_speed_mps')) {
      context.handle(
        _avgSpeedMpsMeta,
        avgSpeedMps.isAcceptableOrUnknown(
          data['avg_speed_mps']!,
          _avgSpeedMpsMeta,
        ),
      );
    }
    if (data.containsKey('max_speed_mps')) {
      context.handle(
        _maxSpeedMpsMeta,
        maxSpeedMps.isAcceptableOrUnknown(
          data['max_speed_mps']!,
          _maxSpeedMpsMeta,
        ),
      );
    }
    if (data.containsKey('avg_gap_mps')) {
      context.handle(
        _avgGapMpsMeta,
        avgGapMps.isAcceptableOrUnknown(data['avg_gap_mps']!, _avgGapMpsMeta),
      );
    }
    if (data.containsKey('avg_cadence')) {
      context.handle(
        _avgCadenceMeta,
        avgCadence.isAcceptableOrUnknown(data['avg_cadence']!, _avgCadenceMeta),
      );
    }
    if (data.containsKey('avg_heart_rate')) {
      context.handle(
        _avgHeartRateMeta,
        avgHeartRate.isAcceptableOrUnknown(
          data['avg_heart_rate']!,
          _avgHeartRateMeta,
        ),
      );
    }
    if (data.containsKey('max_heart_rate')) {
      context.handle(
        _maxHeartRateMeta,
        maxHeartRate.isAcceptableOrUnknown(
          data['max_heart_rate']!,
          _maxHeartRateMeta,
        ),
      );
    }
    if (data.containsKey('estimated_energy_kj')) {
      context.handle(
        _estimatedEnergyKjMeta,
        estimatedEnergyKj.isAcceptableOrUnknown(
          data['estimated_energy_kj']!,
          _estimatedEnergyKjMeta,
        ),
      );
    }
    if (data.containsKey('gravel_percentage')) {
      context.handle(
        _gravelPercentageMeta,
        gravelPercentage.isAcceptableOrUnknown(
          data['gravel_percentage']!,
          _gravelPercentageMeta,
        ),
      );
    }
    if (data.containsKey('asphalt_percentage')) {
      context.handle(
        _asphaltPercentageMeta,
        asphaltPercentage.isAcceptableOrUnknown(
          data['asphalt_percentage']!,
          _asphaltPercentageMeta,
        ),
      );
    }
    if (data.containsKey('primary_photo_path')) {
      context.handle(
        _primaryPhotoPathMeta,
        primaryPhotoPath.isAcceptableOrUnknown(
          data['primary_photo_path']!,
          _primaryPhotoPathMeta,
        ),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Activity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Activity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      gearId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gear_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      sportType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sport_type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      ),
      totalDistanceMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_distance_meters'],
      )!,
      elapsedTimeSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elapsed_time_seconds'],
      )!,
      movingTimeSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}moving_time_seconds'],
      )!,
      elevationGainMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}elevation_gain_meters'],
      )!,
      elevationLossMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}elevation_loss_meters'],
      )!,
      maxElevationMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_elevation_meters'],
      )!,
      minElevationMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_elevation_meters'],
      )!,
      avgSpeedMps: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_speed_mps'],
      )!,
      maxSpeedMps: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_speed_mps'],
      )!,
      avgGapMps: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_gap_mps'],
      ),
      avgCadence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}avg_cadence'],
      ),
      avgHeartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}avg_heart_rate'],
      ),
      maxHeartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_heart_rate'],
      ),
      estimatedEnergyKj: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_energy_kj'],
      ),
      gravelPercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gravel_percentage'],
      )!,
      asphaltPercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}asphalt_percentage'],
      )!,
      primaryPhotoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_photo_path'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ActivitiesTable createAlias(String alias) {
    return $ActivitiesTable(attachedDatabase, alias);
  }
}

class Activity extends DataClass implements Insertable<Activity> {
  final String id;
  final String? userId;
  final String? gearId;
  final String title;
  final String? description;
  final String sportType;
  final String status;
  final DateTime startTime;
  final DateTime? endTime;
  final double totalDistanceMeters;
  final int elapsedTimeSeconds;
  final int movingTimeSeconds;
  final double elevationGainMeters;
  final double elevationLossMeters;
  final double maxElevationMeters;
  final double minElevationMeters;
  final double avgSpeedMps;
  final double maxSpeedMps;
  final double? avgGapMps;
  final int? avgCadence;
  final int? avgHeartRate;
  final int? maxHeartRate;
  final int? estimatedEnergyKj;
  final double gravelPercentage;
  final double asphaltPercentage;
  final String? primaryPhotoPath;
  final bool isFavorite;
  final DateTime updatedAt;
  const Activity({
    required this.id,
    this.userId,
    this.gearId,
    required this.title,
    this.description,
    required this.sportType,
    required this.status,
    required this.startTime,
    this.endTime,
    required this.totalDistanceMeters,
    required this.elapsedTimeSeconds,
    required this.movingTimeSeconds,
    required this.elevationGainMeters,
    required this.elevationLossMeters,
    required this.maxElevationMeters,
    required this.minElevationMeters,
    required this.avgSpeedMps,
    required this.maxSpeedMps,
    this.avgGapMps,
    this.avgCadence,
    this.avgHeartRate,
    this.maxHeartRate,
    this.estimatedEnergyKj,
    required this.gravelPercentage,
    required this.asphaltPercentage,
    this.primaryPhotoPath,
    required this.isFavorite,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || gearId != null) {
      map['gear_id'] = Variable<String>(gearId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['sport_type'] = Variable<String>(sportType);
    map['status'] = Variable<String>(status);
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    map['total_distance_meters'] = Variable<double>(totalDistanceMeters);
    map['elapsed_time_seconds'] = Variable<int>(elapsedTimeSeconds);
    map['moving_time_seconds'] = Variable<int>(movingTimeSeconds);
    map['elevation_gain_meters'] = Variable<double>(elevationGainMeters);
    map['elevation_loss_meters'] = Variable<double>(elevationLossMeters);
    map['max_elevation_meters'] = Variable<double>(maxElevationMeters);
    map['min_elevation_meters'] = Variable<double>(minElevationMeters);
    map['avg_speed_mps'] = Variable<double>(avgSpeedMps);
    map['max_speed_mps'] = Variable<double>(maxSpeedMps);
    if (!nullToAbsent || avgGapMps != null) {
      map['avg_gap_mps'] = Variable<double>(avgGapMps);
    }
    if (!nullToAbsent || avgCadence != null) {
      map['avg_cadence'] = Variable<int>(avgCadence);
    }
    if (!nullToAbsent || avgHeartRate != null) {
      map['avg_heart_rate'] = Variable<int>(avgHeartRate);
    }
    if (!nullToAbsent || maxHeartRate != null) {
      map['max_heart_rate'] = Variable<int>(maxHeartRate);
    }
    if (!nullToAbsent || estimatedEnergyKj != null) {
      map['estimated_energy_kj'] = Variable<int>(estimatedEnergyKj);
    }
    map['gravel_percentage'] = Variable<double>(gravelPercentage);
    map['asphalt_percentage'] = Variable<double>(asphaltPercentage);
    if (!nullToAbsent || primaryPhotoPath != null) {
      map['primary_photo_path'] = Variable<String>(primaryPhotoPath);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ActivitiesCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      gearId: gearId == null && nullToAbsent
          ? const Value.absent()
          : Value(gearId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      sportType: Value(sportType),
      status: Value(status),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      totalDistanceMeters: Value(totalDistanceMeters),
      elapsedTimeSeconds: Value(elapsedTimeSeconds),
      movingTimeSeconds: Value(movingTimeSeconds),
      elevationGainMeters: Value(elevationGainMeters),
      elevationLossMeters: Value(elevationLossMeters),
      maxElevationMeters: Value(maxElevationMeters),
      minElevationMeters: Value(minElevationMeters),
      avgSpeedMps: Value(avgSpeedMps),
      maxSpeedMps: Value(maxSpeedMps),
      avgGapMps: avgGapMps == null && nullToAbsent
          ? const Value.absent()
          : Value(avgGapMps),
      avgCadence: avgCadence == null && nullToAbsent
          ? const Value.absent()
          : Value(avgCadence),
      avgHeartRate: avgHeartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(avgHeartRate),
      maxHeartRate: maxHeartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(maxHeartRate),
      estimatedEnergyKj: estimatedEnergyKj == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedEnergyKj),
      gravelPercentage: Value(gravelPercentage),
      asphaltPercentage: Value(asphaltPercentage),
      primaryPhotoPath: primaryPhotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryPhotoPath),
      isFavorite: Value(isFavorite),
      updatedAt: Value(updatedAt),
    );
  }

  factory Activity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Activity(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      gearId: serializer.fromJson<String?>(json['gearId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      sportType: serializer.fromJson<String>(json['sportType']),
      status: serializer.fromJson<String>(json['status']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      totalDistanceMeters: serializer.fromJson<double>(
        json['totalDistanceMeters'],
      ),
      elapsedTimeSeconds: serializer.fromJson<int>(json['elapsedTimeSeconds']),
      movingTimeSeconds: serializer.fromJson<int>(json['movingTimeSeconds']),
      elevationGainMeters: serializer.fromJson<double>(
        json['elevationGainMeters'],
      ),
      elevationLossMeters: serializer.fromJson<double>(
        json['elevationLossMeters'],
      ),
      maxElevationMeters: serializer.fromJson<double>(
        json['maxElevationMeters'],
      ),
      minElevationMeters: serializer.fromJson<double>(
        json['minElevationMeters'],
      ),
      avgSpeedMps: serializer.fromJson<double>(json['avgSpeedMps']),
      maxSpeedMps: serializer.fromJson<double>(json['maxSpeedMps']),
      avgGapMps: serializer.fromJson<double?>(json['avgGapMps']),
      avgCadence: serializer.fromJson<int?>(json['avgCadence']),
      avgHeartRate: serializer.fromJson<int?>(json['avgHeartRate']),
      maxHeartRate: serializer.fromJson<int?>(json['maxHeartRate']),
      estimatedEnergyKj: serializer.fromJson<int?>(json['estimatedEnergyKj']),
      gravelPercentage: serializer.fromJson<double>(json['gravelPercentage']),
      asphaltPercentage: serializer.fromJson<double>(json['asphaltPercentage']),
      primaryPhotoPath: serializer.fromJson<String?>(json['primaryPhotoPath']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'gearId': serializer.toJson<String?>(gearId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'sportType': serializer.toJson<String>(sportType),
      'status': serializer.toJson<String>(status),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'totalDistanceMeters': serializer.toJson<double>(totalDistanceMeters),
      'elapsedTimeSeconds': serializer.toJson<int>(elapsedTimeSeconds),
      'movingTimeSeconds': serializer.toJson<int>(movingTimeSeconds),
      'elevationGainMeters': serializer.toJson<double>(elevationGainMeters),
      'elevationLossMeters': serializer.toJson<double>(elevationLossMeters),
      'maxElevationMeters': serializer.toJson<double>(maxElevationMeters),
      'minElevationMeters': serializer.toJson<double>(minElevationMeters),
      'avgSpeedMps': serializer.toJson<double>(avgSpeedMps),
      'maxSpeedMps': serializer.toJson<double>(maxSpeedMps),
      'avgGapMps': serializer.toJson<double?>(avgGapMps),
      'avgCadence': serializer.toJson<int?>(avgCadence),
      'avgHeartRate': serializer.toJson<int?>(avgHeartRate),
      'maxHeartRate': serializer.toJson<int?>(maxHeartRate),
      'estimatedEnergyKj': serializer.toJson<int?>(estimatedEnergyKj),
      'gravelPercentage': serializer.toJson<double>(gravelPercentage),
      'asphaltPercentage': serializer.toJson<double>(asphaltPercentage),
      'primaryPhotoPath': serializer.toJson<String?>(primaryPhotoPath),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Activity copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    Value<String?> gearId = const Value.absent(),
    String? title,
    Value<String?> description = const Value.absent(),
    String? sportType,
    String? status,
    DateTime? startTime,
    Value<DateTime?> endTime = const Value.absent(),
    double? totalDistanceMeters,
    int? elapsedTimeSeconds,
    int? movingTimeSeconds,
    double? elevationGainMeters,
    double? elevationLossMeters,
    double? maxElevationMeters,
    double? minElevationMeters,
    double? avgSpeedMps,
    double? maxSpeedMps,
    Value<double?> avgGapMps = const Value.absent(),
    Value<int?> avgCadence = const Value.absent(),
    Value<int?> avgHeartRate = const Value.absent(),
    Value<int?> maxHeartRate = const Value.absent(),
    Value<int?> estimatedEnergyKj = const Value.absent(),
    double? gravelPercentage,
    double? asphaltPercentage,
    Value<String?> primaryPhotoPath = const Value.absent(),
    bool? isFavorite,
    DateTime? updatedAt,
  }) => Activity(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    gearId: gearId.present ? gearId.value : this.gearId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    sportType: sportType ?? this.sportType,
    status: status ?? this.status,
    startTime: startTime ?? this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    totalDistanceMeters: totalDistanceMeters ?? this.totalDistanceMeters,
    elapsedTimeSeconds: elapsedTimeSeconds ?? this.elapsedTimeSeconds,
    movingTimeSeconds: movingTimeSeconds ?? this.movingTimeSeconds,
    elevationGainMeters: elevationGainMeters ?? this.elevationGainMeters,
    elevationLossMeters: elevationLossMeters ?? this.elevationLossMeters,
    maxElevationMeters: maxElevationMeters ?? this.maxElevationMeters,
    minElevationMeters: minElevationMeters ?? this.minElevationMeters,
    avgSpeedMps: avgSpeedMps ?? this.avgSpeedMps,
    maxSpeedMps: maxSpeedMps ?? this.maxSpeedMps,
    avgGapMps: avgGapMps.present ? avgGapMps.value : this.avgGapMps,
    avgCadence: avgCadence.present ? avgCadence.value : this.avgCadence,
    avgHeartRate: avgHeartRate.present ? avgHeartRate.value : this.avgHeartRate,
    maxHeartRate: maxHeartRate.present ? maxHeartRate.value : this.maxHeartRate,
    estimatedEnergyKj: estimatedEnergyKj.present
        ? estimatedEnergyKj.value
        : this.estimatedEnergyKj,
    gravelPercentage: gravelPercentage ?? this.gravelPercentage,
    asphaltPercentage: asphaltPercentage ?? this.asphaltPercentage,
    primaryPhotoPath: primaryPhotoPath.present
        ? primaryPhotoPath.value
        : this.primaryPhotoPath,
    isFavorite: isFavorite ?? this.isFavorite,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Activity copyWithCompanion(ActivitiesCompanion data) {
    return Activity(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      gearId: data.gearId.present ? data.gearId.value : this.gearId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      sportType: data.sportType.present ? data.sportType.value : this.sportType,
      status: data.status.present ? data.status.value : this.status,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      totalDistanceMeters: data.totalDistanceMeters.present
          ? data.totalDistanceMeters.value
          : this.totalDistanceMeters,
      elapsedTimeSeconds: data.elapsedTimeSeconds.present
          ? data.elapsedTimeSeconds.value
          : this.elapsedTimeSeconds,
      movingTimeSeconds: data.movingTimeSeconds.present
          ? data.movingTimeSeconds.value
          : this.movingTimeSeconds,
      elevationGainMeters: data.elevationGainMeters.present
          ? data.elevationGainMeters.value
          : this.elevationGainMeters,
      elevationLossMeters: data.elevationLossMeters.present
          ? data.elevationLossMeters.value
          : this.elevationLossMeters,
      maxElevationMeters: data.maxElevationMeters.present
          ? data.maxElevationMeters.value
          : this.maxElevationMeters,
      minElevationMeters: data.minElevationMeters.present
          ? data.minElevationMeters.value
          : this.minElevationMeters,
      avgSpeedMps: data.avgSpeedMps.present
          ? data.avgSpeedMps.value
          : this.avgSpeedMps,
      maxSpeedMps: data.maxSpeedMps.present
          ? data.maxSpeedMps.value
          : this.maxSpeedMps,
      avgGapMps: data.avgGapMps.present ? data.avgGapMps.value : this.avgGapMps,
      avgCadence: data.avgCadence.present
          ? data.avgCadence.value
          : this.avgCadence,
      avgHeartRate: data.avgHeartRate.present
          ? data.avgHeartRate.value
          : this.avgHeartRate,
      maxHeartRate: data.maxHeartRate.present
          ? data.maxHeartRate.value
          : this.maxHeartRate,
      estimatedEnergyKj: data.estimatedEnergyKj.present
          ? data.estimatedEnergyKj.value
          : this.estimatedEnergyKj,
      gravelPercentage: data.gravelPercentage.present
          ? data.gravelPercentage.value
          : this.gravelPercentage,
      asphaltPercentage: data.asphaltPercentage.present
          ? data.asphaltPercentage.value
          : this.asphaltPercentage,
      primaryPhotoPath: data.primaryPhotoPath.present
          ? data.primaryPhotoPath.value
          : this.primaryPhotoPath,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Activity(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('gearId: $gearId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('sportType: $sportType, ')
          ..write('status: $status, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('totalDistanceMeters: $totalDistanceMeters, ')
          ..write('elapsedTimeSeconds: $elapsedTimeSeconds, ')
          ..write('movingTimeSeconds: $movingTimeSeconds, ')
          ..write('elevationGainMeters: $elevationGainMeters, ')
          ..write('elevationLossMeters: $elevationLossMeters, ')
          ..write('maxElevationMeters: $maxElevationMeters, ')
          ..write('minElevationMeters: $minElevationMeters, ')
          ..write('avgSpeedMps: $avgSpeedMps, ')
          ..write('maxSpeedMps: $maxSpeedMps, ')
          ..write('avgGapMps: $avgGapMps, ')
          ..write('avgCadence: $avgCadence, ')
          ..write('avgHeartRate: $avgHeartRate, ')
          ..write('maxHeartRate: $maxHeartRate, ')
          ..write('estimatedEnergyKj: $estimatedEnergyKj, ')
          ..write('gravelPercentage: $gravelPercentage, ')
          ..write('asphaltPercentage: $asphaltPercentage, ')
          ..write('primaryPhotoPath: $primaryPhotoPath, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    userId,
    gearId,
    title,
    description,
    sportType,
    status,
    startTime,
    endTime,
    totalDistanceMeters,
    elapsedTimeSeconds,
    movingTimeSeconds,
    elevationGainMeters,
    elevationLossMeters,
    maxElevationMeters,
    minElevationMeters,
    avgSpeedMps,
    maxSpeedMps,
    avgGapMps,
    avgCadence,
    avgHeartRate,
    maxHeartRate,
    estimatedEnergyKj,
    gravelPercentage,
    asphaltPercentage,
    primaryPhotoPath,
    isFavorite,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Activity &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.gearId == this.gearId &&
          other.title == this.title &&
          other.description == this.description &&
          other.sportType == this.sportType &&
          other.status == this.status &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.totalDistanceMeters == this.totalDistanceMeters &&
          other.elapsedTimeSeconds == this.elapsedTimeSeconds &&
          other.movingTimeSeconds == this.movingTimeSeconds &&
          other.elevationGainMeters == this.elevationGainMeters &&
          other.elevationLossMeters == this.elevationLossMeters &&
          other.maxElevationMeters == this.maxElevationMeters &&
          other.minElevationMeters == this.minElevationMeters &&
          other.avgSpeedMps == this.avgSpeedMps &&
          other.maxSpeedMps == this.maxSpeedMps &&
          other.avgGapMps == this.avgGapMps &&
          other.avgCadence == this.avgCadence &&
          other.avgHeartRate == this.avgHeartRate &&
          other.maxHeartRate == this.maxHeartRate &&
          other.estimatedEnergyKj == this.estimatedEnergyKj &&
          other.gravelPercentage == this.gravelPercentage &&
          other.asphaltPercentage == this.asphaltPercentage &&
          other.primaryPhotoPath == this.primaryPhotoPath &&
          other.isFavorite == this.isFavorite &&
          other.updatedAt == this.updatedAt);
}

class ActivitiesCompanion extends UpdateCompanion<Activity> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String?> gearId;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> sportType;
  final Value<String> status;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<double> totalDistanceMeters;
  final Value<int> elapsedTimeSeconds;
  final Value<int> movingTimeSeconds;
  final Value<double> elevationGainMeters;
  final Value<double> elevationLossMeters;
  final Value<double> maxElevationMeters;
  final Value<double> minElevationMeters;
  final Value<double> avgSpeedMps;
  final Value<double> maxSpeedMps;
  final Value<double?> avgGapMps;
  final Value<int?> avgCadence;
  final Value<int?> avgHeartRate;
  final Value<int?> maxHeartRate;
  final Value<int?> estimatedEnergyKj;
  final Value<double> gravelPercentage;
  final Value<double> asphaltPercentage;
  final Value<String?> primaryPhotoPath;
  final Value<bool> isFavorite;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ActivitiesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.gearId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.sportType = const Value.absent(),
    this.status = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.totalDistanceMeters = const Value.absent(),
    this.elapsedTimeSeconds = const Value.absent(),
    this.movingTimeSeconds = const Value.absent(),
    this.elevationGainMeters = const Value.absent(),
    this.elevationLossMeters = const Value.absent(),
    this.maxElevationMeters = const Value.absent(),
    this.minElevationMeters = const Value.absent(),
    this.avgSpeedMps = const Value.absent(),
    this.maxSpeedMps = const Value.absent(),
    this.avgGapMps = const Value.absent(),
    this.avgCadence = const Value.absent(),
    this.avgHeartRate = const Value.absent(),
    this.maxHeartRate = const Value.absent(),
    this.estimatedEnergyKj = const Value.absent(),
    this.gravelPercentage = const Value.absent(),
    this.asphaltPercentage = const Value.absent(),
    this.primaryPhotoPath = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivitiesCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    this.gearId = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required String sportType,
    required String status,
    required DateTime startTime,
    this.endTime = const Value.absent(),
    this.totalDistanceMeters = const Value.absent(),
    this.elapsedTimeSeconds = const Value.absent(),
    this.movingTimeSeconds = const Value.absent(),
    this.elevationGainMeters = const Value.absent(),
    this.elevationLossMeters = const Value.absent(),
    this.maxElevationMeters = const Value.absent(),
    this.minElevationMeters = const Value.absent(),
    this.avgSpeedMps = const Value.absent(),
    this.maxSpeedMps = const Value.absent(),
    this.avgGapMps = const Value.absent(),
    this.avgCadence = const Value.absent(),
    this.avgHeartRate = const Value.absent(),
    this.maxHeartRate = const Value.absent(),
    this.estimatedEnergyKj = const Value.absent(),
    this.gravelPercentage = const Value.absent(),
    this.asphaltPercentage = const Value.absent(),
    this.primaryPhotoPath = const Value.absent(),
    this.isFavorite = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       sportType = Value(sportType),
       status = Value(status),
       startTime = Value(startTime),
       updatedAt = Value(updatedAt);
  static Insertable<Activity> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? gearId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? sportType,
    Expression<String>? status,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<double>? totalDistanceMeters,
    Expression<int>? elapsedTimeSeconds,
    Expression<int>? movingTimeSeconds,
    Expression<double>? elevationGainMeters,
    Expression<double>? elevationLossMeters,
    Expression<double>? maxElevationMeters,
    Expression<double>? minElevationMeters,
    Expression<double>? avgSpeedMps,
    Expression<double>? maxSpeedMps,
    Expression<double>? avgGapMps,
    Expression<int>? avgCadence,
    Expression<int>? avgHeartRate,
    Expression<int>? maxHeartRate,
    Expression<int>? estimatedEnergyKj,
    Expression<double>? gravelPercentage,
    Expression<double>? asphaltPercentage,
    Expression<String>? primaryPhotoPath,
    Expression<bool>? isFavorite,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (gearId != null) 'gear_id': gearId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (sportType != null) 'sport_type': sportType,
      if (status != null) 'status': status,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (totalDistanceMeters != null)
        'total_distance_meters': totalDistanceMeters,
      if (elapsedTimeSeconds != null)
        'elapsed_time_seconds': elapsedTimeSeconds,
      if (movingTimeSeconds != null) 'moving_time_seconds': movingTimeSeconds,
      if (elevationGainMeters != null)
        'elevation_gain_meters': elevationGainMeters,
      if (elevationLossMeters != null)
        'elevation_loss_meters': elevationLossMeters,
      if (maxElevationMeters != null)
        'max_elevation_meters': maxElevationMeters,
      if (minElevationMeters != null)
        'min_elevation_meters': minElevationMeters,
      if (avgSpeedMps != null) 'avg_speed_mps': avgSpeedMps,
      if (maxSpeedMps != null) 'max_speed_mps': maxSpeedMps,
      if (avgGapMps != null) 'avg_gap_mps': avgGapMps,
      if (avgCadence != null) 'avg_cadence': avgCadence,
      if (avgHeartRate != null) 'avg_heart_rate': avgHeartRate,
      if (maxHeartRate != null) 'max_heart_rate': maxHeartRate,
      if (estimatedEnergyKj != null) 'estimated_energy_kj': estimatedEnergyKj,
      if (gravelPercentage != null) 'gravel_percentage': gravelPercentage,
      if (asphaltPercentage != null) 'asphalt_percentage': asphaltPercentage,
      if (primaryPhotoPath != null) 'primary_photo_path': primaryPhotoPath,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivitiesCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<String?>? gearId,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? sportType,
    Value<String>? status,
    Value<DateTime>? startTime,
    Value<DateTime?>? endTime,
    Value<double>? totalDistanceMeters,
    Value<int>? elapsedTimeSeconds,
    Value<int>? movingTimeSeconds,
    Value<double>? elevationGainMeters,
    Value<double>? elevationLossMeters,
    Value<double>? maxElevationMeters,
    Value<double>? minElevationMeters,
    Value<double>? avgSpeedMps,
    Value<double>? maxSpeedMps,
    Value<double?>? avgGapMps,
    Value<int?>? avgCadence,
    Value<int?>? avgHeartRate,
    Value<int?>? maxHeartRate,
    Value<int?>? estimatedEnergyKj,
    Value<double>? gravelPercentage,
    Value<double>? asphaltPercentage,
    Value<String?>? primaryPhotoPath,
    Value<bool>? isFavorite,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ActivitiesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      gearId: gearId ?? this.gearId,
      title: title ?? this.title,
      description: description ?? this.description,
      sportType: sportType ?? this.sportType,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalDistanceMeters: totalDistanceMeters ?? this.totalDistanceMeters,
      elapsedTimeSeconds: elapsedTimeSeconds ?? this.elapsedTimeSeconds,
      movingTimeSeconds: movingTimeSeconds ?? this.movingTimeSeconds,
      elevationGainMeters: elevationGainMeters ?? this.elevationGainMeters,
      elevationLossMeters: elevationLossMeters ?? this.elevationLossMeters,
      maxElevationMeters: maxElevationMeters ?? this.maxElevationMeters,
      minElevationMeters: minElevationMeters ?? this.minElevationMeters,
      avgSpeedMps: avgSpeedMps ?? this.avgSpeedMps,
      maxSpeedMps: maxSpeedMps ?? this.maxSpeedMps,
      avgGapMps: avgGapMps ?? this.avgGapMps,
      avgCadence: avgCadence ?? this.avgCadence,
      avgHeartRate: avgHeartRate ?? this.avgHeartRate,
      maxHeartRate: maxHeartRate ?? this.maxHeartRate,
      estimatedEnergyKj: estimatedEnergyKj ?? this.estimatedEnergyKj,
      gravelPercentage: gravelPercentage ?? this.gravelPercentage,
      asphaltPercentage: asphaltPercentage ?? this.asphaltPercentage,
      primaryPhotoPath: primaryPhotoPath ?? this.primaryPhotoPath,
      isFavorite: isFavorite ?? this.isFavorite,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (gearId.present) {
      map['gear_id'] = Variable<String>(gearId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sportType.present) {
      map['sport_type'] = Variable<String>(sportType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (totalDistanceMeters.present) {
      map['total_distance_meters'] = Variable<double>(
        totalDistanceMeters.value,
      );
    }
    if (elapsedTimeSeconds.present) {
      map['elapsed_time_seconds'] = Variable<int>(elapsedTimeSeconds.value);
    }
    if (movingTimeSeconds.present) {
      map['moving_time_seconds'] = Variable<int>(movingTimeSeconds.value);
    }
    if (elevationGainMeters.present) {
      map['elevation_gain_meters'] = Variable<double>(
        elevationGainMeters.value,
      );
    }
    if (elevationLossMeters.present) {
      map['elevation_loss_meters'] = Variable<double>(
        elevationLossMeters.value,
      );
    }
    if (maxElevationMeters.present) {
      map['max_elevation_meters'] = Variable<double>(maxElevationMeters.value);
    }
    if (minElevationMeters.present) {
      map['min_elevation_meters'] = Variable<double>(minElevationMeters.value);
    }
    if (avgSpeedMps.present) {
      map['avg_speed_mps'] = Variable<double>(avgSpeedMps.value);
    }
    if (maxSpeedMps.present) {
      map['max_speed_mps'] = Variable<double>(maxSpeedMps.value);
    }
    if (avgGapMps.present) {
      map['avg_gap_mps'] = Variable<double>(avgGapMps.value);
    }
    if (avgCadence.present) {
      map['avg_cadence'] = Variable<int>(avgCadence.value);
    }
    if (avgHeartRate.present) {
      map['avg_heart_rate'] = Variable<int>(avgHeartRate.value);
    }
    if (maxHeartRate.present) {
      map['max_heart_rate'] = Variable<int>(maxHeartRate.value);
    }
    if (estimatedEnergyKj.present) {
      map['estimated_energy_kj'] = Variable<int>(estimatedEnergyKj.value);
    }
    if (gravelPercentage.present) {
      map['gravel_percentage'] = Variable<double>(gravelPercentage.value);
    }
    if (asphaltPercentage.present) {
      map['asphalt_percentage'] = Variable<double>(asphaltPercentage.value);
    }
    if (primaryPhotoPath.present) {
      map['primary_photo_path'] = Variable<String>(primaryPhotoPath.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('gearId: $gearId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('sportType: $sportType, ')
          ..write('status: $status, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('totalDistanceMeters: $totalDistanceMeters, ')
          ..write('elapsedTimeSeconds: $elapsedTimeSeconds, ')
          ..write('movingTimeSeconds: $movingTimeSeconds, ')
          ..write('elevationGainMeters: $elevationGainMeters, ')
          ..write('elevationLossMeters: $elevationLossMeters, ')
          ..write('maxElevationMeters: $maxElevationMeters, ')
          ..write('minElevationMeters: $minElevationMeters, ')
          ..write('avgSpeedMps: $avgSpeedMps, ')
          ..write('maxSpeedMps: $maxSpeedMps, ')
          ..write('avgGapMps: $avgGapMps, ')
          ..write('avgCadence: $avgCadence, ')
          ..write('avgHeartRate: $avgHeartRate, ')
          ..write('maxHeartRate: $maxHeartRate, ')
          ..write('estimatedEnergyKj: $estimatedEnergyKj, ')
          ..write('gravelPercentage: $gravelPercentage, ')
          ..write('asphaltPercentage: $asphaltPercentage, ')
          ..write('primaryPhotoPath: $primaryPhotoPath, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrackPointsTable extends TrackPoints
    with TableInfo<$TrackPointsTable, TrackPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackPointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sequenceIdxMeta = const VerificationMeta(
    'sequenceIdx',
  );
  @override
  late final GeneratedColumn<int> sequenceIdx = GeneratedColumn<int>(
    'sequence_idx',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _altitudeMetersMeta = const VerificationMeta(
    'altitudeMeters',
  );
  @override
  late final GeneratedColumn<double> altitudeMeters = GeneratedColumn<double>(
    'altitude_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accuracyMetersMeta = const VerificationMeta(
    'accuracyMeters',
  );
  @override
  late final GeneratedColumn<double> accuracyMeters = GeneratedColumn<double>(
    'accuracy_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speedMpsMeta = const VerificationMeta(
    'speedMps',
  );
  @override
  late final GeneratedColumn<double> speedMps = GeneratedColumn<double>(
    'speed_mps',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bearingDegreesMeta = const VerificationMeta(
    'bearingDegrees',
  );
  @override
  late final GeneratedColumn<double> bearingDegrees = GeneratedColumn<double>(
    'bearing_degrees',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _gradePctMeta = const VerificationMeta(
    'gradePct',
  );
  @override
  late final GeneratedColumn<double> gradePct = GeneratedColumn<double>(
    'grade_pct',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _surfaceTypeMeta = const VerificationMeta(
    'surfaceType',
  );
  @override
  late final GeneratedColumn<String> surfaceType = GeneratedColumn<String>(
    'surface_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unknown'),
  );
  static const VerificationMeta _vibrationRawMeta = const VerificationMeta(
    'vibrationRaw',
  );
  @override
  late final GeneratedColumn<double> vibrationRaw = GeneratedColumn<double>(
    'vibration_raw',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _heartRateMeta = const VerificationMeta(
    'heartRate',
  );
  @override
  late final GeneratedColumn<int> heartRate = GeneratedColumn<int>(
    'heart_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cadenceMeta = const VerificationMeta(
    'cadence',
  );
  @override
  late final GeneratedColumn<int> cadence = GeneratedColumn<int>(
    'cadence',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPausedMeta = const VerificationMeta(
    'isPaused',
  );
  @override
  late final GeneratedColumn<bool> isPaused = GeneratedColumn<bool>(
    'is_paused',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_paused" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    activityId,
    sequenceIdx,
    timestamp,
    latitude,
    longitude,
    altitudeMeters,
    accuracyMeters,
    speedMps,
    bearingDegrees,
    gradePct,
    surfaceType,
    vibrationRaw,
    heartRate,
    cadence,
    isPaused,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'track_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrackPoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('sequence_idx')) {
      context.handle(
        _sequenceIdxMeta,
        sequenceIdx.isAcceptableOrUnknown(
          data['sequence_idx']!,
          _sequenceIdxMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sequenceIdxMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('altitude_meters')) {
      context.handle(
        _altitudeMetersMeta,
        altitudeMeters.isAcceptableOrUnknown(
          data['altitude_meters']!,
          _altitudeMetersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_altitudeMetersMeta);
    }
    if (data.containsKey('accuracy_meters')) {
      context.handle(
        _accuracyMetersMeta,
        accuracyMeters.isAcceptableOrUnknown(
          data['accuracy_meters']!,
          _accuracyMetersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accuracyMetersMeta);
    }
    if (data.containsKey('speed_mps')) {
      context.handle(
        _speedMpsMeta,
        speedMps.isAcceptableOrUnknown(data['speed_mps']!, _speedMpsMeta),
      );
    } else if (isInserting) {
      context.missing(_speedMpsMeta);
    }
    if (data.containsKey('bearing_degrees')) {
      context.handle(
        _bearingDegreesMeta,
        bearingDegrees.isAcceptableOrUnknown(
          data['bearing_degrees']!,
          _bearingDegreesMeta,
        ),
      );
    }
    if (data.containsKey('grade_pct')) {
      context.handle(
        _gradePctMeta,
        gradePct.isAcceptableOrUnknown(data['grade_pct']!, _gradePctMeta),
      );
    }
    if (data.containsKey('surface_type')) {
      context.handle(
        _surfaceTypeMeta,
        surfaceType.isAcceptableOrUnknown(
          data['surface_type']!,
          _surfaceTypeMeta,
        ),
      );
    }
    if (data.containsKey('vibration_raw')) {
      context.handle(
        _vibrationRawMeta,
        vibrationRaw.isAcceptableOrUnknown(
          data['vibration_raw']!,
          _vibrationRawMeta,
        ),
      );
    }
    if (data.containsKey('heart_rate')) {
      context.handle(
        _heartRateMeta,
        heartRate.isAcceptableOrUnknown(data['heart_rate']!, _heartRateMeta),
      );
    }
    if (data.containsKey('cadence')) {
      context.handle(
        _cadenceMeta,
        cadence.isAcceptableOrUnknown(data['cadence']!, _cadenceMeta),
      );
    }
    if (data.containsKey('is_paused')) {
      context.handle(
        _isPausedMeta,
        isPaused.isAcceptableOrUnknown(data['is_paused']!, _isPausedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackPoint(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      sequenceIdx: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence_idx'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      altitudeMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}altitude_meters'],
      )!,
      accuracyMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy_meters'],
      )!,
      speedMps: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed_mps'],
      )!,
      bearingDegrees: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bearing_degrees'],
      )!,
      gradePct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grade_pct'],
      )!,
      surfaceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}surface_type'],
      )!,
      vibrationRaw: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vibration_raw'],
      )!,
      heartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}heart_rate'],
      ),
      cadence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cadence'],
      ),
      isPaused: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_paused'],
      )!,
    );
  }

  @override
  $TrackPointsTable createAlias(String alias) {
    return $TrackPointsTable(attachedDatabase, alias);
  }
}

class TrackPoint extends DataClass implements Insertable<TrackPoint> {
  final int id;
  final String activityId;
  final int sequenceIdx;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double altitudeMeters;
  final double accuracyMeters;
  final double speedMps;
  final double bearingDegrees;
  final double gradePct;
  final String surfaceType;
  final double vibrationRaw;
  final int? heartRate;
  final int? cadence;
  final bool isPaused;
  const TrackPoint({
    required this.id,
    required this.activityId,
    required this.sequenceIdx,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.altitudeMeters,
    required this.accuracyMeters,
    required this.speedMps,
    required this.bearingDegrees,
    required this.gradePct,
    required this.surfaceType,
    required this.vibrationRaw,
    this.heartRate,
    this.cadence,
    required this.isPaused,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['activity_id'] = Variable<String>(activityId);
    map['sequence_idx'] = Variable<int>(sequenceIdx);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['altitude_meters'] = Variable<double>(altitudeMeters);
    map['accuracy_meters'] = Variable<double>(accuracyMeters);
    map['speed_mps'] = Variable<double>(speedMps);
    map['bearing_degrees'] = Variable<double>(bearingDegrees);
    map['grade_pct'] = Variable<double>(gradePct);
    map['surface_type'] = Variable<String>(surfaceType);
    map['vibration_raw'] = Variable<double>(vibrationRaw);
    if (!nullToAbsent || heartRate != null) {
      map['heart_rate'] = Variable<int>(heartRate);
    }
    if (!nullToAbsent || cadence != null) {
      map['cadence'] = Variable<int>(cadence);
    }
    map['is_paused'] = Variable<bool>(isPaused);
    return map;
  }

  TrackPointsCompanion toCompanion(bool nullToAbsent) {
    return TrackPointsCompanion(
      id: Value(id),
      activityId: Value(activityId),
      sequenceIdx: Value(sequenceIdx),
      timestamp: Value(timestamp),
      latitude: Value(latitude),
      longitude: Value(longitude),
      altitudeMeters: Value(altitudeMeters),
      accuracyMeters: Value(accuracyMeters),
      speedMps: Value(speedMps),
      bearingDegrees: Value(bearingDegrees),
      gradePct: Value(gradePct),
      surfaceType: Value(surfaceType),
      vibrationRaw: Value(vibrationRaw),
      heartRate: heartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(heartRate),
      cadence: cadence == null && nullToAbsent
          ? const Value.absent()
          : Value(cadence),
      isPaused: Value(isPaused),
    );
  }

  factory TrackPoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackPoint(
      id: serializer.fromJson<int>(json['id']),
      activityId: serializer.fromJson<String>(json['activityId']),
      sequenceIdx: serializer.fromJson<int>(json['sequenceIdx']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      altitudeMeters: serializer.fromJson<double>(json['altitudeMeters']),
      accuracyMeters: serializer.fromJson<double>(json['accuracyMeters']),
      speedMps: serializer.fromJson<double>(json['speedMps']),
      bearingDegrees: serializer.fromJson<double>(json['bearingDegrees']),
      gradePct: serializer.fromJson<double>(json['gradePct']),
      surfaceType: serializer.fromJson<String>(json['surfaceType']),
      vibrationRaw: serializer.fromJson<double>(json['vibrationRaw']),
      heartRate: serializer.fromJson<int?>(json['heartRate']),
      cadence: serializer.fromJson<int?>(json['cadence']),
      isPaused: serializer.fromJson<bool>(json['isPaused']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'activityId': serializer.toJson<String>(activityId),
      'sequenceIdx': serializer.toJson<int>(sequenceIdx),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'altitudeMeters': serializer.toJson<double>(altitudeMeters),
      'accuracyMeters': serializer.toJson<double>(accuracyMeters),
      'speedMps': serializer.toJson<double>(speedMps),
      'bearingDegrees': serializer.toJson<double>(bearingDegrees),
      'gradePct': serializer.toJson<double>(gradePct),
      'surfaceType': serializer.toJson<String>(surfaceType),
      'vibrationRaw': serializer.toJson<double>(vibrationRaw),
      'heartRate': serializer.toJson<int?>(heartRate),
      'cadence': serializer.toJson<int?>(cadence),
      'isPaused': serializer.toJson<bool>(isPaused),
    };
  }

  TrackPoint copyWith({
    int? id,
    String? activityId,
    int? sequenceIdx,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    double? altitudeMeters,
    double? accuracyMeters,
    double? speedMps,
    double? bearingDegrees,
    double? gradePct,
    String? surfaceType,
    double? vibrationRaw,
    Value<int?> heartRate = const Value.absent(),
    Value<int?> cadence = const Value.absent(),
    bool? isPaused,
  }) => TrackPoint(
    id: id ?? this.id,
    activityId: activityId ?? this.activityId,
    sequenceIdx: sequenceIdx ?? this.sequenceIdx,
    timestamp: timestamp ?? this.timestamp,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    altitudeMeters: altitudeMeters ?? this.altitudeMeters,
    accuracyMeters: accuracyMeters ?? this.accuracyMeters,
    speedMps: speedMps ?? this.speedMps,
    bearingDegrees: bearingDegrees ?? this.bearingDegrees,
    gradePct: gradePct ?? this.gradePct,
    surfaceType: surfaceType ?? this.surfaceType,
    vibrationRaw: vibrationRaw ?? this.vibrationRaw,
    heartRate: heartRate.present ? heartRate.value : this.heartRate,
    cadence: cadence.present ? cadence.value : this.cadence,
    isPaused: isPaused ?? this.isPaused,
  );
  TrackPoint copyWithCompanion(TrackPointsCompanion data) {
    return TrackPoint(
      id: data.id.present ? data.id.value : this.id,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      sequenceIdx: data.sequenceIdx.present
          ? data.sequenceIdx.value
          : this.sequenceIdx,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      altitudeMeters: data.altitudeMeters.present
          ? data.altitudeMeters.value
          : this.altitudeMeters,
      accuracyMeters: data.accuracyMeters.present
          ? data.accuracyMeters.value
          : this.accuracyMeters,
      speedMps: data.speedMps.present ? data.speedMps.value : this.speedMps,
      bearingDegrees: data.bearingDegrees.present
          ? data.bearingDegrees.value
          : this.bearingDegrees,
      gradePct: data.gradePct.present ? data.gradePct.value : this.gradePct,
      surfaceType: data.surfaceType.present
          ? data.surfaceType.value
          : this.surfaceType,
      vibrationRaw: data.vibrationRaw.present
          ? data.vibrationRaw.value
          : this.vibrationRaw,
      heartRate: data.heartRate.present ? data.heartRate.value : this.heartRate,
      cadence: data.cadence.present ? data.cadence.value : this.cadence,
      isPaused: data.isPaused.present ? data.isPaused.value : this.isPaused,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackPoint(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('sequenceIdx: $sequenceIdx, ')
          ..write('timestamp: $timestamp, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitudeMeters: $altitudeMeters, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('speedMps: $speedMps, ')
          ..write('bearingDegrees: $bearingDegrees, ')
          ..write('gradePct: $gradePct, ')
          ..write('surfaceType: $surfaceType, ')
          ..write('vibrationRaw: $vibrationRaw, ')
          ..write('heartRate: $heartRate, ')
          ..write('cadence: $cadence, ')
          ..write('isPaused: $isPaused')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    activityId,
    sequenceIdx,
    timestamp,
    latitude,
    longitude,
    altitudeMeters,
    accuracyMeters,
    speedMps,
    bearingDegrees,
    gradePct,
    surfaceType,
    vibrationRaw,
    heartRate,
    cadence,
    isPaused,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackPoint &&
          other.id == this.id &&
          other.activityId == this.activityId &&
          other.sequenceIdx == this.sequenceIdx &&
          other.timestamp == this.timestamp &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.altitudeMeters == this.altitudeMeters &&
          other.accuracyMeters == this.accuracyMeters &&
          other.speedMps == this.speedMps &&
          other.bearingDegrees == this.bearingDegrees &&
          other.gradePct == this.gradePct &&
          other.surfaceType == this.surfaceType &&
          other.vibrationRaw == this.vibrationRaw &&
          other.heartRate == this.heartRate &&
          other.cadence == this.cadence &&
          other.isPaused == this.isPaused);
}

class TrackPointsCompanion extends UpdateCompanion<TrackPoint> {
  final Value<int> id;
  final Value<String> activityId;
  final Value<int> sequenceIdx;
  final Value<DateTime> timestamp;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> altitudeMeters;
  final Value<double> accuracyMeters;
  final Value<double> speedMps;
  final Value<double> bearingDegrees;
  final Value<double> gradePct;
  final Value<String> surfaceType;
  final Value<double> vibrationRaw;
  final Value<int?> heartRate;
  final Value<int?> cadence;
  final Value<bool> isPaused;
  const TrackPointsCompanion({
    this.id = const Value.absent(),
    this.activityId = const Value.absent(),
    this.sequenceIdx = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.altitudeMeters = const Value.absent(),
    this.accuracyMeters = const Value.absent(),
    this.speedMps = const Value.absent(),
    this.bearingDegrees = const Value.absent(),
    this.gradePct = const Value.absent(),
    this.surfaceType = const Value.absent(),
    this.vibrationRaw = const Value.absent(),
    this.heartRate = const Value.absent(),
    this.cadence = const Value.absent(),
    this.isPaused = const Value.absent(),
  });
  TrackPointsCompanion.insert({
    this.id = const Value.absent(),
    required String activityId,
    required int sequenceIdx,
    required DateTime timestamp,
    required double latitude,
    required double longitude,
    required double altitudeMeters,
    required double accuracyMeters,
    required double speedMps,
    this.bearingDegrees = const Value.absent(),
    this.gradePct = const Value.absent(),
    this.surfaceType = const Value.absent(),
    this.vibrationRaw = const Value.absent(),
    this.heartRate = const Value.absent(),
    this.cadence = const Value.absent(),
    this.isPaused = const Value.absent(),
  }) : activityId = Value(activityId),
       sequenceIdx = Value(sequenceIdx),
       timestamp = Value(timestamp),
       latitude = Value(latitude),
       longitude = Value(longitude),
       altitudeMeters = Value(altitudeMeters),
       accuracyMeters = Value(accuracyMeters),
       speedMps = Value(speedMps);
  static Insertable<TrackPoint> custom({
    Expression<int>? id,
    Expression<String>? activityId,
    Expression<int>? sequenceIdx,
    Expression<DateTime>? timestamp,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? altitudeMeters,
    Expression<double>? accuracyMeters,
    Expression<double>? speedMps,
    Expression<double>? bearingDegrees,
    Expression<double>? gradePct,
    Expression<String>? surfaceType,
    Expression<double>? vibrationRaw,
    Expression<int>? heartRate,
    Expression<int>? cadence,
    Expression<bool>? isPaused,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activityId != null) 'activity_id': activityId,
      if (sequenceIdx != null) 'sequence_idx': sequenceIdx,
      if (timestamp != null) 'timestamp': timestamp,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (altitudeMeters != null) 'altitude_meters': altitudeMeters,
      if (accuracyMeters != null) 'accuracy_meters': accuracyMeters,
      if (speedMps != null) 'speed_mps': speedMps,
      if (bearingDegrees != null) 'bearing_degrees': bearingDegrees,
      if (gradePct != null) 'grade_pct': gradePct,
      if (surfaceType != null) 'surface_type': surfaceType,
      if (vibrationRaw != null) 'vibration_raw': vibrationRaw,
      if (heartRate != null) 'heart_rate': heartRate,
      if (cadence != null) 'cadence': cadence,
      if (isPaused != null) 'is_paused': isPaused,
    });
  }

  TrackPointsCompanion copyWith({
    Value<int>? id,
    Value<String>? activityId,
    Value<int>? sequenceIdx,
    Value<DateTime>? timestamp,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<double>? altitudeMeters,
    Value<double>? accuracyMeters,
    Value<double>? speedMps,
    Value<double>? bearingDegrees,
    Value<double>? gradePct,
    Value<String>? surfaceType,
    Value<double>? vibrationRaw,
    Value<int?>? heartRate,
    Value<int?>? cadence,
    Value<bool>? isPaused,
  }) {
    return TrackPointsCompanion(
      id: id ?? this.id,
      activityId: activityId ?? this.activityId,
      sequenceIdx: sequenceIdx ?? this.sequenceIdx,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitudeMeters: altitudeMeters ?? this.altitudeMeters,
      accuracyMeters: accuracyMeters ?? this.accuracyMeters,
      speedMps: speedMps ?? this.speedMps,
      bearingDegrees: bearingDegrees ?? this.bearingDegrees,
      gradePct: gradePct ?? this.gradePct,
      surfaceType: surfaceType ?? this.surfaceType,
      vibrationRaw: vibrationRaw ?? this.vibrationRaw,
      heartRate: heartRate ?? this.heartRate,
      cadence: cadence ?? this.cadence,
      isPaused: isPaused ?? this.isPaused,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (sequenceIdx.present) {
      map['sequence_idx'] = Variable<int>(sequenceIdx.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (altitudeMeters.present) {
      map['altitude_meters'] = Variable<double>(altitudeMeters.value);
    }
    if (accuracyMeters.present) {
      map['accuracy_meters'] = Variable<double>(accuracyMeters.value);
    }
    if (speedMps.present) {
      map['speed_mps'] = Variable<double>(speedMps.value);
    }
    if (bearingDegrees.present) {
      map['bearing_degrees'] = Variable<double>(bearingDegrees.value);
    }
    if (gradePct.present) {
      map['grade_pct'] = Variable<double>(gradePct.value);
    }
    if (surfaceType.present) {
      map['surface_type'] = Variable<String>(surfaceType.value);
    }
    if (vibrationRaw.present) {
      map['vibration_raw'] = Variable<double>(vibrationRaw.value);
    }
    if (heartRate.present) {
      map['heart_rate'] = Variable<int>(heartRate.value);
    }
    if (cadence.present) {
      map['cadence'] = Variable<int>(cadence.value);
    }
    if (isPaused.present) {
      map['is_paused'] = Variable<bool>(isPaused.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackPointsCompanion(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('sequenceIdx: $sequenceIdx, ')
          ..write('timestamp: $timestamp, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitudeMeters: $altitudeMeters, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('speedMps: $speedMps, ')
          ..write('bearingDegrees: $bearingDegrees, ')
          ..write('gradePct: $gradePct, ')
          ..write('surfaceType: $surfaceType, ')
          ..write('vibrationRaw: $vibrationRaw, ')
          ..write('heartRate: $heartRate, ')
          ..write('cadence: $cadence, ')
          ..write('isPaused: $isPaused')
          ..write(')'))
        .toString();
  }
}

class $WaypointPhotosTable extends WaypointPhotos
    with TableInfo<$WaypointPhotosTable, WaypointPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WaypointPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _altitudeMetersMeta = const VerificationMeta(
    'altitudeMeters',
  );
  @override
  late final GeneratedColumn<double> altitudeMeters = GeneratedColumn<double>(
    'altitude_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distanceFromStartMetersMeta =
      const VerificationMeta('distanceFromStartMeters');
  @override
  late final GeneratedColumn<double> distanceFromStartMeters =
      GeneratedColumn<double>(
        'distance_from_start_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    activityId,
    filePath,
    latitude,
    longitude,
    altitudeMeters,
    distanceFromStartMeters,
    takenAt,
    caption,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'waypoint_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<WaypointPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('altitude_meters')) {
      context.handle(
        _altitudeMetersMeta,
        altitudeMeters.isAcceptableOrUnknown(
          data['altitude_meters']!,
          _altitudeMetersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_altitudeMetersMeta);
    }
    if (data.containsKey('distance_from_start_meters')) {
      context.handle(
        _distanceFromStartMetersMeta,
        distanceFromStartMeters.isAcceptableOrUnknown(
          data['distance_from_start_meters']!,
          _distanceFromStartMetersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_distanceFromStartMetersMeta);
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_takenAtMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WaypointPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaypointPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      altitudeMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}altitude_meters'],
      )!,
      distanceFromStartMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_from_start_meters'],
      )!,
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      )!,
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
    );
  }

  @override
  $WaypointPhotosTable createAlias(String alias) {
    return $WaypointPhotosTable(attachedDatabase, alias);
  }
}

class WaypointPhoto extends DataClass implements Insertable<WaypointPhoto> {
  final String id;
  final String activityId;
  final String filePath;
  final double latitude;
  final double longitude;
  final double altitudeMeters;
  final double distanceFromStartMeters;
  final DateTime takenAt;
  final String? caption;
  const WaypointPhoto({
    required this.id,
    required this.activityId,
    required this.filePath,
    required this.latitude,
    required this.longitude,
    required this.altitudeMeters,
    required this.distanceFromStartMeters,
    required this.takenAt,
    this.caption,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['activity_id'] = Variable<String>(activityId);
    map['file_path'] = Variable<String>(filePath);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['altitude_meters'] = Variable<double>(altitudeMeters);
    map['distance_from_start_meters'] = Variable<double>(
      distanceFromStartMeters,
    );
    map['taken_at'] = Variable<DateTime>(takenAt);
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    return map;
  }

  WaypointPhotosCompanion toCompanion(bool nullToAbsent) {
    return WaypointPhotosCompanion(
      id: Value(id),
      activityId: Value(activityId),
      filePath: Value(filePath),
      latitude: Value(latitude),
      longitude: Value(longitude),
      altitudeMeters: Value(altitudeMeters),
      distanceFromStartMeters: Value(distanceFromStartMeters),
      takenAt: Value(takenAt),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
    );
  }

  factory WaypointPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaypointPhoto(
      id: serializer.fromJson<String>(json['id']),
      activityId: serializer.fromJson<String>(json['activityId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      altitudeMeters: serializer.fromJson<double>(json['altitudeMeters']),
      distanceFromStartMeters: serializer.fromJson<double>(
        json['distanceFromStartMeters'],
      ),
      takenAt: serializer.fromJson<DateTime>(json['takenAt']),
      caption: serializer.fromJson<String?>(json['caption']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'activityId': serializer.toJson<String>(activityId),
      'filePath': serializer.toJson<String>(filePath),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'altitudeMeters': serializer.toJson<double>(altitudeMeters),
      'distanceFromStartMeters': serializer.toJson<double>(
        distanceFromStartMeters,
      ),
      'takenAt': serializer.toJson<DateTime>(takenAt),
      'caption': serializer.toJson<String?>(caption),
    };
  }

  WaypointPhoto copyWith({
    String? id,
    String? activityId,
    String? filePath,
    double? latitude,
    double? longitude,
    double? altitudeMeters,
    double? distanceFromStartMeters,
    DateTime? takenAt,
    Value<String?> caption = const Value.absent(),
  }) => WaypointPhoto(
    id: id ?? this.id,
    activityId: activityId ?? this.activityId,
    filePath: filePath ?? this.filePath,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    altitudeMeters: altitudeMeters ?? this.altitudeMeters,
    distanceFromStartMeters:
        distanceFromStartMeters ?? this.distanceFromStartMeters,
    takenAt: takenAt ?? this.takenAt,
    caption: caption.present ? caption.value : this.caption,
  );
  WaypointPhoto copyWithCompanion(WaypointPhotosCompanion data) {
    return WaypointPhoto(
      id: data.id.present ? data.id.value : this.id,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      altitudeMeters: data.altitudeMeters.present
          ? data.altitudeMeters.value
          : this.altitudeMeters,
      distanceFromStartMeters: data.distanceFromStartMeters.present
          ? data.distanceFromStartMeters.value
          : this.distanceFromStartMeters,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      caption: data.caption.present ? data.caption.value : this.caption,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WaypointPhoto(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('filePath: $filePath, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitudeMeters: $altitudeMeters, ')
          ..write('distanceFromStartMeters: $distanceFromStartMeters, ')
          ..write('takenAt: $takenAt, ')
          ..write('caption: $caption')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    activityId,
    filePath,
    latitude,
    longitude,
    altitudeMeters,
    distanceFromStartMeters,
    takenAt,
    caption,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaypointPhoto &&
          other.id == this.id &&
          other.activityId == this.activityId &&
          other.filePath == this.filePath &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.altitudeMeters == this.altitudeMeters &&
          other.distanceFromStartMeters == this.distanceFromStartMeters &&
          other.takenAt == this.takenAt &&
          other.caption == this.caption);
}

class WaypointPhotosCompanion extends UpdateCompanion<WaypointPhoto> {
  final Value<String> id;
  final Value<String> activityId;
  final Value<String> filePath;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> altitudeMeters;
  final Value<double> distanceFromStartMeters;
  final Value<DateTime> takenAt;
  final Value<String?> caption;
  final Value<int> rowid;
  const WaypointPhotosCompanion({
    this.id = const Value.absent(),
    this.activityId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.altitudeMeters = const Value.absent(),
    this.distanceFromStartMeters = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.caption = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WaypointPhotosCompanion.insert({
    required String id,
    required String activityId,
    required String filePath,
    required double latitude,
    required double longitude,
    required double altitudeMeters,
    required double distanceFromStartMeters,
    required DateTime takenAt,
    this.caption = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       activityId = Value(activityId),
       filePath = Value(filePath),
       latitude = Value(latitude),
       longitude = Value(longitude),
       altitudeMeters = Value(altitudeMeters),
       distanceFromStartMeters = Value(distanceFromStartMeters),
       takenAt = Value(takenAt);
  static Insertable<WaypointPhoto> custom({
    Expression<String>? id,
    Expression<String>? activityId,
    Expression<String>? filePath,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? altitudeMeters,
    Expression<double>? distanceFromStartMeters,
    Expression<DateTime>? takenAt,
    Expression<String>? caption,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activityId != null) 'activity_id': activityId,
      if (filePath != null) 'file_path': filePath,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (altitudeMeters != null) 'altitude_meters': altitudeMeters,
      if (distanceFromStartMeters != null)
        'distance_from_start_meters': distanceFromStartMeters,
      if (takenAt != null) 'taken_at': takenAt,
      if (caption != null) 'caption': caption,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WaypointPhotosCompanion copyWith({
    Value<String>? id,
    Value<String>? activityId,
    Value<String>? filePath,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<double>? altitudeMeters,
    Value<double>? distanceFromStartMeters,
    Value<DateTime>? takenAt,
    Value<String?>? caption,
    Value<int>? rowid,
  }) {
    return WaypointPhotosCompanion(
      id: id ?? this.id,
      activityId: activityId ?? this.activityId,
      filePath: filePath ?? this.filePath,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitudeMeters: altitudeMeters ?? this.altitudeMeters,
      distanceFromStartMeters:
          distanceFromStartMeters ?? this.distanceFromStartMeters,
      takenAt: takenAt ?? this.takenAt,
      caption: caption ?? this.caption,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (altitudeMeters.present) {
      map['altitude_meters'] = Variable<double>(altitudeMeters.value);
    }
    if (distanceFromStartMeters.present) {
      map['distance_from_start_meters'] = Variable<double>(
        distanceFromStartMeters.value,
      );
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaypointPhotosCompanion(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('filePath: $filePath, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitudeMeters: $altitudeMeters, ')
          ..write('distanceFromStartMeters: $distanceFromStartMeters, ')
          ..write('takenAt: $takenAt, ')
          ..write('caption: $caption, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GearsTable extends Gears with TableInfo<$GearsTable, Gear> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GearsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gearTypeMeta = const VerificationMeta(
    'gearType',
  );
  @override
  late final GeneratedColumn<String> gearType = GeneratedColumn<String>(
    'gear_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandModelMeta = const VerificationMeta(
    'brandModel',
  );
  @override
  late final GeneratedColumn<String> brandModel = GeneratedColumn<String>(
    'brand_model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalDistanceMetersMeta =
      const VerificationMeta('totalDistanceMeters');
  @override
  late final GeneratedColumn<double> totalDistanceMeters =
      GeneratedColumn<double>(
        'total_distance_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isRetiredMeta = const VerificationMeta(
    'isRetired',
  );
  @override
  late final GeneratedColumn<bool> isRetired = GeneratedColumn<bool>(
    'is_retired',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_retired" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    gearType,
    brandModel,
    totalDistanceMeters,
    isDefault,
    isRetired,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gears';
  @override
  VerificationContext validateIntegrity(
    Insertable<Gear> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('gear_type')) {
      context.handle(
        _gearTypeMeta,
        gearType.isAcceptableOrUnknown(data['gear_type']!, _gearTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_gearTypeMeta);
    }
    if (data.containsKey('brand_model')) {
      context.handle(
        _brandModelMeta,
        brandModel.isAcceptableOrUnknown(data['brand_model']!, _brandModelMeta),
      );
    }
    if (data.containsKey('total_distance_meters')) {
      context.handle(
        _totalDistanceMetersMeta,
        totalDistanceMeters.isAcceptableOrUnknown(
          data['total_distance_meters']!,
          _totalDistanceMetersMeta,
        ),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('is_retired')) {
      context.handle(
        _isRetiredMeta,
        isRetired.isAcceptableOrUnknown(data['is_retired']!, _isRetiredMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Gear map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Gear(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      gearType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gear_type'],
      )!,
      brandModel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_model'],
      ),
      totalDistanceMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_distance_meters'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      isRetired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_retired'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GearsTable createAlias(String alias) {
    return $GearsTable(attachedDatabase, alias);
  }
}

class Gear extends DataClass implements Insertable<Gear> {
  final String id;
  final String? userId;
  final String name;
  final String gearType;
  final String? brandModel;
  final double totalDistanceMeters;
  final bool isDefault;
  final bool isRetired;
  final DateTime createdAt;
  const Gear({
    required this.id,
    this.userId,
    required this.name,
    required this.gearType,
    this.brandModel,
    required this.totalDistanceMeters,
    required this.isDefault,
    required this.isRetired,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['name'] = Variable<String>(name);
    map['gear_type'] = Variable<String>(gearType);
    if (!nullToAbsent || brandModel != null) {
      map['brand_model'] = Variable<String>(brandModel);
    }
    map['total_distance_meters'] = Variable<double>(totalDistanceMeters);
    map['is_default'] = Variable<bool>(isDefault);
    map['is_retired'] = Variable<bool>(isRetired);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GearsCompanion toCompanion(bool nullToAbsent) {
    return GearsCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      name: Value(name),
      gearType: Value(gearType),
      brandModel: brandModel == null && nullToAbsent
          ? const Value.absent()
          : Value(brandModel),
      totalDistanceMeters: Value(totalDistanceMeters),
      isDefault: Value(isDefault),
      isRetired: Value(isRetired),
      createdAt: Value(createdAt),
    );
  }

  factory Gear.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Gear(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      gearType: serializer.fromJson<String>(json['gearType']),
      brandModel: serializer.fromJson<String?>(json['brandModel']),
      totalDistanceMeters: serializer.fromJson<double>(
        json['totalDistanceMeters'],
      ),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      isRetired: serializer.fromJson<bool>(json['isRetired']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'name': serializer.toJson<String>(name),
      'gearType': serializer.toJson<String>(gearType),
      'brandModel': serializer.toJson<String?>(brandModel),
      'totalDistanceMeters': serializer.toJson<double>(totalDistanceMeters),
      'isDefault': serializer.toJson<bool>(isDefault),
      'isRetired': serializer.toJson<bool>(isRetired),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Gear copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    String? name,
    String? gearType,
    Value<String?> brandModel = const Value.absent(),
    double? totalDistanceMeters,
    bool? isDefault,
    bool? isRetired,
    DateTime? createdAt,
  }) => Gear(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    name: name ?? this.name,
    gearType: gearType ?? this.gearType,
    brandModel: brandModel.present ? brandModel.value : this.brandModel,
    totalDistanceMeters: totalDistanceMeters ?? this.totalDistanceMeters,
    isDefault: isDefault ?? this.isDefault,
    isRetired: isRetired ?? this.isRetired,
    createdAt: createdAt ?? this.createdAt,
  );
  Gear copyWithCompanion(GearsCompanion data) {
    return Gear(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      gearType: data.gearType.present ? data.gearType.value : this.gearType,
      brandModel: data.brandModel.present
          ? data.brandModel.value
          : this.brandModel,
      totalDistanceMeters: data.totalDistanceMeters.present
          ? data.totalDistanceMeters.value
          : this.totalDistanceMeters,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      isRetired: data.isRetired.present ? data.isRetired.value : this.isRetired,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Gear(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('gearType: $gearType, ')
          ..write('brandModel: $brandModel, ')
          ..write('totalDistanceMeters: $totalDistanceMeters, ')
          ..write('isDefault: $isDefault, ')
          ..write('isRetired: $isRetired, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    gearType,
    brandModel,
    totalDistanceMeters,
    isDefault,
    isRetired,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Gear &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.gearType == this.gearType &&
          other.brandModel == this.brandModel &&
          other.totalDistanceMeters == this.totalDistanceMeters &&
          other.isDefault == this.isDefault &&
          other.isRetired == this.isRetired &&
          other.createdAt == this.createdAt);
}

class GearsCompanion extends UpdateCompanion<Gear> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String> name;
  final Value<String> gearType;
  final Value<String?> brandModel;
  final Value<double> totalDistanceMeters;
  final Value<bool> isDefault;
  final Value<bool> isRetired;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const GearsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.gearType = const Value.absent(),
    this.brandModel = const Value.absent(),
    this.totalDistanceMeters = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isRetired = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GearsCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required String name,
    required String gearType,
    this.brandModel = const Value.absent(),
    this.totalDistanceMeters = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isRetired = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       gearType = Value(gearType),
       createdAt = Value(createdAt);
  static Insertable<Gear> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? gearType,
    Expression<String>? brandModel,
    Expression<double>? totalDistanceMeters,
    Expression<bool>? isDefault,
    Expression<bool>? isRetired,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (gearType != null) 'gear_type': gearType,
      if (brandModel != null) 'brand_model': brandModel,
      if (totalDistanceMeters != null)
        'total_distance_meters': totalDistanceMeters,
      if (isDefault != null) 'is_default': isDefault,
      if (isRetired != null) 'is_retired': isRetired,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GearsCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<String>? name,
    Value<String>? gearType,
    Value<String?>? brandModel,
    Value<double>? totalDistanceMeters,
    Value<bool>? isDefault,
    Value<bool>? isRetired,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return GearsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      gearType: gearType ?? this.gearType,
      brandModel: brandModel ?? this.brandModel,
      totalDistanceMeters: totalDistanceMeters ?? this.totalDistanceMeters,
      isDefault: isDefault ?? this.isDefault,
      isRetired: isRetired ?? this.isRetired,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (gearType.present) {
      map['gear_type'] = Variable<String>(gearType.value);
    }
    if (brandModel.present) {
      map['brand_model'] = Variable<String>(brandModel.value);
    }
    if (totalDistanceMeters.present) {
      map['total_distance_meters'] = Variable<double>(
        totalDistanceMeters.value,
      );
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (isRetired.present) {
      map['is_retired'] = Variable<bool>(isRetired.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GearsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('gearType: $gearType, ')
          ..write('brandModel: $brandModel, ')
          ..write('totalDistanceMeters: $totalDistanceMeters, ')
          ..write('isDefault: $isDefault, ')
          ..write('isRetired: $isRetired, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(70.0),
  );
  static const VerificationMeta _maxHeartRateMeta = const VerificationMeta(
    'maxHeartRate',
  );
  @override
  late final GeneratedColumn<int> maxHeartRate = GeneratedColumn<int>(
    'max_heart_rate',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(190),
  );
  static const VerificationMeta _ftpWattsMeta = const VerificationMeta(
    'ftpWatts',
  );
  @override
  late final GeneratedColumn<int> ftpWatts = GeneratedColumn<int>(
    'ftp_watts',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preferredUnitMeta = const VerificationMeta(
    'preferredUnit',
  );
  @override
  late final GeneratedColumn<String> preferredUnit = GeneratedColumn<String>(
    'preferred_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('metric'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    weightKg,
    maxHeartRate,
    ftpWatts,
    preferredUnit,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('max_heart_rate')) {
      context.handle(
        _maxHeartRateMeta,
        maxHeartRate.isAcceptableOrUnknown(
          data['max_heart_rate']!,
          _maxHeartRateMeta,
        ),
      );
    }
    if (data.containsKey('ftp_watts')) {
      context.handle(
        _ftpWattsMeta,
        ftpWatts.isAcceptableOrUnknown(data['ftp_watts']!, _ftpWattsMeta),
      );
    }
    if (data.containsKey('preferred_unit')) {
      context.handle(
        _preferredUnitMeta,
        preferredUnit.isAcceptableOrUnknown(
          data['preferred_unit']!,
          _preferredUnitMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      maxHeartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_heart_rate'],
      )!,
      ftpWatts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ftp_watts'],
      ),
      preferredUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_unit'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final String id;
  final String displayName;
  final double weightKg;
  final int maxHeartRate;
  final int? ftpWatts;
  final String preferredUnit;
  final DateTime createdAt;
  const UserProfile({
    required this.id,
    required this.displayName,
    required this.weightKg,
    required this.maxHeartRate,
    this.ftpWatts,
    required this.preferredUnit,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['display_name'] = Variable<String>(displayName);
    map['weight_kg'] = Variable<double>(weightKg);
    map['max_heart_rate'] = Variable<int>(maxHeartRate);
    if (!nullToAbsent || ftpWatts != null) {
      map['ftp_watts'] = Variable<int>(ftpWatts);
    }
    map['preferred_unit'] = Variable<String>(preferredUnit);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      displayName: Value(displayName),
      weightKg: Value(weightKg),
      maxHeartRate: Value(maxHeartRate),
      ftpWatts: ftpWatts == null && nullToAbsent
          ? const Value.absent()
          : Value(ftpWatts),
      preferredUnit: Value(preferredUnit),
      createdAt: Value(createdAt),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      maxHeartRate: serializer.fromJson<int>(json['maxHeartRate']),
      ftpWatts: serializer.fromJson<int?>(json['ftpWatts']),
      preferredUnit: serializer.fromJson<String>(json['preferredUnit']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String>(displayName),
      'weightKg': serializer.toJson<double>(weightKg),
      'maxHeartRate': serializer.toJson<int>(maxHeartRate),
      'ftpWatts': serializer.toJson<int?>(ftpWatts),
      'preferredUnit': serializer.toJson<String>(preferredUnit),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserProfile copyWith({
    String? id,
    String? displayName,
    double? weightKg,
    int? maxHeartRate,
    Value<int?> ftpWatts = const Value.absent(),
    String? preferredUnit,
    DateTime? createdAt,
  }) => UserProfile(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    weightKg: weightKg ?? this.weightKg,
    maxHeartRate: maxHeartRate ?? this.maxHeartRate,
    ftpWatts: ftpWatts.present ? ftpWatts.value : this.ftpWatts,
    preferredUnit: preferredUnit ?? this.preferredUnit,
    createdAt: createdAt ?? this.createdAt,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      maxHeartRate: data.maxHeartRate.present
          ? data.maxHeartRate.value
          : this.maxHeartRate,
      ftpWatts: data.ftpWatts.present ? data.ftpWatts.value : this.ftpWatts,
      preferredUnit: data.preferredUnit.present
          ? data.preferredUnit.value
          : this.preferredUnit,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('weightKg: $weightKg, ')
          ..write('maxHeartRate: $maxHeartRate, ')
          ..write('ftpWatts: $ftpWatts, ')
          ..write('preferredUnit: $preferredUnit, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    weightKg,
    maxHeartRate,
    ftpWatts,
    preferredUnit,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.weightKg == this.weightKg &&
          other.maxHeartRate == this.maxHeartRate &&
          other.ftpWatts == this.ftpWatts &&
          other.preferredUnit == this.preferredUnit &&
          other.createdAt == this.createdAt);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<String> id;
  final Value<String> displayName;
  final Value<double> weightKg;
  final Value<int> maxHeartRate;
  final Value<int?> ftpWatts;
  final Value<String> preferredUnit;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.maxHeartRate = const Value.absent(),
    this.ftpWatts = const Value.absent(),
    this.preferredUnit = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    required String id,
    required String displayName,
    this.weightKg = const Value.absent(),
    this.maxHeartRate = const Value.absent(),
    this.ftpWatts = const Value.absent(),
    this.preferredUnit = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       displayName = Value(displayName),
       createdAt = Value(createdAt);
  static Insertable<UserProfile> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<double>? weightKg,
    Expression<int>? maxHeartRate,
    Expression<int>? ftpWatts,
    Expression<String>? preferredUnit,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (weightKg != null) 'weight_kg': weightKg,
      if (maxHeartRate != null) 'max_heart_rate': maxHeartRate,
      if (ftpWatts != null) 'ftp_watts': ftpWatts,
      if (preferredUnit != null) 'preferred_unit': preferredUnit,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? displayName,
    Value<double>? weightKg,
    Value<int>? maxHeartRate,
    Value<int?>? ftpWatts,
    Value<String>? preferredUnit,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      weightKg: weightKg ?? this.weightKg,
      maxHeartRate: maxHeartRate ?? this.maxHeartRate,
      ftpWatts: ftpWatts ?? this.ftpWatts,
      preferredUnit: preferredUnit ?? this.preferredUnit,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (maxHeartRate.present) {
      map['max_heart_rate'] = Variable<int>(maxHeartRate.value);
    }
    if (ftpWatts.present) {
      map['ftp_watts'] = Variable<int>(ftpWatts.value);
    }
    if (preferredUnit.present) {
      map['preferred_unit'] = Variable<String>(preferredUnit.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('weightKg: $weightKg, ')
          ..write('maxHeartRate: $maxHeartRate, ')
          ..write('ftpWatts: $ftpWatts, ')
          ..write('preferredUnit: $preferredUnit, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ActivitiesTable activities = $ActivitiesTable(this);
  late final $TrackPointsTable trackPoints = $TrackPointsTable(this);
  late final $WaypointPhotosTable waypointPhotos = $WaypointPhotosTable(this);
  late final $GearsTable gears = $GearsTable(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final ActivitiesDao activitiesDao = ActivitiesDao(this as AppDatabase);
  late final TrackPointsDao trackPointsDao = TrackPointsDao(
    this as AppDatabase,
  );
  late final WaypointPhotosDao waypointPhotosDao = WaypointPhotosDao(
    this as AppDatabase,
  );
  late final GearsDao gearsDao = GearsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    activities,
    trackPoints,
    waypointPhotos,
    gears,
    userProfiles,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'activities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('track_points', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'activities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('waypoint_photos', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ActivitiesTableCreateCompanionBuilder =
    ActivitiesCompanion Function({
      required String id,
      Value<String?> userId,
      Value<String?> gearId,
      required String title,
      Value<String?> description,
      required String sportType,
      required String status,
      required DateTime startTime,
      Value<DateTime?> endTime,
      Value<double> totalDistanceMeters,
      Value<int> elapsedTimeSeconds,
      Value<int> movingTimeSeconds,
      Value<double> elevationGainMeters,
      Value<double> elevationLossMeters,
      Value<double> maxElevationMeters,
      Value<double> minElevationMeters,
      Value<double> avgSpeedMps,
      Value<double> maxSpeedMps,
      Value<double?> avgGapMps,
      Value<int?> avgCadence,
      Value<int?> avgHeartRate,
      Value<int?> maxHeartRate,
      Value<int?> estimatedEnergyKj,
      Value<double> gravelPercentage,
      Value<double> asphaltPercentage,
      Value<String?> primaryPhotoPath,
      Value<bool> isFavorite,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ActivitiesTableUpdateCompanionBuilder =
    ActivitiesCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<String?> gearId,
      Value<String> title,
      Value<String?> description,
      Value<String> sportType,
      Value<String> status,
      Value<DateTime> startTime,
      Value<DateTime?> endTime,
      Value<double> totalDistanceMeters,
      Value<int> elapsedTimeSeconds,
      Value<int> movingTimeSeconds,
      Value<double> elevationGainMeters,
      Value<double> elevationLossMeters,
      Value<double> maxElevationMeters,
      Value<double> minElevationMeters,
      Value<double> avgSpeedMps,
      Value<double> maxSpeedMps,
      Value<double?> avgGapMps,
      Value<int?> avgCadence,
      Value<int?> avgHeartRate,
      Value<int?> maxHeartRate,
      Value<int?> estimatedEnergyKj,
      Value<double> gravelPercentage,
      Value<double> asphaltPercentage,
      Value<String?> primaryPhotoPath,
      Value<bool> isFavorite,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ActivitiesTableReferences
    extends BaseReferences<_$AppDatabase, $ActivitiesTable, Activity> {
  $$ActivitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TrackPointsTable, List<TrackPoint>>
  _trackPointsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.trackPoints,
    aliasName: $_aliasNameGenerator(
      db.activities.id,
      db.trackPoints.activityId,
    ),
  );

  $$TrackPointsTableProcessedTableManager get trackPointsRefs {
    final manager = $$TrackPointsTableTableManager(
      $_db,
      $_db.trackPoints,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_trackPointsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WaypointPhotosTable, List<WaypointPhoto>>
  _waypointPhotosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.waypointPhotos,
    aliasName: $_aliasNameGenerator(
      db.activities.id,
      db.waypointPhotos.activityId,
    ),
  );

  $$WaypointPhotosTableProcessedTableManager get waypointPhotosRefs {
    final manager = $$WaypointPhotosTableTableManager(
      $_db,
      $_db.waypointPhotos,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_waypointPhotosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gearId => $composableBuilder(
    column: $table.gearId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sportType => $composableBuilder(
    column: $table.sportType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalDistanceMeters => $composableBuilder(
    column: $table.totalDistanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elapsedTimeSeconds => $composableBuilder(
    column: $table.elapsedTimeSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get movingTimeSeconds => $composableBuilder(
    column: $table.movingTimeSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get elevationGainMeters => $composableBuilder(
    column: $table.elevationGainMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get elevationLossMeters => $composableBuilder(
    column: $table.elevationLossMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxElevationMeters => $composableBuilder(
    column: $table.maxElevationMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minElevationMeters => $composableBuilder(
    column: $table.minElevationMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgSpeedMps => $composableBuilder(
    column: $table.avgSpeedMps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxSpeedMps => $composableBuilder(
    column: $table.maxSpeedMps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgGapMps => $composableBuilder(
    column: $table.avgGapMps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get avgCadence => $composableBuilder(
    column: $table.avgCadence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get avgHeartRate => $composableBuilder(
    column: $table.avgHeartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxHeartRate => $composableBuilder(
    column: $table.maxHeartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedEnergyKj => $composableBuilder(
    column: $table.estimatedEnergyKj,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gravelPercentage => $composableBuilder(
    column: $table.gravelPercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get asphaltPercentage => $composableBuilder(
    column: $table.asphaltPercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryPhotoPath => $composableBuilder(
    column: $table.primaryPhotoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> trackPointsRefs(
    Expression<bool> Function($$TrackPointsTableFilterComposer f) f,
  ) {
    final $$TrackPointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackPoints,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackPointsTableFilterComposer(
            $db: $db,
            $table: $db.trackPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> waypointPhotosRefs(
    Expression<bool> Function($$WaypointPhotosTableFilterComposer f) f,
  ) {
    final $$WaypointPhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.waypointPhotos,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WaypointPhotosTableFilterComposer(
            $db: $db,
            $table: $db.waypointPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gearId => $composableBuilder(
    column: $table.gearId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sportType => $composableBuilder(
    column: $table.sportType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalDistanceMeters => $composableBuilder(
    column: $table.totalDistanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elapsedTimeSeconds => $composableBuilder(
    column: $table.elapsedTimeSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get movingTimeSeconds => $composableBuilder(
    column: $table.movingTimeSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get elevationGainMeters => $composableBuilder(
    column: $table.elevationGainMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get elevationLossMeters => $composableBuilder(
    column: $table.elevationLossMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxElevationMeters => $composableBuilder(
    column: $table.maxElevationMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minElevationMeters => $composableBuilder(
    column: $table.minElevationMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgSpeedMps => $composableBuilder(
    column: $table.avgSpeedMps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxSpeedMps => $composableBuilder(
    column: $table.maxSpeedMps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgGapMps => $composableBuilder(
    column: $table.avgGapMps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get avgCadence => $composableBuilder(
    column: $table.avgCadence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get avgHeartRate => $composableBuilder(
    column: $table.avgHeartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxHeartRate => $composableBuilder(
    column: $table.maxHeartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedEnergyKj => $composableBuilder(
    column: $table.estimatedEnergyKj,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gravelPercentage => $composableBuilder(
    column: $table.gravelPercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get asphaltPercentage => $composableBuilder(
    column: $table.asphaltPercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryPhotoPath => $composableBuilder(
    column: $table.primaryPhotoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get gearId =>
      $composableBuilder(column: $table.gearId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sportType =>
      $composableBuilder(column: $table.sportType, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<double> get totalDistanceMeters => $composableBuilder(
    column: $table.totalDistanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<int> get elapsedTimeSeconds => $composableBuilder(
    column: $table.elapsedTimeSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get movingTimeSeconds => $composableBuilder(
    column: $table.movingTimeSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get elevationGainMeters => $composableBuilder(
    column: $table.elevationGainMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get elevationLossMeters => $composableBuilder(
    column: $table.elevationLossMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxElevationMeters => $composableBuilder(
    column: $table.maxElevationMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get minElevationMeters => $composableBuilder(
    column: $table.minElevationMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgSpeedMps => $composableBuilder(
    column: $table.avgSpeedMps,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxSpeedMps => $composableBuilder(
    column: $table.maxSpeedMps,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgGapMps =>
      $composableBuilder(column: $table.avgGapMps, builder: (column) => column);

  GeneratedColumn<int> get avgCadence => $composableBuilder(
    column: $table.avgCadence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get avgHeartRate => $composableBuilder(
    column: $table.avgHeartRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxHeartRate => $composableBuilder(
    column: $table.maxHeartRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estimatedEnergyKj => $composableBuilder(
    column: $table.estimatedEnergyKj,
    builder: (column) => column,
  );

  GeneratedColumn<double> get gravelPercentage => $composableBuilder(
    column: $table.gravelPercentage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get asphaltPercentage => $composableBuilder(
    column: $table.asphaltPercentage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryPhotoPath => $composableBuilder(
    column: $table.primaryPhotoPath,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> trackPointsRefs<T extends Object>(
    Expression<T> Function($$TrackPointsTableAnnotationComposer a) f,
  ) {
    final $$TrackPointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackPoints,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackPointsTableAnnotationComposer(
            $db: $db,
            $table: $db.trackPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> waypointPhotosRefs<T extends Object>(
    Expression<T> Function($$WaypointPhotosTableAnnotationComposer a) f,
  ) {
    final $$WaypointPhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.waypointPhotos,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WaypointPhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.waypointPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivitiesTable,
          Activity,
          $$ActivitiesTableFilterComposer,
          $$ActivitiesTableOrderingComposer,
          $$ActivitiesTableAnnotationComposer,
          $$ActivitiesTableCreateCompanionBuilder,
          $$ActivitiesTableUpdateCompanionBuilder,
          (Activity, $$ActivitiesTableReferences),
          Activity,
          PrefetchHooks Function({
            bool trackPointsRefs,
            bool waypointPhotosRefs,
          })
        > {
  $$ActivitiesTableTableManager(_$AppDatabase db, $ActivitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> gearId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> sportType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
                Value<double> totalDistanceMeters = const Value.absent(),
                Value<int> elapsedTimeSeconds = const Value.absent(),
                Value<int> movingTimeSeconds = const Value.absent(),
                Value<double> elevationGainMeters = const Value.absent(),
                Value<double> elevationLossMeters = const Value.absent(),
                Value<double> maxElevationMeters = const Value.absent(),
                Value<double> minElevationMeters = const Value.absent(),
                Value<double> avgSpeedMps = const Value.absent(),
                Value<double> maxSpeedMps = const Value.absent(),
                Value<double?> avgGapMps = const Value.absent(),
                Value<int?> avgCadence = const Value.absent(),
                Value<int?> avgHeartRate = const Value.absent(),
                Value<int?> maxHeartRate = const Value.absent(),
                Value<int?> estimatedEnergyKj = const Value.absent(),
                Value<double> gravelPercentage = const Value.absent(),
                Value<double> asphaltPercentage = const Value.absent(),
                Value<String?> primaryPhotoPath = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivitiesCompanion(
                id: id,
                userId: userId,
                gearId: gearId,
                title: title,
                description: description,
                sportType: sportType,
                status: status,
                startTime: startTime,
                endTime: endTime,
                totalDistanceMeters: totalDistanceMeters,
                elapsedTimeSeconds: elapsedTimeSeconds,
                movingTimeSeconds: movingTimeSeconds,
                elevationGainMeters: elevationGainMeters,
                elevationLossMeters: elevationLossMeters,
                maxElevationMeters: maxElevationMeters,
                minElevationMeters: minElevationMeters,
                avgSpeedMps: avgSpeedMps,
                maxSpeedMps: maxSpeedMps,
                avgGapMps: avgGapMps,
                avgCadence: avgCadence,
                avgHeartRate: avgHeartRate,
                maxHeartRate: maxHeartRate,
                estimatedEnergyKj: estimatedEnergyKj,
                gravelPercentage: gravelPercentage,
                asphaltPercentage: asphaltPercentage,
                primaryPhotoPath: primaryPhotoPath,
                isFavorite: isFavorite,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> userId = const Value.absent(),
                Value<String?> gearId = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                required String sportType,
                required String status,
                required DateTime startTime,
                Value<DateTime?> endTime = const Value.absent(),
                Value<double> totalDistanceMeters = const Value.absent(),
                Value<int> elapsedTimeSeconds = const Value.absent(),
                Value<int> movingTimeSeconds = const Value.absent(),
                Value<double> elevationGainMeters = const Value.absent(),
                Value<double> elevationLossMeters = const Value.absent(),
                Value<double> maxElevationMeters = const Value.absent(),
                Value<double> minElevationMeters = const Value.absent(),
                Value<double> avgSpeedMps = const Value.absent(),
                Value<double> maxSpeedMps = const Value.absent(),
                Value<double?> avgGapMps = const Value.absent(),
                Value<int?> avgCadence = const Value.absent(),
                Value<int?> avgHeartRate = const Value.absent(),
                Value<int?> maxHeartRate = const Value.absent(),
                Value<int?> estimatedEnergyKj = const Value.absent(),
                Value<double> gravelPercentage = const Value.absent(),
                Value<double> asphaltPercentage = const Value.absent(),
                Value<String?> primaryPhotoPath = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ActivitiesCompanion.insert(
                id: id,
                userId: userId,
                gearId: gearId,
                title: title,
                description: description,
                sportType: sportType,
                status: status,
                startTime: startTime,
                endTime: endTime,
                totalDistanceMeters: totalDistanceMeters,
                elapsedTimeSeconds: elapsedTimeSeconds,
                movingTimeSeconds: movingTimeSeconds,
                elevationGainMeters: elevationGainMeters,
                elevationLossMeters: elevationLossMeters,
                maxElevationMeters: maxElevationMeters,
                minElevationMeters: minElevationMeters,
                avgSpeedMps: avgSpeedMps,
                maxSpeedMps: maxSpeedMps,
                avgGapMps: avgGapMps,
                avgCadence: avgCadence,
                avgHeartRate: avgHeartRate,
                maxHeartRate: maxHeartRate,
                estimatedEnergyKj: estimatedEnergyKj,
                gravelPercentage: gravelPercentage,
                asphaltPercentage: asphaltPercentage,
                primaryPhotoPath: primaryPhotoPath,
                isFavorite: isFavorite,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({trackPointsRefs = false, waypointPhotosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (trackPointsRefs) db.trackPoints,
                    if (waypointPhotosRefs) db.waypointPhotos,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (trackPointsRefs)
                        await $_getPrefetchedData(
                          currentTable: table,
                          referencedTable: $$ActivitiesTableReferences
                              ._trackPointsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActivitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).trackPointsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.activityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (waypointPhotosRefs)
                        await $_getPrefetchedData(
                          currentTable: table,
                          referencedTable: $$ActivitiesTableReferences
                              ._waypointPhotosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActivitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).waypointPhotosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.activityId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivitiesTable,
      Activity,
      $$ActivitiesTableFilterComposer,
      $$ActivitiesTableOrderingComposer,
      $$ActivitiesTableAnnotationComposer,
      $$ActivitiesTableCreateCompanionBuilder,
      $$ActivitiesTableUpdateCompanionBuilder,
      (Activity, $$ActivitiesTableReferences),
      Activity,
      PrefetchHooks Function({bool trackPointsRefs, bool waypointPhotosRefs})
    >;
typedef $$TrackPointsTableCreateCompanionBuilder =
    TrackPointsCompanion Function({
      Value<int> id,
      required String activityId,
      required int sequenceIdx,
      required DateTime timestamp,
      required double latitude,
      required double longitude,
      required double altitudeMeters,
      required double accuracyMeters,
      required double speedMps,
      Value<double> bearingDegrees,
      Value<double> gradePct,
      Value<String> surfaceType,
      Value<double> vibrationRaw,
      Value<int?> heartRate,
      Value<int?> cadence,
      Value<bool> isPaused,
    });
typedef $$TrackPointsTableUpdateCompanionBuilder =
    TrackPointsCompanion Function({
      Value<int> id,
      Value<String> activityId,
      Value<int> sequenceIdx,
      Value<DateTime> timestamp,
      Value<double> latitude,
      Value<double> longitude,
      Value<double> altitudeMeters,
      Value<double> accuracyMeters,
      Value<double> speedMps,
      Value<double> bearingDegrees,
      Value<double> gradePct,
      Value<String> surfaceType,
      Value<double> vibrationRaw,
      Value<int?> heartRate,
      Value<int?> cadence,
      Value<bool> isPaused,
    });

final class $$TrackPointsTableReferences
    extends BaseReferences<_$AppDatabase, $TrackPointsTable, TrackPoint> {
  $$TrackPointsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ActivitiesTable _activityIdTable(_$AppDatabase db) =>
      db.activities.createAlias(
        $_aliasNameGenerator(db.trackPoints.activityId, db.activities.id),
      );

  $$ActivitiesTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<String>('activity_id')!;

    final manager = $$ActivitiesTableTableManager(
      $_db,
      $_db.activities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TrackPointsTableFilterComposer
    extends Composer<_$AppDatabase, $TrackPointsTable> {
  $$TrackPointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequenceIdx => $composableBuilder(
    column: $table.sequenceIdx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get altitudeMeters => $composableBuilder(
    column: $table.altitudeMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speedMps => $composableBuilder(
    column: $table.speedMps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bearingDegrees => $composableBuilder(
    column: $table.bearingDegrees,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gradePct => $composableBuilder(
    column: $table.gradePct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get surfaceType => $composableBuilder(
    column: $table.surfaceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get vibrationRaw => $composableBuilder(
    column: $table.vibrationRaw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get heartRate => $composableBuilder(
    column: $table.heartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cadence => $composableBuilder(
    column: $table.cadence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPaused => $composableBuilder(
    column: $table.isPaused,
    builder: (column) => ColumnFilters(column),
  );

  $$ActivitiesTableFilterComposer get activityId {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackPointsTable> {
  $$TrackPointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequenceIdx => $composableBuilder(
    column: $table.sequenceIdx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get altitudeMeters => $composableBuilder(
    column: $table.altitudeMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speedMps => $composableBuilder(
    column: $table.speedMps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bearingDegrees => $composableBuilder(
    column: $table.bearingDegrees,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gradePct => $composableBuilder(
    column: $table.gradePct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get surfaceType => $composableBuilder(
    column: $table.surfaceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get vibrationRaw => $composableBuilder(
    column: $table.vibrationRaw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get heartRate => $composableBuilder(
    column: $table.heartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cadence => $composableBuilder(
    column: $table.cadence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPaused => $composableBuilder(
    column: $table.isPaused,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActivitiesTableOrderingComposer get activityId {
    final $$ActivitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableOrderingComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackPointsTable> {
  $$TrackPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sequenceIdx => $composableBuilder(
    column: $table.sequenceIdx,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get altitudeMeters => $composableBuilder(
    column: $table.altitudeMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get speedMps =>
      $composableBuilder(column: $table.speedMps, builder: (column) => column);

  GeneratedColumn<double> get bearingDegrees => $composableBuilder(
    column: $table.bearingDegrees,
    builder: (column) => column,
  );

  GeneratedColumn<double> get gradePct =>
      $composableBuilder(column: $table.gradePct, builder: (column) => column);

  GeneratedColumn<String> get surfaceType => $composableBuilder(
    column: $table.surfaceType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get vibrationRaw => $composableBuilder(
    column: $table.vibrationRaw,
    builder: (column) => column,
  );

  GeneratedColumn<int> get heartRate =>
      $composableBuilder(column: $table.heartRate, builder: (column) => column);

  GeneratedColumn<int> get cadence =>
      $composableBuilder(column: $table.cadence, builder: (column) => column);

  GeneratedColumn<bool> get isPaused =>
      $composableBuilder(column: $table.isPaused, builder: (column) => column);

  $$ActivitiesTableAnnotationComposer get activityId {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackPointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackPointsTable,
          TrackPoint,
          $$TrackPointsTableFilterComposer,
          $$TrackPointsTableOrderingComposer,
          $$TrackPointsTableAnnotationComposer,
          $$TrackPointsTableCreateCompanionBuilder,
          $$TrackPointsTableUpdateCompanionBuilder,
          (TrackPoint, $$TrackPointsTableReferences),
          TrackPoint,
          PrefetchHooks Function({bool activityId})
        > {
  $$TrackPointsTableTableManager(_$AppDatabase db, $TrackPointsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackPointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> activityId = const Value.absent(),
                Value<int> sequenceIdx = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double> altitudeMeters = const Value.absent(),
                Value<double> accuracyMeters = const Value.absent(),
                Value<double> speedMps = const Value.absent(),
                Value<double> bearingDegrees = const Value.absent(),
                Value<double> gradePct = const Value.absent(),
                Value<String> surfaceType = const Value.absent(),
                Value<double> vibrationRaw = const Value.absent(),
                Value<int?> heartRate = const Value.absent(),
                Value<int?> cadence = const Value.absent(),
                Value<bool> isPaused = const Value.absent(),
              }) => TrackPointsCompanion(
                id: id,
                activityId: activityId,
                sequenceIdx: sequenceIdx,
                timestamp: timestamp,
                latitude: latitude,
                longitude: longitude,
                altitudeMeters: altitudeMeters,
                accuracyMeters: accuracyMeters,
                speedMps: speedMps,
                bearingDegrees: bearingDegrees,
                gradePct: gradePct,
                surfaceType: surfaceType,
                vibrationRaw: vibrationRaw,
                heartRate: heartRate,
                cadence: cadence,
                isPaused: isPaused,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String activityId,
                required int sequenceIdx,
                required DateTime timestamp,
                required double latitude,
                required double longitude,
                required double altitudeMeters,
                required double accuracyMeters,
                required double speedMps,
                Value<double> bearingDegrees = const Value.absent(),
                Value<double> gradePct = const Value.absent(),
                Value<String> surfaceType = const Value.absent(),
                Value<double> vibrationRaw = const Value.absent(),
                Value<int?> heartRate = const Value.absent(),
                Value<int?> cadence = const Value.absent(),
                Value<bool> isPaused = const Value.absent(),
              }) => TrackPointsCompanion.insert(
                id: id,
                activityId: activityId,
                sequenceIdx: sequenceIdx,
                timestamp: timestamp,
                latitude: latitude,
                longitude: longitude,
                altitudeMeters: altitudeMeters,
                accuracyMeters: accuracyMeters,
                speedMps: speedMps,
                bearingDegrees: bearingDegrees,
                gradePct: gradePct,
                surfaceType: surfaceType,
                vibrationRaw: vibrationRaw,
                heartRate: heartRate,
                cadence: cadence,
                isPaused: isPaused,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TrackPointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({activityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (activityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.activityId,
                                referencedTable: $$TrackPointsTableReferences
                                    ._activityIdTable(db),
                                referencedColumn: $$TrackPointsTableReferences
                                    ._activityIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TrackPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackPointsTable,
      TrackPoint,
      $$TrackPointsTableFilterComposer,
      $$TrackPointsTableOrderingComposer,
      $$TrackPointsTableAnnotationComposer,
      $$TrackPointsTableCreateCompanionBuilder,
      $$TrackPointsTableUpdateCompanionBuilder,
      (TrackPoint, $$TrackPointsTableReferences),
      TrackPoint,
      PrefetchHooks Function({bool activityId})
    >;
typedef $$WaypointPhotosTableCreateCompanionBuilder =
    WaypointPhotosCompanion Function({
      required String id,
      required String activityId,
      required String filePath,
      required double latitude,
      required double longitude,
      required double altitudeMeters,
      required double distanceFromStartMeters,
      required DateTime takenAt,
      Value<String?> caption,
      Value<int> rowid,
    });
typedef $$WaypointPhotosTableUpdateCompanionBuilder =
    WaypointPhotosCompanion Function({
      Value<String> id,
      Value<String> activityId,
      Value<String> filePath,
      Value<double> latitude,
      Value<double> longitude,
      Value<double> altitudeMeters,
      Value<double> distanceFromStartMeters,
      Value<DateTime> takenAt,
      Value<String?> caption,
      Value<int> rowid,
    });

final class $$WaypointPhotosTableReferences
    extends BaseReferences<_$AppDatabase, $WaypointPhotosTable, WaypointPhoto> {
  $$WaypointPhotosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ActivitiesTable _activityIdTable(_$AppDatabase db) =>
      db.activities.createAlias(
        $_aliasNameGenerator(db.waypointPhotos.activityId, db.activities.id),
      );

  $$ActivitiesTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<String>('activity_id')!;

    final manager = $$ActivitiesTableTableManager(
      $_db,
      $_db.activities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WaypointPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $WaypointPhotosTable> {
  $$WaypointPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get altitudeMeters => $composableBuilder(
    column: $table.altitudeMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceFromStartMeters => $composableBuilder(
    column: $table.distanceFromStartMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  $$ActivitiesTableFilterComposer get activityId {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WaypointPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $WaypointPhotosTable> {
  $$WaypointPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get altitudeMeters => $composableBuilder(
    column: $table.altitudeMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceFromStartMeters => $composableBuilder(
    column: $table.distanceFromStartMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActivitiesTableOrderingComposer get activityId {
    final $$ActivitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableOrderingComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WaypointPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $WaypointPhotosTable> {
  $$WaypointPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get altitudeMeters => $composableBuilder(
    column: $table.altitudeMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceFromStartMeters => $composableBuilder(
    column: $table.distanceFromStartMeters,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  $$ActivitiesTableAnnotationComposer get activityId {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WaypointPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WaypointPhotosTable,
          WaypointPhoto,
          $$WaypointPhotosTableFilterComposer,
          $$WaypointPhotosTableOrderingComposer,
          $$WaypointPhotosTableAnnotationComposer,
          $$WaypointPhotosTableCreateCompanionBuilder,
          $$WaypointPhotosTableUpdateCompanionBuilder,
          (WaypointPhoto, $$WaypointPhotosTableReferences),
          WaypointPhoto,
          PrefetchHooks Function({bool activityId})
        > {
  $$WaypointPhotosTableTableManager(
    _$AppDatabase db,
    $WaypointPhotosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WaypointPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WaypointPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WaypointPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> activityId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double> altitudeMeters = const Value.absent(),
                Value<double> distanceFromStartMeters = const Value.absent(),
                Value<DateTime> takenAt = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WaypointPhotosCompanion(
                id: id,
                activityId: activityId,
                filePath: filePath,
                latitude: latitude,
                longitude: longitude,
                altitudeMeters: altitudeMeters,
                distanceFromStartMeters: distanceFromStartMeters,
                takenAt: takenAt,
                caption: caption,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String activityId,
                required String filePath,
                required double latitude,
                required double longitude,
                required double altitudeMeters,
                required double distanceFromStartMeters,
                required DateTime takenAt,
                Value<String?> caption = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WaypointPhotosCompanion.insert(
                id: id,
                activityId: activityId,
                filePath: filePath,
                latitude: latitude,
                longitude: longitude,
                altitudeMeters: altitudeMeters,
                distanceFromStartMeters: distanceFromStartMeters,
                takenAt: takenAt,
                caption: caption,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WaypointPhotosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({activityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (activityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.activityId,
                                referencedTable: $$WaypointPhotosTableReferences
                                    ._activityIdTable(db),
                                referencedColumn:
                                    $$WaypointPhotosTableReferences
                                        ._activityIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WaypointPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WaypointPhotosTable,
      WaypointPhoto,
      $$WaypointPhotosTableFilterComposer,
      $$WaypointPhotosTableOrderingComposer,
      $$WaypointPhotosTableAnnotationComposer,
      $$WaypointPhotosTableCreateCompanionBuilder,
      $$WaypointPhotosTableUpdateCompanionBuilder,
      (WaypointPhoto, $$WaypointPhotosTableReferences),
      WaypointPhoto,
      PrefetchHooks Function({bool activityId})
    >;
typedef $$GearsTableCreateCompanionBuilder =
    GearsCompanion Function({
      required String id,
      Value<String?> userId,
      required String name,
      required String gearType,
      Value<String?> brandModel,
      Value<double> totalDistanceMeters,
      Value<bool> isDefault,
      Value<bool> isRetired,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$GearsTableUpdateCompanionBuilder =
    GearsCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<String> name,
      Value<String> gearType,
      Value<String?> brandModel,
      Value<double> totalDistanceMeters,
      Value<bool> isDefault,
      Value<bool> isRetired,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$GearsTableFilterComposer extends Composer<_$AppDatabase, $GearsTable> {
  $$GearsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gearType => $composableBuilder(
    column: $table.gearType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandModel => $composableBuilder(
    column: $table.brandModel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalDistanceMeters => $composableBuilder(
    column: $table.totalDistanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRetired => $composableBuilder(
    column: $table.isRetired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GearsTableOrderingComposer
    extends Composer<_$AppDatabase, $GearsTable> {
  $$GearsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gearType => $composableBuilder(
    column: $table.gearType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandModel => $composableBuilder(
    column: $table.brandModel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalDistanceMeters => $composableBuilder(
    column: $table.totalDistanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRetired => $composableBuilder(
    column: $table.isRetired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GearsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GearsTable> {
  $$GearsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get gearType =>
      $composableBuilder(column: $table.gearType, builder: (column) => column);

  GeneratedColumn<String> get brandModel => $composableBuilder(
    column: $table.brandModel,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalDistanceMeters => $composableBuilder(
    column: $table.totalDistanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<bool> get isRetired =>
      $composableBuilder(column: $table.isRetired, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$GearsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GearsTable,
          Gear,
          $$GearsTableFilterComposer,
          $$GearsTableOrderingComposer,
          $$GearsTableAnnotationComposer,
          $$GearsTableCreateCompanionBuilder,
          $$GearsTableUpdateCompanionBuilder,
          (Gear, BaseReferences<_$AppDatabase, $GearsTable, Gear>),
          Gear,
          PrefetchHooks Function()
        > {
  $$GearsTableTableManager(_$AppDatabase db, $GearsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GearsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GearsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GearsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> gearType = const Value.absent(),
                Value<String?> brandModel = const Value.absent(),
                Value<double> totalDistanceMeters = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> isRetired = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GearsCompanion(
                id: id,
                userId: userId,
                name: name,
                gearType: gearType,
                brandModel: brandModel,
                totalDistanceMeters: totalDistanceMeters,
                isDefault: isDefault,
                isRetired: isRetired,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> userId = const Value.absent(),
                required String name,
                required String gearType,
                Value<String?> brandModel = const Value.absent(),
                Value<double> totalDistanceMeters = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> isRetired = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => GearsCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                gearType: gearType,
                brandModel: brandModel,
                totalDistanceMeters: totalDistanceMeters,
                isDefault: isDefault,
                isRetired: isRetired,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GearsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GearsTable,
      Gear,
      $$GearsTableFilterComposer,
      $$GearsTableOrderingComposer,
      $$GearsTableAnnotationComposer,
      $$GearsTableCreateCompanionBuilder,
      $$GearsTableUpdateCompanionBuilder,
      (Gear, BaseReferences<_$AppDatabase, $GearsTable, Gear>),
      Gear,
      PrefetchHooks Function()
    >;
typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      required String id,
      required String displayName,
      Value<double> weightKg,
      Value<int> maxHeartRate,
      Value<int?> ftpWatts,
      Value<String> preferredUnit,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<String> id,
      Value<String> displayName,
      Value<double> weightKg,
      Value<int> maxHeartRate,
      Value<int?> ftpWatts,
      Value<String> preferredUnit,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxHeartRate => $composableBuilder(
    column: $table.maxHeartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ftpWatts => $composableBuilder(
    column: $table.ftpWatts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredUnit => $composableBuilder(
    column: $table.preferredUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxHeartRate => $composableBuilder(
    column: $table.maxHeartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ftpWatts => $composableBuilder(
    column: $table.ftpWatts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredUnit => $composableBuilder(
    column: $table.preferredUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get maxHeartRate => $composableBuilder(
    column: $table.maxHeartRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ftpWatts =>
      $composableBuilder(column: $table.ftpWatts, builder: (column) => column);

  GeneratedColumn<String> get preferredUnit => $composableBuilder(
    column: $table.preferredUnit,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<int> maxHeartRate = const Value.absent(),
                Value<int?> ftpWatts = const Value.absent(),
                Value<String> preferredUnit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                displayName: displayName,
                weightKg: weightKg,
                maxHeartRate: maxHeartRate,
                ftpWatts: ftpWatts,
                preferredUnit: preferredUnit,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String displayName,
                Value<double> weightKg = const Value.absent(),
                Value<int> maxHeartRate = const Value.absent(),
                Value<int?> ftpWatts = const Value.absent(),
                Value<String> preferredUnit = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                displayName: displayName,
                weightKg: weightKg,
                maxHeartRate: maxHeartRate,
                ftpWatts: ftpWatts,
                preferredUnit: preferredUnit,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ActivitiesTableTableManager get activities =>
      $$ActivitiesTableTableManager(_db, _db.activities);
  $$TrackPointsTableTableManager get trackPoints =>
      $$TrackPointsTableTableManager(_db, _db.trackPoints);
  $$WaypointPhotosTableTableManager get waypointPhotos =>
      $$WaypointPhotosTableTableManager(_db, _db.waypointPhotos);
  $$GearsTableTableManager get gears =>
      $$GearsTableTableManager(_db, _db.gears);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
}
