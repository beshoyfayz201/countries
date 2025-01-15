import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RetryWidget extends StatelessWidget {
  final Function onRetry;
  final String msg;

  const RetryWidget({
    super.key,
    required this.onRetry,
    this.msg = 'حدث خطأ ما',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // SvgPicture.asset(AppImages.error),
        const Icon(Icons.dangerous_rounded,
            color: Color.fromARGB(255, 238, 72, 72), size: 100),
        SizedBox(
          height: 15,
          width: Get.width,
        ),
        ElevatedButton.icon(
          onPressed: () async {
            await onRetry();
          },
          label: const Text(
            '     Retry    ',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          style: const ButtonStyle(
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            backgroundColor: WidgetStatePropertyAll(Colors.indigo),
          ),
        ),
      ],
    );
  }
}
