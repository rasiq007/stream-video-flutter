import 'dart:async';

import '../../../stream_video.dart';
import '../action/call_control_action.dart';
import '../call_state.dart';
import '../sfu/data/events/sfu_events.dart';
import '../sfu/data/models/sfu_track_type.dart';
import '../shared_emitter.dart';
import '../state_emitter.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import '../webrtc/rtc_track.dart';
import 'call_impl.dart';
import 'call_settings.dart';

/// Represents a [CallV2] in which you can connect to.
abstract class CallV2 {
  const CallV2();
  factory CallV2.forCid({
    required StreamCallCid callCid,
    StreamVideoV2? streamVideo,
  }) {
    return CallV2Impl(
      callCid: callCid,
      streamVideo: streamVideo,
    );
  }
  factory CallV2.forData({
    required CallCreated data,
    StreamVideoV2? streamVideo,
  }) {
    return CallV2Impl.from(
      data: data,
      streamVideo: streamVideo,
    );
  }

  StateEmitter<CallStateV2> get state;

  SharedEmitter<SfuEventV2> get events;

  Future<Result<CallCreated>> dial({
    required List<String> participantIds,
  });

  Future<Result<CallReceivedOrCreated>> getOrCreate({
    List<String> participantIds = const [],
    bool ringing = false,
  });

  Future<Result<CallCreated>> create({
    List<String> participantIds = const [],
    bool ringing = false,
  });

  Future<Result<None>> acceptCall();

  Future<Result<None>> rejectCall();

  Future<Result<None>> cancelCall();

  Future<Result<None>> connect({
    CallSettings settings = const CallSettings(),
  });

  Future<Result<None>> disconnect();

  List<RtcTrack> getTracks(String trackId);

  RtcTrack? getTrack(String trackId, SfuTrackType trackType);

  Future<Result<None>> apply(CallControlAction action);
}
