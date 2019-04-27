import 'package:flips/model/board/cell.dart';
import 'package:flips/widget/animation/flipWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FlipsLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final text = "Flips";
    final colors = [
      BlueCell.instance.color,
      GreenCell.instance.color,
      RedCell.instance.color,
      GreenCell.instance.color,
      BlueCell.instance.color,
    ];
    assert(text.length == colors.length);
    return Row(
      children: Iterable.generate(text.length).map((i) {
        return _LogoLetter(
          letter: text[i],
          color: colors[i],
          flipped: i == text.length - 1,
        );
      }).toList(),
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}

class _LogoLetter extends StatefulWidget {
  final String letter;
  final Color color;
  final bool flipped;

  _LogoLetter({this.letter, this.color, this.flipped});

  @override
  State<StatefulWidget> createState() {
    return _LogoLetterState(
      flipped: flipped,
    );
  }
}

class _LogoLetterState extends State<_LogoLetter> {
  bool flipped;
  Offset offset = Offset.zero;

  _LogoLetterState({this.flipped = false});

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((time) {
      setState(() {
        offset = Offset(context.size.width / 2, context.size.height / 2);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.skewX(-0.2),
        child: FlipWidget(
          child1: Text(
            widget.letter,
            style: TextStyle(
              color: widget.color,
              fontSize: 128.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          child2: Text(
            widget.letter,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 128.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          flipped: flipped,
          origin: offset,
        ),
      ),
      onTap: () {
        setState(() {
          flipped = !flipped;
        });
      },
    );
  }
}
