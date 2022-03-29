import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class VideoView extends StatefulWidget {
  final matchParent;

  final Size? viewSize;

  final bool setMirror;
  final double itemHeight;
  final ScaleType scaleType;
  final double itemWidth;

  VideoView({
    Key? key,
    this.viewSize,
    this.setMirror = false,
    this.matchParent = true,
    this.itemHeight = 200,
    this.itemWidth = 200,
    this.scaleType = ScaleType.SCALE_ASPECT_FILL
  }) : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, Tuple4<HMSVideoTrack?, bool, bool, bool>>(
        builder: (_, data, __) {
          print(
              "Height of Video is ${widget.itemHeight}"); // print("Video Built Again for ${data.item1?.peer?.name??"null"} ${data.item2}");
          if ((data.item1 == null) || data.item2 || data.item3 || data.item4) {
            return Container(
                // height: widget.itemHeight,
                // width: widget.itemWidth,
                child: Center(
                    child: CircleAvatar(
                        backgroundColor: Utilities.colors[context
                                .read<PeerTrackNode>()
                                .peer
                                .name
                                .toLowerCase()
                                .codeUnitAt(0) %
                            Utilities.colors.length],
                        radius: 36,
                        child: Text(
                          Utilities.getAvatarTitle(
                              context.read<PeerTrackNode>().peer.name),
                          style: TextStyle(fontSize: 36, color: Colors.white),
                        ))));
          } else {
            return (data.item1?.source !="REGULAR")?
            Container(
              height: widget.itemHeight,
              width: widget.itemWidth,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: InteractiveViewer(
                    child: HMSVideoView(
                      scaleType: widget.scaleType,
                      track: data.item1!,
                      setMirror: false,
                      matchParent: false, 
                    ),
                  ),
                ),
              ),
            )
            :ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                height: widget.itemHeight,
                width: widget.itemWidth,
                child: HMSVideoView(
                  scaleType: widget.scaleType,
                  track: data.item1!,
                  setMirror: false,
                  matchParent: false,
                ),
              ),
            );
          }
        },
        selector: (_, peerTrackNode) => Tuple4(
            peerTrackNode.track,
            (peerTrackNode.isOffscreen),
            (peerTrackNode.track?.isMute ?? true),
            peerTrackNode.track?.isDegraded ?? false));
  }
}