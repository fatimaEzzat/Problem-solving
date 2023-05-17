import 'dart:io';
import 'package:task/task.dart' as task;
import 'package:path/path.dart' as path;



void main(List<String> arguments) {
 /// 1]read file from console..as lines of strings
  print('Enter file name: ');
  //Read input file name from standard input
  String fileName = stdin.readLineSync()!;
  // Open input file for reading
  late File inputFile = File(fileName);
  List<String> inputLines = inputFile.readAsLinesSync();



  /// 2]initialize output files..two files one to store average ,and the other for post popular brands
  String outputFileName1 = '0_${path.basename(fileName)}';
  String outputFileName2 = '1_${path.basename(fileName)}';
  File outputFile1 = File(outputFileName1);
  File outputFile2 = File(outputFileName2);


  /// 3] process input file data ..convert it to map
  Map<String,dynamic> result=task.processData(inputLines);


  final skin1 = outputFile1.openWrite();
  final skin2 = outputFile2.openWrite();
  Map<String,int> tt=result['productQuantities'];
 List<String> productNames=tt.keys.toList();
  /// 4] Write  processed data (map ) to output  files
  for (String productName in productNames ) {
    task.writeProductQuantity(
        result['productQuantities'] , productName, outputFile1, result['totalOrderNumber']);
    task.writeProductsMostPopularBrands(
        result['productBrands'], productName, outputFile2);
  }


  skin1.close();
  skin2.close();

}
