// deeply merge `a` into `b` so that every conflicting value on `b` is
// overwritten by `a`
Map<String, dynamic> mergeMap(Map<String, dynamic> a, Map<String, dynamic> b) {
  b.forEach((k, v) {
    if (!a.containsKey(k)) {
      a[k] = v;
    } else {
      if (a[k] is List) {
        mergeList(a[k], b[k]);
      } else if (a[k] is Map) {
        mergeMap(a[k], b[k]);
      } else {
        a[k] = b[k];
      }
    }
  });

  return a;
}

List<dynamic> mergeList(List<dynamic> a, List<dynamic> b) {
  b.forEach((v) {
    if (a[k] is List) {
    } else if (a[k] is Map) {
      mergeMap(a[k], b[k]);
    } else {
      a[k] = b[k];
    }
  });

  return a;
}
