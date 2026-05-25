import 'dart:typed_data';

class Employee {
  final int?    id;
  final String  name;
  final String  employeeCode;   // e.g. "ID-00347"
  final String? department;
  final String? avatarPath;
  final List<double> embedding; // 128-dim FaceNet vector
  final DateTime registeredAt;

  const Employee({
    this.id,
    required this.name,
    required this.employeeCode,
    this.department,
    this.avatarPath,
    required this.embedding,
    required this.registeredAt,
  });

  // ── Serialization ──────────────────────────────────────────────────────────

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'name':          name,
    'employee_code': employeeCode,
    'department':    department,
    'avatar_path':   avatarPath,
    'embedding':     _embeddingToBytes(embedding),
    'registered_at': registeredAt.toIso8601String(),
  };

  factory Employee.fromMap(Map<String, dynamic> map) => Employee(
    id:           map['id'] as int?,
    name:         map['name'] as String,
    employeeCode: map['employee_code'] as String,
    department:   map['department'] as String?,
    avatarPath:   map['avatar_path'] as String?,
    embedding:    _bytesToEmbedding(map['embedding'] as Uint8List),
    registeredAt: DateTime.parse(map['registered_at'] as String),
  );

  Employee copyWith({
    int?          id,
    String?       name,
    String?       employeeCode,
    String?       department,
    String?       avatarPath,
    List<double>? embedding,
    DateTime?     registeredAt,
  }) => Employee(
    id:           id           ?? this.id,
    name:         name         ?? this.name,
    employeeCode: employeeCode ?? this.employeeCode,
    department:   department   ?? this.department,
    avatarPath:   avatarPath   ?? this.avatarPath,
    embedding:    embedding    ?? this.embedding,
    registeredAt: registeredAt ?? this.registeredAt,
  );

  // ── Embedding byte helpers ─────────────────────────────────────────────────

  static Uint8List _embeddingToBytes(List<double> embedding) {
    final f32 = Float32List.fromList(embedding);
    return Uint8List.view(f32.buffer);
  }

  static List<double> _bytesToEmbedding(Uint8List bytes) =>
      Float32List.view(bytes.buffer).toList();

  @override
  String toString() => 'Employee($employeeCode · $name)';
}