
import 'package:intl/intl.dart';

String timeLineFormat(DateTime dt){
  var now = DateTime.now();
  var difference = now.difference(dt);

  if(difference.inMinutes < 60){
    final dtFormat = DateFormat('HH:mm');
    var str  = dtFormat.format(dt);
    return str;
  }

  if(difference.inHours < 24){
    return "${difference.inHours} h ago";
  }else if(difference.inDays < 30){
    return "${difference.inDays} d ago";
  }else if(difference.inDays < 365){
    final dtFormat = DateFormat('MM-dd');
    return dtFormat.format(dt);
  }else{
    final dtFormat = DateFormat('yyyy-MM-dd');
    var str  = dtFormat.format(dt);
    return str;
  }
}