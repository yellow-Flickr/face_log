import 'package:face_log/employee.dart';
import 'package:flutter/material.dart';

// ─── Attendance Status ────────────────────────────────────────────────────────

/// Cut-off hour (24h) after which a check-in is marked Late.
const int kLateThresholdHour = 9;

enum AttendanceStatus {
  punctual,
  late;

  String get label => switch (this) {
    AttendanceStatus.punctual => 'Punctual',
    AttendanceStatus.late     => 'Late',
  };

  static AttendanceStatus forTime(DateTime time) =>
      time.hour < kLateThresholdHour
          ? AttendanceStatus.punctual
          : AttendanceStatus.late;

  static AttendanceStatus fromString(String s) =>
      AttendanceStatus.values.firstWhere((e) => e.name == s);
}

// ─── Attendance Record ────────────────────────────────────────────────────────

class AttendanceRecord {
  final int?              id;
  final int               employeeDbId;  // FK → employees.id
  final String            employeeCode;  // denormalized for fast display
  final String            employeeName;  // denormalized for fast display
  final DateTime          checkInTime;
  final double            matchConfidence; // 0.0–1.0
  final AttendanceStatus  status;
  final bool              isSynced;
  final String?           notes;

  const AttendanceRecord({
    this.id,
    required this.employeeDbId,
    required this.employeeCode,
    required this.employeeName,
    required this.checkInTime,
    required this.matchConfidence,
    required this.status,
    this.isSynced = false,
    this.notes,
  });

  // ── Serialization ──────────────────────────────────────────────────────────

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'employee_db_id':  employeeDbId,
    'employee_code':   employeeCode,
    'employee_name':   employeeName,
    'check_in_time':   checkInTime.toIso8601String(),
    'match_confidence': matchConfidence,
    'status':          status.name,
    'is_synced':       isSynced ? 1 : 0,
    'notes':           notes,
  };

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) => AttendanceRecord(
    id:               map['id'] as int?,
    employeeDbId:     map['employee_db_id'] as int,
    employeeCode:     map['employee_code'] as String,
    employeeName:     map['employee_name'] as String,
    checkInTime:      DateTime.parse(map['check_in_time'] as String),
    matchConfidence:  (map['match_confidence'] as num).toDouble(),
    status:           AttendanceStatus.fromString(map['status'] as String),
    isSynced:         (map['is_synced'] as int) == 1,
    notes:            map['notes'] as String?,
  );

  AttendanceRecord copyWith({bool? isSynced}) => AttendanceRecord(
    id:               id,
    employeeDbId:     employeeDbId,
    employeeCode:     employeeCode,
    employeeName:     employeeName,
    checkInTime:      checkInTime,
    matchConfidence:  matchConfidence,
    status:           status,
    isSynced:         isSynced ?? this.isSynced,
    notes:            notes,
  );
}

// ─── Recognition Result ────────────────────────────────────────────────────────

/// Returned by RecognitionService after comparing a query embedding
/// against the enrolled employee embeddings.
class RecognitionResult {
  final Employee? match;
  final double    confidence;  // cosine similarity 0.0–1.0
  final bool      isAboveThreshold;
  final Rect      faceRect;    // in camera preview coordinates

  const RecognitionResult({
    required this.match,
    required this.confidence,
    required this.isAboveThreshold,
    required this.faceRect,
  });

  bool get hasMatch => isAboveThreshold && match != null;

  static const RecognitionResult empty = RecognitionResult(
    match:            null,
    confidence:       0,
    isAboveThreshold: false,
    faceRect:         Rect.zero,
  );
}