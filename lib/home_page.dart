import 'dart:async';

import 'package:allen/feature_box.dart';
import 'package:allen/openai_service.dart';
import 'package:allen/pallete.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text_google_dialog/speech_to_text_google_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = 'Flutter';
  String result = '';
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;
  int start = 200;
  int delay = 200;
  bool isButtonVisible = false;

  void hideButton() {
    setState(() {
      isButtonVisible = false;
    });
  }

  void showButton() {
    setState(() {
      isButtonVisible = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    print('$lastWords');
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) async {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    showButton();
    await flutterTts.speak(content);
  }

  Future<void> systemSpeakStop() async {
    await flutterTts.pause();
    hideButton();
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          child: const Text('Team 14'),
        ),
        leading: const Icon(Icons.menu),
        centerTitle: true,
        actions: [
          Visibility(
            visible: isButtonVisible,
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 10),
              child: Transform.scale(
                scale:
                    1.7, // Increase the scale value to increase the button size
                child: IconButton(
                  icon: const Icon(
                    Icons.stop_circle_rounded,
                    color: Colors.lightBlue,
                  ),
                  onPressed: () {
                    systemSpeakStop();
                    // Perform the action you want when the button is clicked
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // virtual assistant picture
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Container(
                    height: 123,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/openAI.png',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // chat bubble
            FadeInRight(
              child: Visibility(
                visible: generatedImageUrl == null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                    top: 30,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Pallete.borderColor,
                    ),
                    borderRadius: BorderRadius.circular(20).copyWith(
                      topLeft: Radius.zero,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      generatedContent == null
                          ? 'Good Morning, what task can I do for you?'
                          : generatedContent!,
                      style: TextStyle(
                        fontFamily: 'Cera Pro',
                        color: Pallete.mainFontColor,
                        fontSize: generatedContent == null ? 25 : 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (generatedImageUrl != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(generatedImageUrl!),
                ),
              ),
            SlideInLeft(
              child: Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 10, left: 22),
                  child: const Text(
                    'Here are a few features',
                    style: TextStyle(
                      fontFamily: 'Cera Pro',
                      color: Pallete.mainFontColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // features list
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(milliseconds: start),
                    child: const FeatureBox(
                      color: Pallete.firstSuggestionBoxColor,
                      headerText: 'ChatGPT',
                      descriptionText:
                          'A smarter way to stay organized and informed with ChatGPT',
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + delay),
                    child: const FeatureBox(
                      color: Pallete.secondSuggestionBoxColor,
                      headerText: 'Dall-E',
                      descriptionText:
                          'Get inspired and stay creative with your personal assistant powered by Dall-E',
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + 2 * delay),
                    child: const FeatureBox(
                      color: Pallete.thirdSuggestionBoxColor,
                      headerText: 'Smart Voice Assistant',
                      descriptionText:
                          'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT',
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + 3 * delay),
        child: FloatingActionButton(
          backgroundColor: Pallete.firstSuggestionBoxColor,
          onPressed: () async {
            bool isServiceAvailable =
                await SpeechToTextGoogleDialog.getInstance().showGoogleDialog(
                    onTextReceived: (data) {
              setState(() async {
                result = data.toString();
                print('$result');
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Image or Text'),
                      content: const Text(
                          'Choose whether you want an text or image based answer'),
                      actions: [
                        TextButton(
                          child: const Text('Text'),
                          onPressed: () async {
                            // Perform action for Option 1
                            Navigator.pop(context);

                            EasyLoading.show(
                              status: 'Loading...',
                              maskType: EasyLoadingMaskType.custom,
                            );

                            final speech =
                                await openAIService.chatGPTAPI(result);

                            EasyLoading.dismiss();

                            generatedImageUrl = null;
                            generatedContent = speech;
                            setState(() {});
                            await systemSpeak(speech);
                          },
                        ),
                        TextButton(
                          child: const Text('Image'),
                          onPressed: () async {
                            // Perform action for Option 2

                            Navigator.pop(context);

                            EasyLoading.show(
                              status: 'Loading...',
                              maskType: EasyLoadingMaskType.custom,
                            );

                            final imageURL =
                                await openAIService.dallEAPI(result);

                            EasyLoading.dismiss();

                            if (imageURL.contains('https')) {
                              generatedImageUrl = imageURL;
                              generatedContent = null;
                              setState(() {});
                            } else {
                              generatedImageUrl = null;
                              generatedContent = imageURL;
                              setState(() {});
                              await systemSpeak(imageURL);
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              });
            });
            if (!isServiceAvailable) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Service is not available'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height - 100,
                  left: 16,
                  right: 16,
                ),
              ));
            }
          },
          child: Icon(
            speechToText.isListening ? Icons.stop : Icons.mic,
          ),
        ),
      ),
    );
  }
}
