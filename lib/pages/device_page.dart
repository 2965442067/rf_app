import 'package:flutter/material.dart';
import '../models/device.dart';

class DevicePage extends StatefulWidget {
  final Device device;

  const DevicePage({super.key, required this.device});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  bool online = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== 设备信息卡片 =====
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.router, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      widget.device.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text("IP: ${widget.device.ip}"),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          online ? Icons.circle : Icons.circle_outlined,
                          color: online ? Colors.green : Colors.grey,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(online ? "在线" : "离线"),
                      ],
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ===== 状态区域 =====
            Card(
              child: ListTile(
                leading: const Icon(Icons.wifi),
                title: const Text("连接状态"),
                subtitle: Text(online ? "已连接设备" : "未连接"),
                trailing: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      online = !online;
                    });
                  },
                  child: const Text("测试"),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ===== 控制区（后续接ESP）=====
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 10),

                  _buildSignalRow("大门-解锁", "433MHz", "F4", 1),
                  _buildSignalRow("车库-开启", "433MHz", "F4", 2),
                  _buildSignalRow("卧室灯", "315MHz", "F3", 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSignalRow(
    String name,
    String band,
    String freq,
    int id,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // ===== 名称 =====
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "$band / $freq",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // ===== 发射 =====
            IconButton(
              icon: const Icon(Icons.send, color: Colors.blue),
              onPressed: () {
                _sendSignal(id);
              },
            ),

            // ===== 设置 =====
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.orange),
              onPressed: () {
                _settingSignal(id);
              },
            ),

            // ===== 删除 =====
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteSignal(id);
              },
            ),
          ],
        ),
      ),
    );
  }
  void _sendSignal(int id) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("发送信号 ID: $id")),
    );

    // TODO: 调ESP接口
  }

  void _settingSignal(int id) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("设置 ID: $id")),
    );
  }

  void _deleteSignal(int id) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("删除 ID: $id")),
    );
  }
  Widget _buildControlBtn(String title, IconData icon) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
      ),
      onPressed: () {
        // TODO: 后面接ESP接口
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("点击: $title")),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}