import 'dart:async';
import 'dart:io';
import '../models/device.dart';

class UDPScan {
  RawDatagramSocket? _socket;

  final List<Device> _devices = [];
  final StreamController<List<Device>> _controller =
      StreamController.broadcast();

  Stream<List<Device>> get stream => _controller.stream;

  Future<void> startScan() async {
    _devices.clear();

    _socket = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      0,
    );

    print("UDP监听端口: ${_socket!.port}");

    _socket!.listen((event) {
      if (event != RawSocketEvent.read) return;

      final dg = _socket!.receive();
      if (dg == null) return;

      final msg = String.fromCharCodes(dg.data);

      print("收到UDP: $msg");

      if (msg.startsWith("RF_DEVICE")) {
        final parts = msg.split("|");

        String name = "";
        String ip = "";

        for (final p in parts) {
          if (p.startsWith("name=")) {
            name = p.replaceFirst("name=", "");
          }
          if (p.startsWith("ip=")) {
            ip = p.replaceFirst("ip=", "");
          }
        }

        final device = Device(name: name, ip: ip);

        if (!_devices.any((d) => d.ip == device.ip)) {
          _devices.add(device);

          print("设备加入: ${device.name} ${device.ip}");
          print("设备数量: ${_devices.length}");

          _controller.add(List.from(_devices));
        }
      }
    });

    _sendDiscover();

    // 定时扫描
    Timer.periodic(const Duration(seconds: 2), (_) {
      _sendDiscover();
    });
  }

  void _sendDiscover() {
    const msg = "DISCOVER_RF";

    try {
      _socket?.send(
        msg.codeUnits,
        InternetAddress("255.255.255.255"),
        4210,
      );

      print("发送DISCOVER_RF");
    } catch (e) {
      print("发送失败: $e");
    }
  }

  void stop() {
    _socket?.close();
    _controller.close();
  }
}