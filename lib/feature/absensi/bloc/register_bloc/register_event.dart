import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RegisterAttempt extends RegisterEvent {
  const RegisterAttempt({required this.capturedImages});
  final Map<String, Uint8List> capturedImages;

  @override
  List<Object> get props => [capturedImages];
}
