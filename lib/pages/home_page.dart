import 'package:flutter/material.dart';
import '../models/device.dart';
import '../services/udp_scan.dart';
import 'device_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UDPScan scanner = UDPScan();

  List<Device> devices = [];

  @override
  void initState() {
    super.initState();

    scanner.startScan();

    scanner.stream.listen((list) {
      print("UI刷新: ${list.length}");

      setState(() {
        devices = list;
      });
    });
  }

  @override
  void dispose() {
    scanner.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("射频管家设备"),
      ),
      body: devices.isEmpty
          ? const Center(
              child: Text("正在扫描设备..."),
            )
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, i) {
                final d = devices[i];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.router),
                    title: Text(d.name),
                    subtitle: Text(d.ip),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DevicePage(device: d),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}