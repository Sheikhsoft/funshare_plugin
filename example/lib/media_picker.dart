// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';
// import 'package:funshare_plugin/funshare_plugin.dart';

// class MediaPickerScreen extends StatefulWidget {
//   @override
//   _MediaPickerScreenState createState() => _MediaPickerScreenState();
// }

// class _MediaPickerScreenState extends State<MediaPickerScreen> {
//   Future<File> _mediaFile;
//   bool isVideo = false;
//   VideoPlayerController _controller;
//   VoidCallback listener;
//   File _videoFile;

//   void _onImageButtonPressed(ImageSource source) {
//     setState(() {
//       if (_controller != null) {
//         _controller.setVolume(0.0);
//         _controller.removeListener(listener);
//       }
//       if (isVideo) {
//         _mediaFile = ImagePicker.pickVideo(source: source).then((File _file) {
//           _controller = VideoPlayerController.file(_file)
//             ..addListener(listener)
//             ..setVolume(1.0)
//             ..initialize()
//             ..setLooping(true)
//             ..play();
//           setState(() {});
//           _videoFile = _file;
//         });
//       } else {
//         _mediaFile = ImagePicker.pickImage(source: source);
//       }
//     });
//   }

//   @override
//   void deactivate() {
//     if (_controller != null) {
//       _controller.setVolume(0.0);
//       _controller.removeListener(listener);
//     }
//     super.deactivate();
//   }

//   @override
//   void dispose() {
//     if (_controller != null) {
//       _controller.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     listener = () {
//       setState(() {});
//     };
//   }

//   Widget _previewVideo(VideoPlayerController controller) {
//     if (controller == null) {
//       return const Text(
//         'You have not yet picked a video',
//         textAlign: TextAlign.center,
//       );
//     } else if (controller.value.initialized) {
//       return Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: AspectRatioVideo(controller),
//       );
//     } else {
//       return const Text(
//         'Error Loading Video',
//         textAlign: TextAlign.center,
//       );
//     }
//   }

//   Widget _previewImage() {
//     return FutureBuilder<File>(
//         future: _mediaFile,
//         builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
//           if (snapshot.connectionState == ConnectionState.done &&
//               snapshot.data != null) {
//             print(snapshot.data);
//             return Image.file(snapshot.data);
//           } else if (snapshot.error != null) {
//             return const Text(
//               'Error picking image.',
//               textAlign: TextAlign.center,
//             );
//           } else {
//             return const Text(
//               'You have not yet picked an image.',
//               textAlign: TextAlign.center,
//             );
//           }
//         });
//   }

//   Widget _buildMediaPreview(BuildContext context) {
//     return Container(
//       margin: new EdgeInsets.all(10.0),
//       child: SizedBox(
//         height: 300.0,
//         child: Card(
//           elevation: 4.0,
//           color: Colors.indigo[900],
//           child: Center(
//             child: isVideo ? _previewVideo(_controller) : _previewImage(),
//           ),
//         ),
//       ),
//     );
//   }

//   _shareMedia(String social, BuildContext context) async {
//     if (_videoFile != null) {
//       if (isVideo) {
//         //FunsharePlugin.shareVideo(_mediaUrl);
//         print(_videoFile.path);

//         try {
//           await FunsharePlugin.shareLocalVideo(_videoFile.path);
//         } catch (e) {
//           print('error: $e');
//         }
//       } else {}
//     }
//   }

//   Widget _buildShareButton(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
//       height: 50.0,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: <Widget>[
//           new Material(
//             color: Colors.transparent,
//             child: Container(
//               padding: const EdgeInsets.only(bottom: 15.0, left: 5.0),
//               child: RaisedButton(
//                 onPressed: () {
//                   _shareMedia("facebook", context);
//                 },
//                 shape: StadiumBorder(),
//                 elevation: 10.0,
//                 color: Colors.blue[700],
//                 child: Text("SHARE Media"),
//                 textColor: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future _shareLocalVideo() async {
//     try {
//       await FunsharePlugin.shareLocalVideo(
//           '/private/var/mobile/Containers/Data/Application/88D84983-9063-44B1-9764-3D252E5977C8/tmp/image_picker_543C9411-FC32-47D8-9440-ADC78CF43393-2546-0000023105421427.MOV');
//     } catch (e) {
//       print('error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> _layouts = [
//       _buildShareButton(context),
//     ];
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Meadia Picker"),
//       ),
//       body: Column(
//         children: <Widget>[
//           _buildMediaPreview(context),
//           Expanded(
//               child: ListView(
//             children: _layouts,
//           ))
//         ],
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           FloatingActionButton(
//             onPressed: () {
//               isVideo = false;
//               _onImageButtonPressed(ImageSource.gallery);
//             },
//             heroTag: 'image0',
//             tooltip: 'Pick Image from gallery',
//             child: const Icon(Icons.photo_library),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 16.0),
//             child: FloatingActionButton(
//               onPressed: () {
//                 isVideo = false;
//                 _onImageButtonPressed(ImageSource.camera);
//               },
//               heroTag: 'image1',
//               tooltip: 'Take a Photo',
//               child: const Icon(Icons.camera_alt),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 16.0),
//             child: FloatingActionButton(
//               backgroundColor: Colors.red,
//               onPressed: () {
//                 isVideo = true;
//                 _onImageButtonPressed(ImageSource.gallery);
//               },
//               heroTag: 'video0',
//               tooltip: 'Pick Video from gallery',
//               child: const Icon(Icons.video_library),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 16.0),
//             child: FloatingActionButton(
//               backgroundColor: Colors.red,
//               onPressed: () {
//                 isVideo = true;
//                 _onImageButtonPressed(ImageSource.camera);
//               },
//               heroTag: 'video1',
//               tooltip: 'Take a Video',
//               child: const Icon(Icons.videocam),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AspectRatioVideo extends StatefulWidget {
//   final VideoPlayerController controller;

//   AspectRatioVideo(this.controller);

//   @override
//   AspectRatioVideoState createState() => new AspectRatioVideoState();
// }

// class AspectRatioVideoState extends State<AspectRatioVideo> {
//   VideoPlayerController get controller => widget.controller;
//   bool initialized = false;

//   VoidCallback listener;

//   @override
//   void initState() {
//     super.initState();
//     listener = () {
//       if (!mounted) {
//         return;
//       }
//       if (initialized != controller.value.initialized) {
//         initialized = controller.value.initialized;
//         setState(() {});
//       }
//     };
//     controller.addListener(listener);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (initialized) {
//       final Size size = controller.value.size;
//       return new Center(
//         child: new AspectRatio(
//           aspectRatio: size.width / size.height,
//           child: new VideoPlayPause(controller),
//         ),
//       );
//     } else {
//       return new Container();
//     }
//   }
// }

// class VideoPlayPause extends StatefulWidget {
//   final VideoPlayerController controller;

//   VideoPlayPause(this.controller);

//   @override
//   State createState() {
//     return new _VideoPlayPauseState();
//   }
// }

// class _VideoPlayPauseState extends State<VideoPlayPause> {
//   FadeAnimation imageFadeAnim =
//       new FadeAnimation(child: const Icon(Icons.play_arrow, size: 100.0));
//   VoidCallback listener;

//   _VideoPlayPauseState() {
//     listener = () {
//       setState(() {});
//     };
//   }

//   VideoPlayerController get controller => widget.controller;

//   @override
//   void initState() {
//     super.initState();
//     controller.addListener(listener);
//     controller.setVolume(1.0);
//     controller.play();
//   }

//   @override
//   void deactivate() {
//     controller.setVolume(0.0);
//     controller.removeListener(listener);
//     super.deactivate();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> children = <Widget>[
//       new GestureDetector(
//         child: new VideoPlayer(controller),
//         onTap: () {
//           if (!controller.value.initialized) {
//             return;
//           }
//           if (controller.value.isPlaying) {
//             imageFadeAnim =
//                 new FadeAnimation(child: const Icon(Icons.pause, size: 100.0));
//             controller.pause();
//           } else {
//             imageFadeAnim = new FadeAnimation(
//                 child: const Icon(Icons.play_arrow, size: 100.0));
//             controller.play();
//           }
//         },
//       ),
//       new Align(
//         alignment: Alignment.bottomCenter,
//         child: new VideoProgressIndicator(
//           controller,
//           allowScrubbing: true,
//         ),
//       ),
//       new Center(child: imageFadeAnim),
//     ];

//     return new Stack(
//       fit: StackFit.passthrough,
//       children: children,
//     );
//   }
// }

// class FadeAnimation extends StatefulWidget {
//   final Widget child;
//   final Duration duration;

//   FadeAnimation({this.child, this.duration: const Duration(milliseconds: 500)});

//   @override
//   _FadeAnimationState createState() => new _FadeAnimationState();
// }

// class _FadeAnimationState extends State<FadeAnimation>
//     with SingleTickerProviderStateMixin {
//   AnimationController animationController;

//   @override
//   void initState() {
//     super.initState();
//     animationController =
//         new AnimationController(duration: widget.duration, vsync: this);
//     animationController.addListener(() {
//       if (mounted) {
//         setState(() {});
//       }
//     });
//     animationController.forward(from: 0.0);
//   }

//   @override
//   void deactivate() {
//     animationController.stop();
//     super.deactivate();
//   }

//   @override
//   void didUpdateWidget(FadeAnimation oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.child != widget.child) {
//       animationController.forward(from: 0.0);
//     }
//   }

//   @override
//   void dispose() {
//     animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return animationController.isAnimating
//         ? new Opacity(
//             opacity: 1.0 - animationController.value,
//             child: widget.child,
//           )
//         : new Container();
//   }
// }

// typedef Widget VideoWidgetBuilder(
//     BuildContext context, VideoPlayerController controller);

// abstract class PlayerLifeCycle extends StatefulWidget {
//   final VideoWidgetBuilder childBuilder;
//   final String dataSource;

//   PlayerLifeCycle(this.dataSource, this.childBuilder);
// }

// /// A widget connecting its life cycle to a [VideoPlayerController] using
// /// a data source from the network.
// class NetworkPlayerLifeCycle extends PlayerLifeCycle {
//   NetworkPlayerLifeCycle(String dataSource, VideoWidgetBuilder childBuilder)
//       : super(dataSource, childBuilder);

//   @override
//   _NetworkPlayerLifeCycleState createState() =>
//       new _NetworkPlayerLifeCycleState();
// }

// /// A widget connecting its life cycle to a [VideoPlayerController] using
// /// an asset as data source
// class AssetPlayerLifeCycle extends PlayerLifeCycle {
//   AssetPlayerLifeCycle(String dataSource, VideoWidgetBuilder childBuilder)
//       : super(dataSource, childBuilder);

//   @override
//   _AssetPlayerLifeCycleState createState() => new _AssetPlayerLifeCycleState();
// }

// abstract class _PlayerLifeCycleState extends State<PlayerLifeCycle> {
//   VideoPlayerController controller;

//   @override

//   /// Subclasses should implement [createVideoPlayerController], which is used
//   /// by this method.
//   void initState() {
//     super.initState();
//     controller = createVideoPlayerController();
//     controller.addListener(() {
//       if (controller.value.hasError) {
//         print(controller.value.errorDescription);
//       }
//     });
//     controller.initialize();
//     controller.setLooping(true);
//     controller.play();
//   }

//   @override
//   void deactivate() {
//     super.deactivate();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.childBuilder(context, controller);
//   }

//   VideoPlayerController createVideoPlayerController();
// }

// class _NetworkPlayerLifeCycleState extends _PlayerLifeCycleState {
//   @override
//   VideoPlayerController createVideoPlayerController() {
//     return new VideoPlayerController.network(widget.dataSource);
//   }
// }

// class _AssetPlayerLifeCycleState extends _PlayerLifeCycleState {
//   @override
//   VideoPlayerController createVideoPlayerController() {
//     return new VideoPlayerController.asset(widget.dataSource);
//   }
// }

// /// A filler card to show the video in a list of scrolling contents.
// Widget buildCard(String title) {
//   return new Card(
//     child: new Column(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         new ListTile(
//           leading: const Icon(Icons.airline_seat_flat_angled),
//           title: new Text(title),
//         ),
//         new ButtonTheme.bar(
//           child: new ButtonBar(
//             children: <Widget>[
//               new FlatButton(
//                 child: const Text('BUY TICKETS'),
//                 onPressed: () {/* ... */},
//               ),
//               new FlatButton(
//                 child: const Text('SELL TICKETS'),
//                 onPressed: () {/* ... */},
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
