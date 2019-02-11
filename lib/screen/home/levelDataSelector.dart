import 'package:flips/main/theme.dart';
import 'package:flips/screen/home/levelDataBloc.dart';
import 'package:flips/screen/home/events.dart';
import 'package:flips/screen/level/levelData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LevelDataSelector extends StatelessWidget {
  final double fontSize = 32.0;

  @override
  Widget build(BuildContext context) {
    LevelDataBloc levelDataBloc =
        LevelDataInheritedWidget.of(context).levelDataBloc;
    SchedulerBinding.instance.scheduleFrameCallback(
        (timestamp) => levelDataBloc.eventSink.add(PushEvent()));
    return StreamBuilder(
      stream: levelDataBloc.levelDataStream,
      builder: (BuildContext context, AsyncSnapshot<LevelData> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        return DropdownButtonHideUnderline(
          child: Column(
            children: [
              Row(
                children: [
                  buildNumberSelector(
                      context,
                      "Width",
                      snapshot.data.width,
                      (selectedWidth) => levelDataBloc.eventSink
                          .add(WidthEvent(selectedWidth))),
                  SizedBox(
                    width: fontSize,
                  ),
                  buildNumberSelector(
                      context,
                      "Height",
                      snapshot.data.height,
                      (selectedHeight) => levelDataBloc.eventSink
                          .add(HeightEvent(selectedHeight))),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildNumberSelector(
      BuildContext context, String label, int value, ValueChanged onChanged) {
    return Column(
      children: [
        Text(
          label,
          style: flipsTheme.textTheme.subhead.copyWith(
            color: flipsTheme.accentColor,
            fontSize: fontSize,
          ),
        ),
        SizedBox(
          height: fontSize / 2,
        ),
        Container(
          color: flipsTheme.accentColor,
          child: DropdownButton<int>(
            iconSize: fontSize,
            items: LevelDataBloc.heightOptions.map((item) {
              return DropdownMenuItem<int>(
                child: Container(
                  child: Text(item.toString()),
                  margin: EdgeInsets.only(left: 16.0),
                ),
                value: item,
              );
            }).toList(),
            onChanged: onChanged,
            style: flipsTheme.textTheme.subhead.copyWith(
              fontSize: fontSize,
            ),
            value: value,
          ),
        ),
      ],
    );
  }
}
