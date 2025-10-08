import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_user_model.dart';

class TopicTile extends StatelessWidget {
  final TopicUserModel moduleModel;
  final VoidCallback onClick;
  final Color cardColor;

  const TopicTile({
    super.key,
    required this.moduleModel,
    required this.onClick,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: cardColor, borderRadius: BorderRadius.circular(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(moduleModel.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        )),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                        moduleModel.description.trim().isEmpty
                            ? "dolor sit amet, consectetur"
                            : moduleModel.description,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        )),
                    SizedBox(
                      height: 2,
                    ),
                    moduleModel.progress.completed == 0
                        ? Text("Not completed yet",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ))
                        : Text(
                            "${moduleModel.progress.completed}/${moduleModel.progress.total} completed",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            )),
                  ],
                )),
            Flexible(
              flex: 3,
              child: moduleModel.logo.url.isNotEmpty
                  ? Image.network(
                      moduleModel.logo.url,
                      fit: BoxFit.cover,
                      width: 64,
                      height: 64,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        "assets/images/default_module_icon.png",
                        package: 'tradeable_flutter_sdk/lib',
                        height: 64,
                        width: 64,
                      ),
                    )
                  : Image.asset(
                      "assets/images/default_module_icon.png",
                      package: 'tradeable_flutter_sdk/lib',
                      height: 64,
                      width: 64,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
