// ignore_for_file: file_names, deprecated_member_use, unused_import, avoid_function_literals_in_foreach_calls, must_be_immutable, sized_box_for_whitespace, prefer_const_constructors, avoid_unnecessary_containers, duplicate_ignore, non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:interactive_map/Homepages/mainPage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../Repos/StoryClass.dart';
import '../Repos/UserClass.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:open_file_safe/open_file_safe.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

import '../Repos/UserInfo.dart';
import '../Repos/UserRepo.dart';

class StoryWidgetAll extends StatefulWidget {
  Story story;
  dynamic location;
  dynamic id;
  StoryWidgetAll(this.story, this.location, this.id, {Key? key})
      : super(key: key);

  @override
  _StoryWidgetAllState createState() => _StoryWidgetAllState();
}

String convertToArabicNumber(String number) {
  String res = '';

  final arabics = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  number.characters.forEach((element) {
    res += arabics[int.parse(element)];
  });

/*   final latins = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']; */
  return res;
}

enum SocialMedia { facebook, twitter, whatsapp, instagram }

class _StoryWidgetAllState extends State<StoryWidgetAll> {
  Future share(SocialMedia socialPlatform) async {
    final text = widget.story.title + ' ';
    final urlShare = Uri.encodeComponent(widget.story.link);

    final urls = {
      SocialMedia.facebook:
          'https://www.facebook.com/sharer/sharer.php?u=$urlShare&t=$text',
      SocialMedia.twitter:
          'https://twitter.com/intent/tweet?url=$urlShare&text=$text',
      // SocialMedia.instagram:
      //     'https://www.facebook.com/sharer/sharer.php?u=$urlShare&t=$text',
      SocialMedia.whatsapp: 'https://api.whatsapp.com/send?text=$text$urlShare',
    };
    final urlFinal = urls[socialPlatform];

    if (await canLaunch(urlFinal!)) {
      await launch(urlFinal);
    }
  }

  void _showMissionInfo() {
    if (widget.story.missionData == null) return;

    final missionDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      backgroundColor: Color(0xFF252422),
      title: Row(
        children: [
          Icon(Icons.flag, color: Color(0xFF4CAF50), size: 24),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.story.missionData['title'] ?? 'مهمة',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Baloo',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildMissionInfoRow('الفئة', widget.story.missionData['category'] == 'social' ? 'اجتماعية' : 'شخصية', Icons.category),
            SizedBox(height: 12),
            _buildMissionInfoRow('الصعوبة', widget.story.missionData['difficulty'] ?? 'سهل', Icons.speed),
            SizedBox(height: 12),
            _buildMissionInfoRow(
              'التقدم',
              '${widget.story.missionData['completion_count'] ?? 0} / ${widget.story.missionData['goal_count'] ?? 10}',
              Icons.timeline,
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: MaterialButton(
                color: Color(0xFF4CAF50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Navigate to map with mission pre-selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('لعرض المهمة على الخريطة، افتح علامة التبويب "المهام"'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'عرض المهمة على الخريطة',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Baloo',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => missionDialog,
    );
  }

  Widget _buildMissionInfoRow(String label, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Color(0xFFFFDE73),
              fontFamily: 'Baloo',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontFamily: 'Baloo',
            fontSize: 14,
          ),
        ),
        SizedBox(width: 8),
        Icon(icon, color: Colors.white70, size: 18),
      ],
    );
  }

  void _share() {
    final _aboutdialog = StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
          // ignore: prefer_const_constructors
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Icon(Icons.share),
          content: Container(
              height: 250,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(child: Text("شارك")),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ignore: deprecated_member_use
                        OutlinedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(color: Colors.grey))),
                            ),
                            onPressed: () {
                              share(SocialMedia.facebook);
                              Navigator.pop(context);
                            },
                            // borderSide: BorderSide(color: Colors.grey),
                            child: Container(
                              child: Image(
                                fit: BoxFit.fitWidth,
                                image: AssetImage('assets/facebook.png'),
                                height: 45,
                                width: 45,
                              ),
                            )),
                        OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(color: Colors.grey))),
                            ),
                            onPressed: () {
                              share(SocialMedia.twitter);
                              Navigator.pop(context);
                            },
                            child: Container(
                              child: Image(
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage('assets/twitter.png'),
                                  height: 45,
                                  width: 45),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ignore: deprecated_member_use

                        OutlinedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(color: Colors.grey))),
                            ),
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: widget.story.link));
                              Navigator.pop(context);
                            },
                            child: Container(
                              child: Image(
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage('assets/copy.png'),
                                  height: 45,
                                  width: 45),
                            )),
                        OutlinedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(color: Colors.grey))),
                            ),
                            onPressed: () {
                              share(SocialMedia.whatsapp);
                              Navigator.pop(context);
                            },
                            child: Container(
                              child: Image(
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage('assets/whatsapp.png'),
                                  height: 45,
                                  width: 45),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () => {
                        Navigator.pop(context),
                      },
                      child: Text(
                        "إستمرار",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Bahij",
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Color(0xFFCCAF41),
                      ),
                    ),
                  ])));
    });
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => _aboutdialog);
  }

  List<UserData> userData = [];
  UserInfoRepo userInfoRepo = UserInfoRepo();
  UserRepo userRepo = UserRepo();
  retrieveUserInfo(
      UserInfoRepo userInfoRepo, UserRepo userRepo, dynamic id) async {
    try {
      var tok = await userRepo.Authenticate("admin", "Admin_12345");

      userData = await userInfoRepo.getUserInfo(id, tok);
      return userData;
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    if (widget.story.anonymous.length == 0) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color(0xFF252422),//color of app bar
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              child: Row(children: [
                Expanded(
                  child: Container(
                    child: Row(
                      children: [
                        FutureBuilder(
                            future: retrieveUserInfo(
                                userInfoRepo, userRepo, widget.id),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              } else {
                                return Container(
                                  height: 40,
                                  width: 40,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      snapshot.data[0].image,
                                    ),
                                  ),
                                );
                              }
                            }),
                        const SizedBox(
                          width: 30,
                        ),
                        // Column(
                        //   children: [
                        //     Text(
                        //       widget.userData.name,
                        //       style: TextStyle(fontSize: 16),
                        //     ),
                        //     Text(
                        //       convertToArabicNumber(widget.story.date_submitted
                        //               .split("T")[0]
                        //               .split("-")[2]) +
                        //           "-" +
                        //           convertToArabicNumber(widget
                        //               .story.date_submitted
                        //               .split("T")[0]
                        //               .split("-")[1]) +
                        //           "-" +
                        //           convertToArabicNumber(widget
                        //               .story.date_submitted
                        //               .split("T")[0]
                        //               .split("-")[0]),
                        //       style: TextStyle(fontSize: 16),
                        //     )
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 110,
                  margin: EdgeInsets.all(10),
                  child: MaterialButton(
                    color: Color(0xFFFFDE73),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      _share();
                    },
                    child: const Text(
                      "شارك",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: 'Baloo'),
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
        body: Body(
          widget.story,
          widget.location,
        ),
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color(0xFF252422),
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              child: Row(children: [
                Expanded(
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              "https://secure.gravatar.com/avatar/f78d1ea57fd11ad745f028584fc71774?s=24&d=mm&r=g",
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        // Column(
                        //   children: [
                        //     Text(
                        //       "مجهول",
                        //       style: TextStyle(fontSize: 16),
                        //     ),
                        //     Text(
                        //       convertToArabicNumber(widget.story.date_submitted
                        //               .split("T")[0]
                        //               .split("-")[2]) +
                        //           "-" +
                        //           convertToArabicNumber(widget
                        //               .story.date_submitted
                        //               .split("T")[0]
                        //               .split("-")[1]) +
                        //           "-" +
                        //           convertToArabicNumber(widget
                        //               .story.date_submitted
                        //               .split("T")[0]
                        //               .split("-")[0]),
                        //       style: TextStyle(fontSize: 16),
                        //     )
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 110,
                  margin: EdgeInsets.all(10),
                  child: MaterialButton(
                    color: Color(0xFFFFDE73),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      _share();
                    },
                    child: const Text(
                      "شارك",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: 'Baloo'),
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
        body: Body(widget.story, widget.location),
      );
    }
  }
}

class Body extends StatefulWidget {
  Story story;
  dynamic location;

  Body(this.story, this.location, {Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var show = true;

  String removeAllHtmlTags(String htmlText) {
    return htmlText.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }

  var documents = [];

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    if (Platform.isIOS) WebView.platform = CupertinoWebView();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> carousel = [
      Image.network(
        widget.story.featured_image,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(100),
            child: CircularProgressIndicator(
              color: Color(0xFFFFDE73),
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ));
        },
      ),
    ];
    widget.story.gallery.forEach((element) {
      var mime_type = element['mime_type'];
      var type = mime_type.toString().split('/')[0];
      if (type == 'image') {
        carousel.add(
          Image.network(
            element['url'],
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(100),
                child: CircularProgressIndicator(
                  color: Color(0xFFFFDE73),
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ));
            },
          ),
        );
      } else if (type == 'video' || type == 'audio') {
        carousel.add(WebView(
          initialUrl: element['url'],
          javascriptMode: JavascriptMode.unrestricted,
        ));
      } else {
        documents.add(element['url']);
      }
    });
    if (documents.length != 0) {
      documents.forEach((element) {
        var link = element;
        carousel.add(InkWell(
            onTap: () async {
              var url = link;
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: link.split('.').last == 'pdf'
                ? Container(child: Image.asset('assets/pdf-image.png'))
                : Container(child: Image.asset('assets/word-image.png'))));
      });
    }
    dynamic desc = removeAllHtmlTags(widget.story.description);
    var length = convertToArabicNumber((carousel.length).toString());
    List<dynamic> myList = [
      Stack(
        children: [
          Column(children: [
            CarouselSlider.builder(
              itemCount: carousel.length,
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  if (carousel[index].toString().split('(')[0].toString() !=
                      'Image') {
                    setState(() {
                      show = false;
                    });
                  } else {
                    setState(() {
                      show = true;
                    });
                  }
                },
                height: 250.0,
                viewportFraction: 1,
                enableInfiniteScroll: false,
              ),
              itemBuilder: (context, itemIndex, realIndex) {
                var i = convertToArabicNumber((itemIndex + 1).toString());
                return Stack(children: [
                  Container(width: double.infinity, child: carousel[itemIndex]),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "$i من $length",
                            style: TextStyle(color: Colors.black),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        )),
                  ),
                ]);
              },
            ),
          ]),
          show
              ? Positioned.fill(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        // margin: EdgeInsetsGeometry.lerp(a, b, t),
                        height: 65,
                        color: Colors.black.withOpacity(0.5),
                        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        alignment: Alignment.bottomRight,

                        child: Container(
                            child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Column(
                              children: [
                                Row(children: [
                                  Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(math.pi),
                                    child: Icon(
                                      Icons.play_arrow,
                                      color: Color(0xFFE0C165),
                                    ),
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(
                                      widget.story.title,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontFamily: 'Baloo',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]),
                                Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                    child: Row(children: [
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(
                                          widget.story.event_date == ''
                                              ? ""
                                              : convertToArabicNumber(widget
                                                      .story.event_date
                                                      .toString()
                                                      .split("/")[0]
                                                      .toString()) +
                                                  ' - ' +
                                                  widget.story.locationName,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontFamily: 'Baloo',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ])),
                                // Mission badge - Show if story is linked to a mission
                                if (widget.story.missionData != null)
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _showMissionInfo();
                                          },
                                          borderRadius: BorderRadius.circular(20),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF4CAF50).withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Color(0xFF4CAF50),
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.flag,
                                                  color: Color(0xFF4CAF50),
                                                  size: 16,
                                                ),
                                                SizedBox(width: 6),
                                                Text(
                                                  'جزء من: ${widget.story.missionData['title'] ?? 'مهمة'}',
                                                  style: TextStyle(
                                                    color: Color(0xFF4CAF50),
                                                    fontSize: 13,
                                                    fontFamily: 'Baloo',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Color(0xFF4CAF50),
                                                  size: 12,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        )),
                      )),
                )
              : Container()
        ],
      ),
      Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      const Icon(Icons.location_pin, color: Color(0xFF2F69BC)),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.location,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Color(0xFF2F69BC),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.story.targeted_person,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        color: Color(0xFF2F69BC),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.story.event_date == ''
                            ? ""
                            : convertToArabicNumber(widget.story.event_date
                                .toString()
                                .split("/")[0]
                                .toString()),
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  child: Directionality(
                    child: Text(
                      desc,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          )
        ],
      )
    ];
    // ignore: avoid_unnecessary_containers
    return Container(
        height: double.infinity,
        color: Color(0xFF252422),
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            itemCount: myList.length,
            itemBuilder: (BuildContext context, int index) {
              return myList[index];
            }));
  }

  void _showMissionInfo() {
    if (widget.story.missionData == null) return;

    final missionDialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      backgroundColor: Color(0xFF252422),
      title: Row(
        children: [
          Icon(Icons.flag, color: Color(0xFF4CAF50), size: 24),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.story.missionData['title'] ?? 'مهمة',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Baloo',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildMissionInfoRow(
                'الفئة',
                widget.story.missionData['category'] == 'social'
                    ? 'اجتماعية'
                    : 'شخصية',
                Icons.category),
            SizedBox(height: 12),
            _buildMissionInfoRow(
                'الصعوبة',
                widget.story.missionData['difficulty'] ?? 'سهل',
                Icons.speed),
            SizedBox(height: 12),
            _buildMissionInfoRow(
              'التقدم',
              '${widget.story.missionData['completion_count'] ?? 0} / ${widget.story.missionData['goal_count'] ?? 10}',
              Icons.timeline,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to mission details page if needed
                },
                icon: Icon(Icons.arrow_forward, color: Colors.white),
                label: Text(
                  'عرض المهمة',
                  style: TextStyle(
                    fontFamily: 'Baloo',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4CAF50),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => missionDialog,
    );
  }

  Widget _buildMissionInfoRow(String label, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white70,
            fontFamily: 'Baloo',
            fontSize: 15,
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Baloo',
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 8),
        Icon(icon, color: Color(0xFF4CAF50), size: 20),
      ],
    );
  }
}
