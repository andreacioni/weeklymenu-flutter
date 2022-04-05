import 'package:weekly_menu_app/models/base_model.dart';

import 'syncronize.dart';

class ChangesetMerger<T extends BaseModel2> {
  final List<Changeset<T>> local;
  final List<Changeset<T>> remote;

  ChangesetMerger(this.local, this.remote);

  List<Changeset<T>> merge();
}
