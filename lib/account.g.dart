// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrenciesAdapter extends TypeAdapter<Currencies> {
  @override
  final int typeId = 1;

  @override
  Currencies read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Currencies.USD;
      case 1:
        return Currencies.EUR;
      case 2:
        return Currencies.PLN;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, Currencies obj) {
    switch (obj) {
      case Currencies.USD:
        writer.writeByte(0);
        break;
      case Currencies.EUR:
        writer.writeByte(1);
        break;
      case Currencies.PLN:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrenciesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AccountAdapter extends TypeAdapter<Account> {
  @override
  final int typeId = 0;

  @override
  Account read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Account(
      fields[0] as String,
      fields[1] as Currencies,
    )..cashAmount = fields[2] as double;
  }

  @override
  void write(BinaryWriter writer, Account obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.currency)
      ..writeByte(2)
      ..write(obj.cashAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
