// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderItemsAdapter extends TypeAdapter<OrderItems> {
  @override
  final int typeId = 10;

  @override
  OrderItems read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderItems(
      name: fields[0] as String,
      packagingSize: fields[1] as int,
      image: fields[2] as String,
      quantity: fields[3] as int,
      price: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, OrderItems obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.packagingSize)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderTrackingStepAdapter extends TypeAdapter<OrderTrackingStep> {
  @override
  final int typeId = 11;

  @override
  OrderTrackingStep read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderTrackingStep(
      title: fields[0] as String,
      date: fields[1] as String?,
      completed: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, OrderTrackingStep obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.completed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderTrackingStepAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderDataAdapter extends TypeAdapter<OrderData> {
  @override
  final int typeId = 12;

  @override
  OrderData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderData(
      id: fields[0] as String,
      userId: fields[1] as String,
      phoneNumber: fields[2] as String,
      location: fields[3] as String,
      totalAmount: fields[4] as int,
      deliverystatus: fields[5] as String,
      idempotencyKey: fields[6] as String,
      paymentstatus: fields[7] as String,
      refundstatus: fields[8] as String,
      merchOrderId: fields[9] as String,
      orderrecived: fields[10] as String,
      paymentMethod: fields[11] as String,
      cancelReason: fields[12] as String,
      paymentProofUrl: fields[13] as String,
      deliveryFee: fields[14] as int,
      deliveryDate: fields[15] as String?,
      status: fields[16] as String,
      createdAt: fields[17] as DateTime,
      updatedAt: fields[18] as DateTime,
      items: (fields[19] as List).cast<OrderItems>(),
      tracking: (fields[20] as List).cast<OrderTrackingStep>(),
    );
  }

  @override
  void write(BinaryWriter writer, OrderData obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.totalAmount)
      ..writeByte(5)
      ..write(obj.deliverystatus)
      ..writeByte(6)
      ..write(obj.idempotencyKey)
      ..writeByte(7)
      ..write(obj.paymentstatus)
      ..writeByte(8)
      ..write(obj.refundstatus)
      ..writeByte(9)
      ..write(obj.merchOrderId)
      ..writeByte(10)
      ..write(obj.orderrecived)
      ..writeByte(11)
      ..write(obj.paymentMethod)
      ..writeByte(12)
      ..write(obj.cancelReason)
      ..writeByte(13)
      ..write(obj.paymentProofUrl)
      ..writeByte(14)
      ..write(obj.deliveryFee)
      ..writeByte(15)
      ..write(obj.deliveryDate)
      ..writeByte(16)
      ..write(obj.status)
      ..writeByte(17)
      ..write(obj.createdAt)
      ..writeByte(18)
      ..write(obj.updatedAt)
      ..writeByte(19)
      ..write(obj.items)
      ..writeByte(20)
      ..write(obj.tracking);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderStatusAdapter extends TypeAdapter<OrderStatus> {
  @override
  final int typeId = 13;

  @override
  OrderStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OrderStatus.PENDING_PAYMENT;
      case 1:
        return OrderStatus.TO_BE_DELIVERED;
      case 2:
        return OrderStatus.COMPLETED;
      case 3:
        return OrderStatus.CANCELLED;
      case 4:
        return OrderStatus.UNKNOWN;
      default:
        return OrderStatus.PENDING_PAYMENT;
    }
  }

  @override
  void write(BinaryWriter writer, OrderStatus obj) {
    switch (obj) {
      case OrderStatus.PENDING_PAYMENT:
        writer.writeByte(0);
        break;
      case OrderStatus.TO_BE_DELIVERED:
        writer.writeByte(1);
        break;
      case OrderStatus.COMPLETED:
        writer.writeByte(2);
        break;
      case OrderStatus.CANCELLED:
        writer.writeByte(3);
        break;
      case OrderStatus.UNKNOWN:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PaymentStatusAdapter extends TypeAdapter<PaymentStatus> {
  @override
  final int typeId = 14;

  @override
  PaymentStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PaymentStatus.PENDING;
      case 1:
        return PaymentStatus.SCREENSHOT_SENT;
      case 2:
        return PaymentStatus.FAILED;
      case 3:
        return PaymentStatus.CONFIRMED;
      case 4:
        return PaymentStatus.DECLINED;
      case 5:
        return PaymentStatus.REFUNDED;
      case 6:
        return PaymentStatus.UNKNOWN;
      default:
        return PaymentStatus.PENDING;
    }
  }

  @override
  void write(BinaryWriter writer, PaymentStatus obj) {
    switch (obj) {
      case PaymentStatus.PENDING:
        writer.writeByte(0);
        break;
      case PaymentStatus.SCREENSHOT_SENT:
        writer.writeByte(1);
        break;
      case PaymentStatus.FAILED:
        writer.writeByte(2);
        break;
      case PaymentStatus.CONFIRMED:
        writer.writeByte(3);
        break;
      case PaymentStatus.DECLINED:
        writer.writeByte(4);
        break;
      case PaymentStatus.REFUNDED:
        writer.writeByte(5);
        break;
      case PaymentStatus.UNKNOWN:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeliveryStatusAdapter extends TypeAdapter<DeliveryStatus> {
  @override
  final int typeId = 15;

  @override
  DeliveryStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DeliveryStatus.NOT_SCHEDULED;
      case 1:
        return DeliveryStatus.SCHEDULED;
      case 2:
        return DeliveryStatus.DELIVERED;
      case 3:
        return DeliveryStatus.UNKNOWN;
      default:
        return DeliveryStatus.NOT_SCHEDULED;
    }
  }

  @override
  void write(BinaryWriter writer, DeliveryStatus obj) {
    switch (obj) {
      case DeliveryStatus.NOT_SCHEDULED:
        writer.writeByte(0);
        break;
      case DeliveryStatus.SCHEDULED:
        writer.writeByte(1);
        break;
      case DeliveryStatus.DELIVERED:
        writer.writeByte(2);
        break;
      case DeliveryStatus.UNKNOWN:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RefundStatusAdapter extends TypeAdapter<RefundStatus> {
  @override
  final int typeId = 16;

  @override
  RefundStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RefundStatus.NOT_STARTED;
      case 1:
        return RefundStatus.PENDING;
      case 2:
        return RefundStatus.APPROVED;
      case 3:
        return RefundStatus.REJECTED;
      case 4:
        return RefundStatus.UNKNOWN;
      default:
        return RefundStatus.NOT_STARTED;
    }
  }

  @override
  void write(BinaryWriter writer, RefundStatus obj) {
    switch (obj) {
      case RefundStatus.NOT_STARTED:
        writer.writeByte(0);
        break;
      case RefundStatus.PENDING:
        writer.writeByte(1);
        break;
      case RefundStatus.APPROVED:
        writer.writeByte(2);
        break;
      case RefundStatus.REJECTED:
        writer.writeByte(3);
        break;
      case RefundStatus.UNKNOWN:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RefundStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
