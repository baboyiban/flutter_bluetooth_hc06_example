import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:layout/HomePage.dart';
import 'package:layout/provider/StatusConexaoProvider.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? isBluetooth;
  final bool? isDiscovering;
  final Function? onPress;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.isBluetooth,
    this.isDiscovering,
    this.onPress,
  }) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100.0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))),
      title: Center(
          child: Row(
        children: [
          Text(title!, textAlign: TextAlign.center),
        ],
      )),
      backgroundColor: const Color.fromRGBO(237, 46, 39, 1),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: SizedBox(
            height: 60,
            width: 60,
            child: Consumer<StatusConexaoProvider>(
                builder: (context, statusConnectionProvider, widget) {
              return (isBluetooth!
                  ? ElevatedButton(
                      onPressed: statusConnectionProvider.device != null
                          ? () {
                              Provider.of<StatusConexaoProvider>(context,
                                      listen: false)
                                  .setDevice(null);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      settings: const RouteSettings(name: '/'),
                                      builder: (context) => const HomePage()));
                            }
                          : onPress!(),
                      child: Icon(statusConnectionProvider.device != null
                          ? Icons.bluetooth_connected
                          : Icons.bluetooth_disabled),
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor:
                              statusConnectionProvider.device != null
                                  ? const Color.fromRGBO(15, 171, 118, 1)
                                  : Colors.black),
                    )
                  : const SizedBox.shrink());
            }),
          ),
        )
      ],
    );
  }
}
