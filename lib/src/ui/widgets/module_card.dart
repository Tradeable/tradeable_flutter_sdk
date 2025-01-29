import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/module.model.dart';
import 'package:tradeable_flutter_sdk/src/utils/color_util.dart';

class ModuleCard extends StatelessWidget {
  final ModuleModel moduleModel;
  final VoidCallback onClick;

  const ModuleCard(
      {super.key, required this.moduleModel, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: getColorFromHex(moduleModel.bgColor ?? "FF81C1BD"),
            borderRadius: BorderRadius.circular(8)),
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
                    Text(moduleModel.description,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        )),
                    Text(moduleModel.note ?? "",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        )),
                  ],
                )),
            Flexible(
              flex: 3,
              child: moduleModel.iconUrl != null
                  ? Image.network(
                      moduleModel.iconUrl!,
                      fit: BoxFit.cover,
                      width: 64,
                      height: 64,
                    )
                  : Image.asset(
                      "assets/default_module_icon.png",
                      package: 'tradeable_learn/lib',
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
