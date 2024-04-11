import 'package:flutter/material.dart';

class MultiLineInputTile extends StatelessWidget {
  final String title;
  final String value;
  final Function updateFunc;

  const MultiLineInputTile({
    Key? key,
    required this.title,
    this.value = '',
    required this.updateFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              final controller = TextEditingController(text: value);
              return Dialog(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black12
                                  : Colors.white12,
                        ),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Enter your new description",
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: controller,
                          autofocus: true,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
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
                              await updateFunc(controller.text);
                              Navigator.pop(context, 'Update');
                            },
                            child: const Text('Update'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
      },
      title: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black12
              : Colors.white12,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  // textAlign: TextAlign.left,
                ),
                Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
