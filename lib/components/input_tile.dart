import 'package:flutter/material.dart';

class InputTile extends StatelessWidget {
  final String title;
  final String value;
  final Function updateFunc;

  const InputTile({
    Key? key,
    required this.title,
    this.value = '',
    required this.updateFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return ListTile(
      onTap: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black12
                        : Colors.white12,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Enter your new $title",
                      border: InputBorder.none,
                    ),
                    controller: controller,
                    autofocus: true,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () async {
                        if (controller.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(
                                  child: Text(
                                "Please enter a valid $title",
                                style: const TextStyle(fontSize: 18),
                              )),
                            ),
                          );
                          return;
                        }
                        var response = await updateFunc(controller.text);
                        if (response.success == true) {
                          Navigator.pop(context, 'Update');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(
                                  child: Text(
                                response.messsage ?? 'Unknown error',
                                style: const TextStyle(fontSize: 18),
                              )),
                            ),
                          );
                        }
                      },
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      title: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black12
              : Colors.white12,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }
}
