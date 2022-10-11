import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/protobuf/video/sfu/event/events.pb.dart';
import 'package:stream_video/src/models/events/events.dart';

@internal
class SfuController {
  final _sfuController = BehaviorSubject<SFUEvent>();

  void _emit(SFUEvent event) => _sfuController.add(event);

  void emitSubscriberOffer(SubscriberOffer payload) =>
      _emit(SubscriberOfferEvent(payload));

  SFUEvent get sfuEvent => _sfuController.value;

  Stream<SFUEvent> get _sfuStream => _sfuController.stream.distinct();

  StreamSubscription<SFUEvent> _listen(
    FutureOr<void> Function(SFUEvent event) onEvent,
  ) =>
      _sfuStream.listen(onEvent);

  StreamSubscription<SFUEvent> on<E extends SFUEvent>(
    FutureOr<void> Function(E) then, {
    bool Function(E)? filter,
  }) =>
      _listen((event) async {
        // event must be E
        if (event is! E) return;
        // filter must be true (if filter is used)
        if (filter != null && !filter(event)) return;
        // cast to E
        await then(event);
      });

  Future<void> dispose() async => _sfuController.close();
}
