// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final int typeId = 20;

  @override
  OrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderModel(
      id: fields[0] as String,
      merchOrderId: fields[1] as String,
      idempotencyKey: fields[2] as String,
      userId: fields[3] as String,
      status: fields[4] as OrderStatus,
      paymentStatus: fields[5] as PaymentStatus,
      deliveryStatus: fields[6] as DeliveryStatus,
      totalAmount: fields[7] as double,
      phoneNumber: fields[8] as String,
      orderReceived: fields[9] as String,
      paymentMethod: fields[10] as String,
      paymentProofUrl: fields[11] as String?,
      paymentDeclineReason: fields[12] as String?,
      totalDeliveryFee: fields[13] as int,
      extraDeliveryFee: fields[14] as int,
      extraDistanceLevel: fields[15] as String?,
      deliveryDate: fields[16] as DateTime?,
      refundStatus: fields[17] as RefundStatus,
      cancelReason: fields[18] as String?,
      refundAmount: fields[19] as double?,
      createdAt: fields[20] as DateTime,
      updatedAt: fields[21] as DateTime,
      items: (fields[22] as List).cast<OrderItems>(),
      tracking: (fields[23] as List).cast<OrderTrackingModel>(),
      refundRequest: fields[24] as RefundRequestModel?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.merchOrderId)
      ..writeByte(2)
      ..write(obj.idempotencyKey)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.paymentStatus)
      ..writeByte(6)
      ..write(obj.deliveryStatus)
      ..writeByte(7)
      ..write(obj.totalAmount)
      ..writeByte(8)
      ..write(obj.phoneNumber)
      ..writeByte(9)
      ..write(obj.orderReceived)
      ..writeByte(10)
      ..write(obj.paymentMethod)
      ..writeByte(11)
      ..write(obj.paymentProofUrl)
      ..writeByte(12)
      ..write(obj.paymentDeclineReason)
      ..writeByte(13)
      ..write(obj.totalDeliveryFee)
      ..writeByte(14)
      ..write(obj.extraDeliveryFee)
      ..writeByte(15)
      ..write(obj.extraDistanceLevel)
      ..writeByte(16)
      ..write(obj.deliveryDate)
      ..writeByte(17)
      ..write(obj.refundStatus)
      ..writeByte(18)
      ..write(obj.cancelReason)
      ..writeByte(19)
      ..write(obj.refundAmount)
      ..writeByte(20)
      ..write(obj.createdAt)
      ..writeByte(21)
      ..write(obj.updatedAt)
      ..writeByte(22)
      ..write(obj.items)
      ..writeByte(23)
      ..write(obj.tracking)
      ..writeByte(24)
      ..write(obj.refundRequest);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderTrackingModelAdapter extends TypeAdapter<OrderTrackingModel> {
  @override
  final int typeId = 21;

  @override
  OrderTrackingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderTrackingModel(
      id: fields[0] as String,
      orderId: fields[1] as String,
      type: fields[2] as TrackingType,
      title: fields[3] as String,
      message: fields[4] as String?,
      timestamp: fields[5] as DateTime?,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, OrderTrackingModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.message)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderTrackingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RefundRequestModelAdapter extends TypeAdapter<RefundRequestModel> {
  @override
  final int typeId = 22;

  @override
  RefundRequestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RefundRequestModel(
      id: fields[0] as String,
      orderId: fields[1] as String,
      userId: fields[2] as String,
      accountName: fields[3] as String,
      accountNumber: fields[4] as String?,
      phoneNumber: fields[5] as String?,
      reason: fields[6] as String?,
      status: fields[7] as RefundStatus,
      adminNote: fields[8] as String?,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RefundRequestModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.accountName)
      ..writeByte(4)
      ..write(obj.accountNumber)
      ..writeByte(5)
      ..write(obj.phoneNumber)
      ..writeByte(6)
      ..write(obj.reason)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.adminNote)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RefundRequestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderStatusAdapter extends TypeAdapter<OrderStatus> {
  @override
  final int typeId = 24;

  @override
  OrderStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OrderStatus.pendingPayment;
      case 1:
        return OrderStatus.toBeDelivered;
      case 2:
        return OrderStatus.completed;
      case 3:
        return OrderStatus.cancelled;
      case 4:
        return OrderStatus.unknown;
      default:
        return OrderStatus.pendingPayment;
    }
  }

  @override
  void write(BinaryWriter writer, OrderStatus obj) {
    switch (obj) {
      case OrderStatus.pendingPayment:
        writer.writeByte(0);
        break;
      case OrderStatus.toBeDelivered:
        writer.writeByte(1);
        break;
      case OrderStatus.completed:
        writer.writeByte(2);
        break;
      case OrderStatus.cancelled:
        writer.writeByte(3);
        break;
      case OrderStatus.unknown:
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
  final int typeId = 25;

  @override
  PaymentStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PaymentStatus.pending;
      case 1:
        return PaymentStatus.screenshotSent;
      case 2:
        return PaymentStatus.failed;
      case 3:
        return PaymentStatus.confirmed;
      case 4:
        return PaymentStatus.declined;
      case 5:
        return PaymentStatus.refunded;
      case 6:
        return PaymentStatus.unknown;
      default:
        return PaymentStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, PaymentStatus obj) {
    switch (obj) {
      case PaymentStatus.pending:
        writer.writeByte(0);
        break;
      case PaymentStatus.screenshotSent:
        writer.writeByte(1);
        break;
      case PaymentStatus.failed:
        writer.writeByte(2);
        break;
      case PaymentStatus.confirmed:
        writer.writeByte(3);
        break;
      case PaymentStatus.declined:
        writer.writeByte(4);
        break;
      case PaymentStatus.refunded:
        writer.writeByte(5);
        break;
      case PaymentStatus.unknown:
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
  final int typeId = 26;

  @override
  DeliveryStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DeliveryStatus.notScheduled;
      case 1:
        return DeliveryStatus.scheduled;
      case 2:
        return DeliveryStatus.delivered;
      case 3:
        return DeliveryStatus.unknown;
      default:
        return DeliveryStatus.notScheduled;
    }
  }

  @override
  void write(BinaryWriter writer, DeliveryStatus obj) {
    switch (obj) {
      case DeliveryStatus.notScheduled:
        writer.writeByte(0);
        break;
      case DeliveryStatus.scheduled:
        writer.writeByte(1);
        break;
      case DeliveryStatus.delivered:
        writer.writeByte(2);
        break;
      case DeliveryStatus.unknown:
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
  final int typeId = 27;

  @override
  RefundStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RefundStatus.notStarted;
      case 1:
        return RefundStatus.pending;
      case 2:
        return RefundStatus.approved;
      case 3:
        return RefundStatus.rejected;
      case 4:
        return RefundStatus.unknown;
      default:
        return RefundStatus.notStarted;
    }
  }

  @override
  void write(BinaryWriter writer, RefundStatus obj) {
    switch (obj) {
      case RefundStatus.notStarted:
        writer.writeByte(0);
        break;
      case RefundStatus.pending:
        writer.writeByte(1);
        break;
      case RefundStatus.approved:
        writer.writeByte(2);
        break;
      case RefundStatus.rejected:
        writer.writeByte(3);
        break;
      case RefundStatus.unknown:
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

class TrackingTypeAdapter extends TypeAdapter<TrackingType> {
  @override
  final int typeId = 23;

  @override
  TrackingType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TrackingType.paymentSubmitted;
      case 1:
        return TrackingType.paymentConfirmed;
      case 2:
        return TrackingType.deliveryScheduled;
      case 3:
        return TrackingType.confirmed;
      case 4:
        return TrackingType.cancelled;
      case 5:
        return TrackingType.refunded;
      case 6:
        return TrackingType.unknown;
      default:
        return TrackingType.paymentSubmitted;
    }
  }

  @override
  void write(BinaryWriter writer, TrackingType obj) {
    switch (obj) {
      case TrackingType.paymentSubmitted:
        writer.writeByte(0);
        break;
      case TrackingType.paymentConfirmed:
        writer.writeByte(1);
        break;
      case TrackingType.deliveryScheduled:
        writer.writeByte(2);
        break;
      case TrackingType.confirmed:
        writer.writeByte(3);
        break;
      case TrackingType.cancelled:
        writer.writeByte(4);
        break;
      case TrackingType.refunded:
        writer.writeByte(5);
        break;
      case TrackingType.unknown:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackingTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
