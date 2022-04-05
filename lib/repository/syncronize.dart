import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weekly_menu_app/globals/json_merge.dart';
import 'package:weekly_menu_app/models/base_model.dart';

enum ChangesetSource { LOCAL, REMOTE, MERGE }

@freezed
class Changeset<T extends BaseModel2> extends Comparable<Changeset<T>> {
  final T value;
  final ChangesetSource source;
  final int? localTimestamp, remoteTimestamp;

  Changeset(this.value,
      {required this.source, this.localTimestamp, this.remoteTimestamp});

  factory Changeset.local(T value) => Changeset(value,
      source: ChangesetSource.LOCAL, localTimestamp: value.updateTimestamp);
  factory Changeset.remote(T value) => Changeset(value,
      source: ChangesetSource.REMOTE, remoteTimestamp: value.updateTimestamp);

  String? get id => value.id;

  int get timestamp => value.updateTimestamp;

  Changeset<T> merge(Changeset<T> v) {
    assert(this.source != ChangesetSource.MERGE &&
        v.source != ChangesetSource.MERGE);
    assert(this.source == ChangesetSource.LOCAL ||
        this.source == ChangesetSource.LOCAL);
    assert(this.source == ChangesetSource.REMOTE ||
        this.source == ChangesetSource.REMOTE);

    final localTs =
        this.source == ChangesetSource.LOCAL ? this.timestamp : v.timestamp;
    final remoteTs =
        this.source == ChangesetSource.REMOTE ? this.timestamp : v.timestamp;

    T merged;
    if (this.compareTo(v) > 0) {
      // this > v
      (v.value as dynamic).toJson();
    } else {
      //this < v
      merged = Changeset(merge(v.value.toJson(), b),
          source: ChangesetSource.MERGE,
          localTimestamp: localTs,
          remoteTimestamp: remoteTs);
    }

    return Changeset(jsonMerged,
        source: ChangesetSource.MERGE,
        localTimestamp: localTs,
        remoteTimestamp: remoteTs);
  }

  @override
  int compareTo(Changeset<T> other) {
    return this.timestamp.compareTo(other.timestamp);
  }
}
