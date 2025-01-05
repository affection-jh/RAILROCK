import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';

class TrackingUI extends StatefulWidget {
  final String trackingNum;
  TrackingUI({Key? key, required this.trackingNum}) : super(key: key);
  @override
  State<TrackingUI> createState() => _TrackingUIState();
}

class _TrackingUIState extends State<TrackingUI> {
  late Map<String, dynamic>? trackingData;
  Color iconColor1 = Colors.black;
  Color iconColor2 = Colors.black;
  Color iconColor3 = Colors.black;
  Color iconColor4 = Colors.black;
  Color iconColor5 = Colors.black;
  Color iconColor6 = Colors.black;
  List<Map<String, dynamic>> timeLine = [];

  late Size screenSize;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: RequestTrackingData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('오류 발생: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          print('NO');
          return Text(
            '운송장번호를 다시 확인해주세요',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          );
        }

        trackingData = snapshot.data;
        screenSize = MediaQuery.of(context).size;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            title: const Text(
              "배송 조회",
              style: TextStyle(
                  fontWeight: FontWeight.normal, fontFamily: 'Pretendard'),
            ),
            elevation: 2,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 운송장 정보
                  Row(
                    children: [
                      SizedBox(width: screenSize.width * 0.01),
                      TextButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                                  text: trackingData!['trackingNumberInKorea']))
                              .then((_) {
                            _showSnackbar('운송장번호 복사됨');
                          });
                        },
                        child: Text(
                          trackingData!['trackingNumberInKorea'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      SizedBox(width: screenSize.width * 0.01),
                      Text(
                        trackingData!['status'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: trackingData!['status'] == "Delivered"
                              ? Colors.green
                              : Colors.blue,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: screenSize.height * 0.05,
                  ),
                  Center(
                    child: Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 40,
                          color: iconColor1,
                        ),
                        Icon(
                          Icons.local_shipping,
                          size: 40,
                          color: iconColor2,
                        ),
                        Icon(
                          Icons.airplanemode_active,
                          size: 40,
                          color: iconColor3,
                        ),
                        Icon(
                          Icons.description,
                          size: 40,
                          color: iconColor4,
                        ),
                        Icon(
                          Icons.local_shipping,
                          size: 40,
                          color: iconColor5,
                        ),
                        Icon(
                          Icons.home,
                          size: 40,
                          color: iconColor6,
                        )
                      ],
                    )),
                  ),
                  SizedBox(height: screenSize.height * 0.05),
                  // 타임라인
                  const Text(
                    "배송 진행 상황",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTimeline(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 타임라인
  Widget _buildTimeline() {
    final events = trackingData!['events'] as List<dynamic>;

    return Column(
      children: List.generate(
        events.length,
        (index) {
          final event = events[index];
          return _buildTimelineItem(
            status: event['status'],
            time: event['time'],
            location: event['location'],
            isLast: index == events.length - 1,
          );
        },
      ),
    );
  }

  // 타임라인 항목
  Widget _buildTimelineItem({
    required String status,
    required String time,
    required String location,
    required bool isLast,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              // 상태 아이콘
              Icon(
                Icons.circle,
                size: 12,
                color: status.contains("Delivered")
                    ? Colors.green
                    : Colors.blueAccent,
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 60,
                  color: Colors.grey.shade300,
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> RequestTrackingData() async {
    Dio dio = Dio();
    timeLine.clear();
    try {
      String url =
          'https://api.ship24.com/public/v1/trackers/search/${widget.trackingNum}/results';
      String? key = dotenv.env['ship24_KEY'];

      if (key != null) {
        Response response = await dio.get(url,
            options: Options(headers: {
              'Accept': 'application/json/',
              'Authorization': key,
            }));

        Map<String, dynamic> data = response.data;

        int idx =
            data['data']['trackings'][0]['shipment']['trackingNumbers'].length;
        String trackingNumberInKorea = data['data']['trackings'][0]['shipment']
            ['trackingNumbers'][idx - 1]['tn'];

        String status =
            data['data']['trackings'][0]['shipment']['statusMilestone'];
        List<dynamic> events = data['data']['trackings'][0]['events'];

        for (int i = 0; i < events.length; i++) {
          String status = events[i]['status'] ?? '';
          String time = events[i]['datetime'] ?? '';
          String location =
              events[i]['location'] ?? events[i]['statusMilestone'] ?? [];

          timeLine.add({'status': status, 'time': time, 'location': location});

          status = '';
          time = '';
          location = '';
        }

        Map<String, dynamic> trackingData = {
          "trackingNumber": widget.trackingNum,
          "trackingNumberInKorea": trackingNumberInKorea,
          "status": status,
          "events": timeLine
        };

        setIconColor();
        return trackingData;
      } else {
        print("api , adress 확인요망");
        return null;
      }
    } catch (e) {
      print('http request error $e');
      return null;
    }
  }

  void _showSnackbar(String alertMessage) {
    final snackBar = SnackBar(
      content: Text(alertMessage),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void setIconColor() {
    if (timeLine.isNotEmpty && timeLine[timeLine.length - 1]['status'] != '') {
      int idx = 0;
      if (timeLine[idx]['status'] == 'Package Received' ||
          timeLine[idx]['status'] == 'Yanwen Pickup Scan' ||
          timeLine[idx]['status'] == 'Processing information input') {
        iconColor1 = Colors.blue;
      } else if (timeLine[idx]['status'] == 'Yanwen facility - Outbound') {
        iconColor1 = Colors.black;
        iconColor2 = Colors.blue;
      } else if (timeLine[idx]['status'] ==
          'Arrived at domestic terminal station') {
        iconColor3 = Colors.blue;
        iconColor2 = Colors.black;
      } else if (timeLine[idx]['status'] == '입항보고 수리' ||
          timeLine[idx]['status'] == '하선신고 수리') {
        iconColor4 = Colors.blue;
        iconColor3 = Colors.black;
      } else if (timeLine[idx]['status'].contains('배송완료')) {
        iconColor6 = Colors.green;
        iconColor5 = Colors.black;
      } else {
        iconColor5 = Colors.blue;
        iconColor4 = Colors.black;
      }
    }
  }
}
