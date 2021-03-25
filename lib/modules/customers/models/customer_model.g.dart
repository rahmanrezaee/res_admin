// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer(
    id: json['id'] as String,
    username: json['username'] as String,
    activeOrders: json['activeOrders'] as int,
  );
}

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'username': instance.username,
      'activeOrders': instance.activeOrders,
      'id': instance.id,
    };
