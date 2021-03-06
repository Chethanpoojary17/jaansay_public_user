// Dart imports:
import 'dart:async';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:bubble/bubble.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

// Project imports:
import 'package:jaansay_public_user/models/message.dart';
import 'package:jaansay_public_user/models/official.dart';
import 'package:jaansay_public_user/providers/official_profile_provider.dart';
import 'package:jaansay_public_user/screens/community/profile_full_screen.dart';
import 'package:jaansay_public_user/screens/message/message_media_screen.dart';
import 'package:jaansay_public_user/service/message_service.dart';
import 'package:jaansay_public_user/service/official_service.dart';
import 'package:jaansay_public_user/widgets/general/custom_loading.dart';
import 'package:jaansay_public_user/widgets/general/custom_network_image.dart';

class MessageDetailScreen extends StatefulWidget {
  final MessageMaster messageMaster;
  final Official official;

  MessageDetailScreen({this.messageMaster, this.official});

  @override
  _MessageDetailScreenState createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  MessageMaster messageMaster;
  Official official;
  List<Message> messages = [];
  bool isCheck = false;
  bool isLoad = true;
  TextEditingController _messageController = TextEditingController();
  MessageService messageService = MessageService();
  ScrollController _scrollController = ScrollController();
  OfficialService officialService = OfficialService();
  List<OfficialDocument> officialDocuments = [];
  bool sendingMessage = false;
  bool isSend = true;
  Timer messageTimer;

  getAllMessages() async {
    await messageService.getAllMessagesUsingOfficialId(
        messages,
        messageMaster?.officialsId?.toString() ??
            official.officialsId.toString());
    officialDocuments.clear();
    await officialService.getOfficialDocuments(
        officialDocuments,
        official?.officialsId?.toString() ??
            messageMaster.officialsId.toString());
    officialDocuments.map((e) {
      if (e.isVerified != 1) {
        isSend = false;
      }
    }).toList();
    messages = messages.reversed.toList();
    isLoad = false;
    setState(() {});
  }

  checkNewMessages() async {
    if (!sendingMessage) {
      List<Message> tempMessages = [];
      await messageService.getAllMessagesUsingOfficialId(
          tempMessages,
          messageMaster?.officialsId?.toString() ??
              official.officialsId.toString());
      tempMessages = tempMessages.reversed.toList();
      if (tempMessages.length > 0) {
        if (tempMessages.first.messageId != messages.first.messageId) {
          messages.clear();
          messages = [...tempMessages];
          setState(() {});
        }
      }
    }
  }

  sendMessage() async {
    if (_messageController.text != null &&
        _messageController.text.trim().length > 0) {
      sendingMessage = true;
      String message = _messageController.text.trim();
      GetStorage box = GetStorage();
      final userId = box.read("user_id");
      messages.insert(
        0,
        Message(
          message: message,
          messageId: 0,
          mmId: messageMaster == null ? 0 : messageMaster.mmId,
          surveyId: null,
          updatedAt: DateTime.now(),
          userId: userId,
          type: 0,
          messageType: 0,
        ),
      );
      _messageController.clear();
      setState(() {});
      messageMaster != null
          ? await messageService.sendMessage(
              message, messageMaster.officialsId.toString())
          : await messageService.sendMessage(
              message, official.officialsId.toString());
      sendingMessage = false;
    }
  }

  appBar(OfficialProfileProvider officialProfileProvider) {
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      backgroundColor: Colors.white,
      titleSpacing: 0,
      leadingWidth: 50,
      title: InkWell(
        onTap: () {
          officialProfileProvider.clearData();
          Get.off(
              () => ProfileFullScreen(
                    official?.officialsId ?? messageMaster.officialsId,
                  ),
              transition: Transition.rightToLeft);
        },
        child: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                  child: CustomNetWorkImage(messageMaster == null
                      ? official.photo
                      : messageMaster.photo)),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                "${messageMaster == null ? official.officialsName : messageMaster.officialsName}",
                style: TextStyle(
                  color: Get.theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () async {
            final url =
                "tel:${messageMaster == null ? official.officialDisplayPhone : messageMaster.officialDisplayPhone}";
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw '${tr("Could not launch")} $url';
            }
          },
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Icon(
              Icons.call,
              size: 28,
              color: Get.theme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messageMaster = widget.messageMaster;
    official = widget.official;
    getAllMessages();
    messageTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkNewMessages();
    });
  }

  @override
  void dispose() {
    messageTimer.cancel();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final officialProfileProvider =
        Provider.of<OfficialProfileProvider>(context, listen: false);

    return Scaffold(
      appBar: appBar(officialProfileProvider),
      body: isLoad
          ? CustomLoading()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    itemCount: messages.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          if (index == messages.length - 1 ||
                              messages[index].updatedAt.day !=
                                  messages[index + 1].updatedAt.day)
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Color(0xffD6EAF8),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                "${DateFormat('d MMMM y').format(messages[index].updatedAt).toUpperCase()}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 12),
                              ),
                            ),
                          _MessageBubble(
                              messages[index], messageMaster, official),
                        ],
                      );
                    },
                  ),
                ),
                isSend
                    ? _MessageField(_messageController, () => sendMessage())
                    : Container(
                        color: Colors.black.withAlpha(25),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Text(
                                "Please add the requested documents to send messages to this official.")
                            .tr(),
                      )
              ],
            ),
    );
  }
}

class _MessageBubble extends StatefulWidget {
  final Message message;
  final MessageMaster messageMaster;
  final Official official;

  _MessageBubble(this.message, this.messageMaster, this.official);

  @override
  __MessageBubbleState createState() => __MessageBubbleState();
}

class __MessageBubbleState extends State<_MessageBubble> {
  final GetStorage box = GetStorage();

  VideoPlayerController _controller;
  bool isUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.message.messageType == 2) {
      _controller = VideoPlayerController.network(
        widget.message.message,
      )..initialize().then((_) {
          _controller.pause();
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isUser = widget.message.userId == box.read("user_id");

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        if (widget.message.messageType != 0) {
          Get.to(() => MessageMediaScreen(), arguments: [
            widget.message,
            widget.messageMaster,
            widget.official
          ]);
        }
      },
      child: Bubble(
        alignment: isUser ? Alignment.topRight : Alignment.topLeft,
        color: isUser ? Theme.of(context).primaryColor : Colors.white,
        nip: isUser ? BubbleNip.rightBottom : BubbleNip.leftBottom,
        elevation: 2,
        margin: BubbleEdges.only(
            top: 10, left: 10, bottom: widget.message.type == 4 ? 0 : 5),
        child: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
              minWidth: MediaQuery.of(context).size.width * 0.2),
          child: Stack(
            children: [
              widget.message.messageType == 0
                  ? Padding(
                      padding: EdgeInsets.only(
                          bottom: 5, right: 40, top: 5, left: 5),
                      child: Linkify(
                        text: widget.message.message,
                        onOpen: (link) async {
                          if (await canLaunch(link.url)) {
                            await launch(link.url);
                          } else {
                            throw 'Could not launch $link';
                          }
                        },
                        linkStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        style: TextStyle(
                            color: isUser ? Colors.white : Colors.black,
                            fontSize: 16),
                        textAlign: TextAlign.start,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                          bottom: 18, right: 0, top: 0, left: 0),
                      child: widget.message.messageType == 1
                          ? Hero(
                              tag: widget.message.messageId.toString(),
                              child: Image.network(
                                widget.message.message,
                                width: double.infinity,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: 200,
                              alignment: Alignment.center,
                              child: _controller?.value?.isInitialized ?? false
                                  ? Stack(
                                      children: [
                                        VideoPlayer(_controller),
                                        BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 2, sigmaY: 2),
                                          child: Container(
                                            alignment: Alignment.center,
                                            color: Colors.grey.withOpacity(0.2),
                                          ),
                                        ),
                                        Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.play_arrow,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 60,
                                            )),
                                      ],
                                    )
                                  : CircularProgressIndicator(),
                            ),
                    ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Text(
                  DateFormat('HH:mm').format(widget.message.updatedAt),
                  style: TextStyle(
                      fontSize: 11,
                      color: isUser ? Colors.white : Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageField extends StatelessWidget {
  final TextEditingController _messageController;
  final Function sendMessage;

  _MessageField(this._messageController, this.sendMessage);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(60)),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration.collapsed(
                  hintText: tr("Enter a message"),
                ),
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: 4,
                maxLength: 500,
                buildCounter: (BuildContext context,
                        {int currentLength, int maxLength, bool isFocused}) =>
                    null,
              ),
            ),
          ),
          Container(
              height: 45,
              width: 45,
              margin: EdgeInsets.only(left: 8),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: Material(
                  color: Theme.of(context).primaryColor,
                  child: InkWell(
                    onTap: () {
                      sendMessage();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 10, right: 7, top: 10, bottom: 10),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
