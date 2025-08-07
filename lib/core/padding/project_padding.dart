import 'package:flutter/widgets.dart';

final class ProjectPadding extends EdgeInsets {
  const ProjectPadding._() : super.all(0);

  ProjectPadding.allSmall() : super.all(16);
  ProjectPadding.allNormal() : super.all(20);
  ProjectPadding.allMedium() : super.all(24);
  ProjectPadding.allLarge() : super.all(28);
}
