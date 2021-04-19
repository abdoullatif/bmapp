import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class ChewieItem extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;

  ChewieItem({
    @required this.videoPlayerController,
    this.looping,
    Key key,
  }) : super(key: key);

  @override
  _ChewieItemState createState() => _ChewieItemState();
}

class _ChewieItemState extends State<ChewieItem> {

  ChewieController _chewieController;

  @override
  void initState(){
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      looping: widget.looping,
      errorBuilder: (context, errorMessage){
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Container(
      child: new Container(
        child: Chewie(
          controller: _chewieController,
        ),
      ),

    );
  }
  @override
  void dispose(){
    super.dispose();
    //imprt
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
